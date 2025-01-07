<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
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

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";
$conn = connectDatabase($servername, $username, $password, $dbname);

$base_image_url = 'http://localhost/clothes_app_php/images/';  

$sql_colecciones = "SELECT id, nombre, descripcion, CONCAT('$base_image_url', imagen) AS imagen FROM colecciones";
$result_colecciones = $conn->query($sql_colecciones);

if (!$result_colecciones) {
    http_response_code(500);
    echo json_encode([ 
        'error' => true,
        'message' => 'Error al obtener colecciones: ' . $conn->error
    ]);
    $conn->close();
    exit;
}

$sql_productos = "SELECT p.id, p.nombre, p.descripcion, p.precio, CONCAT('$base_image_url', p.imagen) AS imagen, t.talla, t.stock
                  FROM productos p
                  LEFT JOIN tallas t ON p.id = t.producto_id";
$result_productos = $conn->query($sql_productos);

if (!$result_productos) {
    http_response_code(500);
    echo json_encode([ 
        'error' => true,
        'message' => 'Error al obtener productos: ' . $conn->error
    ]);
    $conn->close();
    exit;
}

$sql_categorias = "SELECT c.id, c.nombre, CONCAT('$base_image_url', c.imagen) AS imagen, c.id_indice
                   FROM categoria c";
$result_categorias = $conn->query($sql_categorias);

if (!$result_categorias) {
    http_response_code(500);
    echo json_encode([ 
        'error' => true,
        'message' => 'Error al obtener categorías: ' . $conn->error
    ]);
    $conn->close();
    exit;
}

$colecciones = [];
$productos = [];
$categorias = [];

while ($row = $result_colecciones->fetch_assoc()) {
    $colecciones[] = $row;
}

while ($row = $result_productos->fetch_assoc()) {
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

while ($row = $result_categorias->fetch_assoc()) {
    $categorias[] = $row;
}

$conn->close();

http_response_code(200);
echo json_encode([ 
    'error' => false,
    'colecciones' => $colecciones,
    'productos' => array_values($productos), 
    'categorias' => $categorias  
]);







 

















?>
