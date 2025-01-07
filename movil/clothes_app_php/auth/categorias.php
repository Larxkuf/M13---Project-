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
    $query = "SELECT nombre FROM categoria";
    $result = $pdo->query($query);

    if (!$result) {
        echo json_encode(["error" => "No se pudieron obtener las categorías."]);
        exit;
    }

    $categoria = array();
    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
        $categoria[] = $row;
    }

    echo json_encode($categoria); 
} catch (PDOException $e) {
    echo json_encode(["error" => "Error de base de datos: " . $e->getMessage()]);
}
?>
