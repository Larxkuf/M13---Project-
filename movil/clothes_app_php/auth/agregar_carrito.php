<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json');

header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS"); 
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-Custom-Header");
}

$servername = "localhost";
$username = "root";  
$password = "";  
$dbname = "clothes_app"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$data = json_decode(file_get_contents('php://input'), true);

file_put_contents('php://stderr', print_r($data, true));

if (!isset($data['user_id']) || !isset($data['product_id']) || !isset($data['talla'])) {
    echo json_encode(['success' => false, 'message' => 'Faltan datos requeridos']);
    exit();
}

$user_id = $data['user_id'];
$product_id = $data['product_id'];
$talla = $data['talla'];
$cantidad = isset($data['cantidad']) ? $data['cantidad'] : 1;

$productQuery = "SELECT precio FROM productos WHERE id = ?";
$stmt = $conn->prepare($productQuery);
$stmt->bind_param("i", $product_id);
$stmt->execute();
$stmt->bind_result($precio);
$stmt->fetch();
$stmt->close();

$precio_total = $precio * $cantidad;

$checkQuery = "SELECT id FROM carrito WHERE user_id = ? AND product_id = ? AND talla = ?";
$stmt = $conn->prepare($checkQuery);
$stmt->bind_param("iis", $user_id, $product_id, $talla);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    $updateQuery = "UPDATE carrito SET cantidad = cantidad + ?, precio_total = precio_total + ? WHERE user_id = ? AND product_id = ? AND talla = ?";
    $stmt = $conn->prepare($updateQuery);
    $stmt->bind_param("iiisi", $cantidad, $precio_total, $user_id, $product_id, $talla);
    $stmt->execute();

    echo json_encode(['success' => true, 'message' => 'Carrito actualizado']);
} else {
    $insertQuery = "INSERT INTO carrito (user_id, product_id, talla, cantidad, precio_total) VALUES (?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($insertQuery);
    $stmt->bind_param("iisid", $user_id, $product_id, $talla, $cantidad, $precio_total);
    $stmt->execute();

    echo json_encode(['success' => true, 'message' => 'Producto agregado al carrito']);
}

$stmt->close();
$conn->close();
?>
