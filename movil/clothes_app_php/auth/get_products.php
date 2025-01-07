<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
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

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";
$conn = connectDatabase($servername, $username, $password, $dbname);

$base_image_url = 'http://127.0.0.1/clothes_app_php/images/';  

$coleccionesQuery = "SELECT id, nombre, CONCAT('$base_image_url', imagen) AS imagen FROM colecciones";
$coleccionesResult = $conn->query($coleccionesQuery);

$colecciones = [];
if ($coleccionesResult) {
    while ($row = $coleccionesResult->fetch_assoc()) {
        $colecciones[] = [
            'id' => $row['id'],
            'nombre' => $row['nombre'],
            'imagen' => $row['imagen'],
        ];
    }
}

$coleccion_id = isset($_GET['coleccion_id']) && is_numeric($_GET['coleccion_id']) ? $_GET['coleccion_id'] : null;

if ($coleccion_id) {
    $productosQuery = "SELECT p.id, p.nombre, p.descripcion, p.precio, CONCAT('$base_image_url', p.imagen) AS imagen, t.talla, t.stock
                       FROM productos p
                       LEFT JOIN tallas t ON p.id = t.producto_id
                       WHERE p.coleccion_id = $coleccion_id";
} else {
    $productosQuery = "SELECT p.id, p.nombre, p.descripcion, p.precio, CONCAT('$base_image_url', p.imagen) AS imagen, t.talla, t.stock
                       FROM productos p
                       LEFT JOIN tallas t ON p.id = t.producto_id";
}

$productosResult = $conn->query($productosQuery);

$productos = [];
if ($productosResult) {
    while ($row = $productosResult->fetch_assoc()) {
        if (!isset($productos[$row['id']])) {
            $productos[$row['id']] = [
                'id' => $row['id'],
                'nombre' => $row['nombre'],
                'descripcion' => $row['descripcion'],
                'precio' => $row['precio'],
                'imagen' => $row['imagen'],
                'tallas' => []
            ];
        }

        if ($row['talla']) {
            $productos[$row['id']]['tallas'][] = [
                'talla' => $row['talla'],
                'stock' => $row['stock']
            ];
        }
    }
}

$response = [
    'colecciones' => $colecciones,
    'productos' => array_values($productos), 
];

echo json_encode($response, JSON_PRETTY_PRINT);

$conn->close();
?>
