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

$sql_compras = "SELECT user_id, metodo_pago, metodo_envio, direccion, fecha_compra, total 
                FROM compras";
$result_compras = $conn->query($sql_compras);

$compras = [];
if ($result_compras->num_rows > 0) {
    while ($row_compras = $result_compras->fetch_assoc()) {
        $compras[] = [
            'user_id' => $row_compras['user_id'],
            'metodo_pago' => $row_compras['metodo_pago'],
            'metodo_envio' => $row_compras['metodo_envio'],
            'direccion' => $row_compras['direccion'],
            'fecha_compra' => $row_compras['fecha_compra'],
            'total' => $row_compras['total'],
        ];
    }
} else {
    $compras[] = ["mensaje" => "No se encontraron compras registradas."];
}

echo json_encode($compras);

$conn->close();
?>
