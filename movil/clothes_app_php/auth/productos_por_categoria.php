<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type");
    exit(0); 
}

function connectDatabase($servername, $username, $password, $dbname) {
    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode([
            'error' => true,
            'message' => "Error en la conexión a la base de datos: " . $conn->connect_error
        ]);
        exit;
    }
    return $conn;
}

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["error" => "Error de conexión: " . $conn->connect_error]);
    exit;
}

if (!isset($_GET['categoria_id']) || empty($_GET['categoria_id'])) {
    echo json_encode(["error" => "ID de categoría no proporcionado"]);
    exit;
}

$categoria_id = intval($_GET['categoria_id']);

$query = "SELECT id, nombre, descripcion, precio, descuento, coleccion_id, promocion_id, imagen, id_categoria FROM productos WHERE id_categoria = ?";
$stmt = $conn->prepare($query);

if (!$stmt) {
    echo json_encode(["error" => "Error en la preparación de la consulta: " . $conn->error]);
    exit;
}

$stmt->bind_param("i", $categoria_id);
$stmt->execute();
$result = $stmt->get_result();

$productos = [];
while ($row = $result->fetch_assoc()) {
    $imagen_url = "http://localhost/clothes_app_php/images/" . $row["imagen"]; 

    $productos[] = [
        "id" => $row["id"] ?? null,
        "nombre" => $row["nombre"] ?? null, 
        "descripcion" => $row["descripcion"] ?? null,
        "precio" => $row["precio"] ?? null,
        "descuento" => $row["descuento"] ?? null,
        "coleccion_id" => $row["coleccion_id"] ?? null,
        "promocion_id" => $row["promocion_id"] ?? null,
        "imagen" => $imagen_url, 
        "id_categoria" => $row["id_categoria"] ?? null,
    ];
}

if (empty($productos)) {
    echo json_encode(["error" => "No se encontraron productos para esta categoría."]);
} else {
    echo json_encode($productos);
}

$stmt->close();
$conn->close();
?>
