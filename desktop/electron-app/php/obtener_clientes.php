<?php
$host = 'localhost';
$user = 'root'; 
$password = ''; 
$database = 'clothes_app'; 

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Error en la conexión: " . $conn->connect_error);
}

$sql = "SELECT email, dni, country, language FROM users";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $clientes = [];
    while ($row = $result->fetch_assoc()) {
        $clientes[] = $row;
    }
    echo json_encode($clientes, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT); 
} else {
    echo json_encode([]); 
}

$conn->close();
?>
