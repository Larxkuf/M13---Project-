<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS"); 
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-Custom-Header");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-Custom-Header");
    exit;
}

include_once 'db.php'; 

try {
    $query = "SELECT productos.id, productos.nombre, productos.descripcion, productos.precio, productos.descuento, productos.imagen, productos.coleccion_id, productos.promocion_id, productos.id_categoria
              FROM productos";
    
    $result = $pdo->query($query);
    if (!$result) {
        echo json_encode(["error" => "No se pudieron obtener los productos."]);
        exit;
    }

    $productos = [];
    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
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

    echo json_encode($productos);

} catch (PDOException $e) {
    echo json_encode(["error" => "Error de base de datos: " . $e->getMessage()]);
}
?>
