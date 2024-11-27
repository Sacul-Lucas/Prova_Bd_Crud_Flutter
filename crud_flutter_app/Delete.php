<?php
// Incluir a conexão com o banco de dados
include 'Conexão.php';

if (isset($_POST['id'])) {
    $id = $_POST['id']; // Pegando o id como string

    // Consulta para deletar o registro baseado no id
    $sql = "DELETE FROM users WHERE id = ?";

    // Preparando a consulta para evitar SQL Injection
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param('s', $id); // O 's' representa que o id será passado como string
        if ($stmt->execute()) {
            echo "Registro deletado com sucesso.";
        } else {
            echo "Erro ao deletar o registro.";
        }
        $stmt->close();
    } else {
        echo "Erro na preparação da consulta.";
    }
}

$conn->close();
