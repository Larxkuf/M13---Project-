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
    exit;
}

header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-Custom-Header");


include_once 'db.php'; 

try {
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        error_log("Parámetro 'id' no proporcionado o vacío");
        echo json_encode(["error" => "ID del producto no proporcionado."]);
        exit;
    }

    $product_id = intval($_GET['id']);
    error_log("ID recibido: $product_id");

    $query = "
        SELECT 
            p.id, 
            p.nombre, 
            p.descripcion, 
            p.precio, 
            p.referencia, 
            p.color
        FROM productos p
        WHERE p.id = :product_id
    ";
    $stmt = $pdo->prepare($query);
    $stmt->bindParam(':product_id', $product_id, PDO::PARAM_INT);
    $stmt->execute();
    $product = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$product) {
        echo json_encode(["error" => "Producto no encontrado."]);
        exit;
    }

    $query_images = "SELECT imagen FROM producto_imagenes WHERE producto_id = :product_id";
    $stmt_images = $pdo->prepare($query_images);
    $stmt_images->bindParam(':product_id', $product_id, PDO::PARAM_INT);
    $stmt_images->execute();
    $images_raw = $stmt_images->fetchAll(PDO::FETCH_COLUMN);

    $base_image_url = "http://localhost/clothes_app_php/images/";
    $images = array_map(function ($image) use ($base_image_url) {
        return $base_image_url . $image;
    }, $images_raw);

    $query_sizes = "SELECT talla, stock FROM tallas WHERE producto_id = :product_id";
    $stmt_sizes = $pdo->prepare($query_sizes);
    $stmt_sizes->bindParam(':product_id', $product_id, PDO::PARAM_INT);
    $stmt_sizes->execute();
    $sizes = $stmt_sizes->fetchAll(PDO::FETCH_ASSOC);

    $response = [
        'product' => $product,
        'images' => $images,
        'sizes' => $sizes,
    ];

    echo json_encode($response);






$query_related = "
    SELECT 
        p.id, 
        p.nombre, 
        p.imagen
    FROM productos p
    WHERE p.relacion = :product_id
";

 $query_images = "SELECT imagen FROM producto_imagenes WHERE producto_id = :product_id";
 $stmt_images = $pdo->prepare($query_images);
 $stmt_images->bindParam(':product_id', $product_id, PDO::PARAM_INT);
 $stmt_images->execute();
 $images_raw = $stmt_images->fetchAll(PDO::FETCH_COLUMN);

 $base_image_url = "http://localhost/clothes_app_php/images/";
 $images = array_map(function ($image) use ($base_image_url) {
     return $base_image_url . $image;
 }, $images_raw);

$stmt_related = $pdo->prepare($query_related);
$stmt_related->bindParam(':product_id', $product_id, PDO::PARAM_INT);
$stmt_related->execute();
$related_products = $stmt_related->fetchAll(PDO::FETCH_ASSOC);

$response = [
    'product' => $product,
    'images' => $images,
    'sizes' => $sizes,
    'related_products' => $related_products,
];

} catch (PDOException $e) {
    echo json_encode(["error" => "Error de base de datos: " . $e->getMessage()]);
}

?>
