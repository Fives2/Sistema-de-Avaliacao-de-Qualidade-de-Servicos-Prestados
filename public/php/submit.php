<?php
require_once './../../src/db.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);
if (!$data || !isset($data['dispositivo']) || !isset($data['respostas']) || empty($data['respostas'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Dados inválidos ou incompletos.']);
    exit;
}

$dispositivo = $data['dispositivo'];
$respostas = $data['respostas'];
$feedback = trim($data['feedback'] ?? '');
$pdo = getConnection();

try {
    $pdo->beginTransaction();
    // Buscar discodigo e setcodigo pelo disnome
    $stmt = $pdo->prepare("SELECT discodigo, setcodigo FROM dispositivo WHERE discodigo = :codigoDispsitivo AND disstatus = 1");
    $stmt->execute(['codigoDispsitivo' => $dispositivo]);
    $dis = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$dis) {
        throw new Exception("Dispositivo não encontrado ou inativo.");
    }
    $discodigo = $dis['discodigo'];
    $setcodigo = $dis['setcodigo'];
    // Obter o próximo avacodigo (máximo atual + 1)
    $maxStmt = $pdo->query("SELECT COALESCE(MAX(avacodigo), 0) FROM avaliacoes");
    $max = $maxStmt->fetchColumn();
    $ava_id = $max + 1;
    // Inserir uma linha por pergunta, com o mesmo feedback em todas
    foreach ($respostas as $pegcodigo => $resnota) {
        $stmt = $pdo->prepare("INSERT INTO avaliacoes (avacodigo, setcodigo, pegcodigo, discodigo, resnota, resfeedback, avadatahora)
                                        VALUES (:ava, :set, :peg, :dis, :nota, :feed, CURRENT_TIMESTAMP)
    ");
        $stmt->execute([
            'ava' => $ava_id,
            'set' => $setcodigo,
            'peg' => $pegcodigo,
            'dis' => $discodigo,
            'nota' => $resnota,
            'feed' => $feedback
        ]);
        $ava_id++;  // Incrementar para a próxima inserção // verificar se isso é necessário
    }
    $pdo->commit();
    echo json_encode(['success' => true]);
} catch (Exception $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}