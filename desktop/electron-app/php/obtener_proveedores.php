<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

$sql = "SELECT id, nombre, ubicacion, imagen FROM proveedores"; 
$result = $conn->query($sql);

$proveedores = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $proveedores[] = [
            'id' => $row['id'],
            'nombre' => $row['nombre'],
            'ubicacion' => $row['ubicacion'],
            'imagen' => $row['imagen']  
        ];
    }
} else {
    echo json_encode(["mensaje" => "No se encontraron proveedores."]);
    exit();
}

echo json_encode($proveedores);

$conn->close();
?>
