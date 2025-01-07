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

$compra_id = isset($_GET['id']) ? $_GET['id'] : '';

if (!empty($compra_id)) {
    $sql_detalles = "SELECT id, compra_id, carrito_id, talla, cantidad, precio_total, producto_id, user_id 
                     FROM detalle_compra 
                     WHERE compra_id = '$compra_id'";

    $result_detalles = $conn->query($sql_detalles);

    $detalles = [];
    if ($result_detalles->num_rows > 0) {
        while ($row_detalles = $result_detalles->fetch_assoc()) {
            $detalles[] = [
                'id' => $row_detalles['id'],
                'compra_id' => $row_detalles['compra_id'],
                'carrito_id' => $row_detalles['carrito_id'],
                'talla' => $row_detalles['talla'],
                'cantidad' => $row_detalles['cantidad'],
                'precio_total' => $row_detalles['precio_total'],
                'producto_id' => $row_detalles['producto_id'],
                'user_id' => $row_detalles['user_id']
            ];
        }
    } else {
        $detalles[] = ["mensaje" => "No se encontraron detalles para esta compra."];
    }

    echo json_encode($detalles);
} else {
    echo json_encode(["mensaje" => "ID de compra no proporcionado."]);
}

$conn->close();
?>
