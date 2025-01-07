<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit; 
}

$servername = "localhost";
$username = "root"; 
$password = "";     
$dbname = "clothes_app"; 

ob_start();

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(['success' => false, 'message' => 'Error de conexión a la base de datos']);
    ob_end_clean();
    exit();
}

$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;
if (!$user_id) {
    echo json_encode(['success' => false, 'message' => 'Falta el ID del usuario']);
    ob_end_clean();
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        $query = "
            SELECT 
                c.id, 
                c.product_id, 
                c.talla, 
                c.cantidad, 
                c.precio_total,
                p.imagen AS producto_imagen
            FROM 
                carrito c
            JOIN 
                productos p ON c.product_id = p.id
            WHERE 
                c.user_id = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $productos = [];
        while ($row = $result->fetch_assoc()) {
            $imagen_url = "http://localhost/clothes_app_php/images/" . $row["producto_imagen"];

            $productos[] = [
                "id" => $row["id"],
                "product_id" => $row["product_id"],
                "talla" => $row["talla"],
                "cantidad" => $row["cantidad"],
                "precio_total" => $row["precio_total"],
                "imagen" => $imagen_url,
            ];
        }

        $total = 0;
        foreach ($productos as $producto) {
            $total += $producto['precio_total'];
        }

        $output = [
            'success' => true,
            'productos' => $productos,
            'total' => $total
        ];

        ob_end_clean();
        echo json_encode($output);

    } catch (Exception $e) {
        error_log("Error en la consulta: " . $e->getMessage());
        ob_end_clean();
        echo json_encode(['success' => false, 'message' => 'Error al obtener los datos']);
    } finally {
        if (isset($stmt)) {
            $stmt->close();
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $producto_id = isset($_POST['producto_id']) ? $_POST['producto_id'] : null;
    if (!$producto_id) {
        echo json_encode(['success' => false, 'message' => 'Falta el ID del producto']);
        ob_end_clean();
        exit();
    }

    $sql = "DELETE FROM carrito WHERE user_id = ? AND product_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $user_id, $producto_id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Producto eliminado']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error al eliminar el producto']);
    }

    $stmt->close();
    $conn->close();
}
?>
