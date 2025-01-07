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

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['usuario_id']) || !isset($data['producto_id'])) {
        echo json_encode(["success" => false, "message" => "Datos incompletos"]);
        exit;
    }

    $usuario_id = intval($data['usuario_id']);
    $producto_id = intval($data['producto_id']);

    $check_query = "SELECT * FROM favoritos WHERE usuario_id = ? AND producto_id = ?";
    $stmt = $conn->prepare($check_query);
    $stmt->bind_param("ii", $usuario_id, $producto_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $delete_query = "DELETE FROM favoritos WHERE usuario_id = ? AND producto_id = ?";
        $stmt = $conn->prepare($delete_query);
        $stmt->bind_param("ii", $usuario_id, $producto_id);
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Favorito eliminado"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error al eliminar el favorito"]);
        }
    } else {
        $insert_query = "INSERT INTO favoritos (usuario_id, producto_id) VALUES (?, ?)";
        $stmt = $conn->prepare($insert_query);
        $stmt->bind_param("ii", $usuario_id, $producto_id);
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Favorito agregado"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error al agregar el favorito"]);
        }
    }

    $stmt->close();
    $conn->close();

} else {
    echo json_encode(["success" => false, "message" => "Método no permitido"]);
}
?>
