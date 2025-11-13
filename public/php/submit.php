<?php
require_once './../../src/db.php';
header('Content-Type: application/json');

// MODIFICAR: Mover para SRC
// por enquanto está simulando o dispositivo 1, modificar depois da criação do login e crud

/**
 * Lê e valida os dados enviados no corpo da requisição.
 */
function getRequestData(){
    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data ||
        !isset($data['dispositivo']) ||
        !isset($data['respostas']) ||
        empty($data['respostas'])) {
        sendError(400, "Dados inválidos ou incompletos.");
    }

    return $data;
}

/**
 * Envia uma resposta de erro padronizada.
 * 
 * @param int $statusCode
 * @param string $message
 */
function sendError($statusCode, $message){
    http_response_code($statusCode);
    echo json_encode(['success' => false, 'message' => $message]);
    exit;
}

/**
 * Busca o discodigo e setcodigo do dispositivo.
 * 
 * @param PDO $pdo
 * @param int $dispositivo
 * @return array
 */
function buscarDadosDoDispositivo(PDO $pdo, $dispositivo){
    $sql = "SELECT discodigo, setcodigo 
            FROM dispositivo 
            WHERE discodigo = :codigo AND disstatus = 1";

    $stmt = $pdo->prepare($sql);
    $stmt->execute(['codigo' => $dispositivo]);

    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$result) {
        throw new Exception("Dispositivo não encontrado ou inativo.");
    }

    return $result;
}

/**
 * Obtém o próximo código de avaliação (avacodigo).
 * 
 * @param PDO $pdo
 * @return int
 */
function gerarNovoCodigoAvaliacao(PDO $pdo){
    $maxStmt = $pdo->query("SELECT COALESCE(MAX(avacodigo), 0) FROM avaliacoes");
    $max = $maxStmt->fetchColumn();
    $ava_id = $max + 1;
    return $ava_id;
}

/**
 * Insere as respostas da avaliação na tabela.
 * 
 * @param PDO $pdo
 * @param int $avaId
 * @param int $setcodigo
 * @param int $discodigo
 * @param array $respostas
 * @param string $feedback
 */
function inserirAvaliacoes(PDO $pdo, $avaId, $setcodigo, $discodigo, $respostas, $feedback){
    $sql = "INSERT INTO avaliacoes 
              (avacodigo, setcodigo, pegcodigo, discodigo, resnota, resfeedback, avadatahora)
            VALUES 
              (:ava, :set, :peg, :dis, :nota, :feed, CURRENT_TIMESTAMP)";

    $stmt = $pdo->prepare($sql);

    foreach ($respostas as $pegcodigo => $nota) {
        $stmt->execute([
            'ava'  => $avaId,
            'set'  => $setcodigo,
            'peg'  => $pegcodigo,
            'dis'  => $discodigo,
            'nota' => $nota,
            'feed' => $feedback
        ]);
        $avaId++;  // Incrementar para a próxima inserção // verificar se isso é necessário (Chave verificar se pegcodigo não é chave?)
    }
}

/**
 * Envia resposta JSON de sucesso.
 */
function enviaSucesso(){
    echo json_encode(['success' => true]);
    exit;
}

/* ----------------------------------------------------
   EXECUÇÃO PRINCIPAL DO SCRIPT
----------------------------------------------------- */

$data = getRequestData();
$pdo = getConnection();

$dispositivo = $data['dispositivo'];
$respostas   = $data['respostas'];
$feedback    = trim($data['feedback'] ?? '');

try {
    $pdo->beginTransaction();

    // 1. Busca dados do dispositivo
    $dadosDis = buscarDadosDoDispositivo($pdo, $dispositivo);

    // 2. Gera o próximo ID de avaliação
    $avaId = gerarNovoCodigoAvaliacao($pdo);

    // 3. Insere todas as avaliações
    inserirAvaliacoes(
        $pdo,
        $avaId,
        $dadosDis['setcodigo'],
        $dadosDis['discodigo'],
        $respostas,
        $feedback
    );

    $pdo->commit();
    enviaSucesso();

} catch (Exception $e) {

    // Reverte a transação em caso de erro
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }

    sendError(500, $e->getMessage());
}

