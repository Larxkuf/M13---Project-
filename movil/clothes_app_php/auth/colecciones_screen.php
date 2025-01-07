<?php 
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0); 
}

function connectDatabase($servername, $username, $password, $dbname) {
    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode(['error' => true, 'message' => "Error de conexión: " . $conn->connect_error]);
        exit;
    }
    return $conn;
}

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = connectDatabase($servername, $username, $password, $dbname);

if (!isset($_GET['coleccion_id']) || empty($_GET['coleccion_id'])) {
    echo json_encode(["error" => "ID de colección no proporcionado"]);
    exit;
}

$coleccion_id = intval($_GET['coleccion_id']); 

if ($coleccion_id <= 0) {
    echo json_encode(["error" => "ID de colección no válido"]);
    exit;
}

$query = "SELECT id, nombre, descripcion, precio, descuento, coleccion_id, promocion_id, imagen, id_categoria FROM productos WHERE coleccion_id = ?";
$stmt = $conn->prepare($query);

if (!$stmt) {
    echo json_encode(["error" => "Error en la preparación de la consulta: " . $conn->error]);
    exit;
}

$stmt->bind_param("i", $coleccion_id);
$stmt->execute();
$result = $stmt->get_result();

$productos = [];
while ($row = $result->fetch_assoc()) {
    $imagen_url = "http://localhost/clothes_app_php/images/" . $row["imagen"];
    $productos[] = [
        "id" => $row["id"],
        "nombre" => $row["nombre"],
        "descripcion" => $row["descripcion"],
        "precio" => $row["precio"],
        "descuento" => $row["descuento"],
        "coleccion_id" => $row["coleccion_id"],
        "promocion_id" => $row["promocion_id"],
        "imagen" => $imagen_url,
        "id_categoria" => $row["id_categoria"],
    ];
}

if (empty($productos)) {
    echo json_encode(["error" => "No se encontraron productos para esta colección."]);
} else {
    echo json_encode($productos);
}

$stmt->close();
$conn->close();
?>
