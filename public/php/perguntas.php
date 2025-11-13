<?php
require_once './../../src/db.php';
header('Content-Type: application/json');

try {
    $perguntas = getQuestoesAtivas();
    echo json_encode($perguntas);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
    exit;
}
