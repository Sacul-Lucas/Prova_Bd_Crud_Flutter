<?php
// Incluir a conexão com o banco de dados
include 'Conexão.php';

// Consulta para pegar todos os usuários
$sql = "SELECT * FROM users";
$result = $conn->query($sql);

// Array para armazenar os dados dos usuários
$users = array();

// Verifica se há registros no banco de dados
if ($result->num_rows > 0) {
    // Loop através de todos os resultados e adiciona ao array
    while ($row = $result->fetch_assoc()) {
        $users[] = $row; // Adiciona o usuário ao array
    }

    // Codifica o array em JSON e envia como resposta
    echo json_encode($users);
} else {
    // Se não houver registros, envia uma resposta vazia
    echo json_encode([]);
}

// Fecha a conexão com o banco de dados
$conn->close();
