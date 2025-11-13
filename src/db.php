<?php
require_once './../../config.php';

function getQuestoesAtivas() {
    $pdo = getConnection();
    $stmt = $pdo->prepare("SELECT pegcodigo, pegtexto 
                                    FROM pergunta 
                                   WHERE pegstatus = 1 
                                   ORDER BY pegcodigo");
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

// mover isso para o perguntas, verificar o que faz mais sentido inserir aqui ou jogar tudo aqui
