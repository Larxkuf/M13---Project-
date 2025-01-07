<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");  
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS"); 
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-Custom-Header, Access-Control-Allow-Headers"); 

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-Custom-Header");
    exit; 
}
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Error de conexión: " . $conn->connect_error]));
}

if (!isset($_GET['usuario_id'])) {
    echo json_encode(["success" => false, "message" => "Usuario no especificado"]);
    exit;
}

$usuario_id = intval($_GET['usuario_id']);

$query = "SELECT p.id, p.nombre, p.imagen FROM productos p
          JOIN favoritos f ON p.id = f.producto_id
          WHERE f.usuario_id = ?";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $usuario_id);
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

$stmt->close();
$conn->close();

echo json_encode($productos);
?>
