<?php
ob_start(); 
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

$data = json_decode(file_get_contents('php://input'), true);

try {
    if (!isset($data['user_id'], $data['metodo_pago'], $data['metodo_envio'], $data['fecha_compra'])) {
        throw new Exception("Faltan parámetros obligatorios");
    }

    $user_id = $data['user_id'];
    $metodo_pago = $data['metodo_pago'];
    $metodo_envio = $data['metodo_envio'];
    $fecha_compra = $data['fecha_compra'];
    $total = 0;
    $direccion = '';

    if ($metodo_envio === 'Domicilio') {
        if (empty($data['direccion'])) {
            throw new Exception("Debe proporcionar una dirección de envío.");
        }
        $direccion = $data['direccion'];
    } elseif ($metodo_envio === 'Tienda') {
        if (empty($data['direccion_tienda'])) {
            throw new Exception("Debe seleccionar una tienda.");
        }
        $direccion = $data['direccion_tienda'];
    } else {
        throw new Exception("Método de envío no válido.");
    }

    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        throw new Exception("Error al conectar a la base de datos: " . $conn->connect_error);
    }

    $conn->begin_transaction();

    $query_cesta = "SELECT * FROM carrito WHERE user_id = ?";
    $stmt_cesta = $conn->prepare($query_cesta);
    $stmt_cesta->bind_param("i", $user_id);
    $stmt_cesta->execute();
    $result_cesta = $stmt_cesta->get_result();

    if ($result_cesta->num_rows === 0) {
        throw new Exception("El carrito está vacío.");
    }

    while ($producto = $result_cesta->fetch_assoc()) {
        $total += $producto['precio_total'] * $producto['cantidad']; 
    }

    $query = "INSERT INTO compras (user_id, metodo_pago, metodo_envio, direccion, fecha_compra, total) 
              VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("issssd", $user_id, $metodo_pago, $metodo_envio, $direccion, $fecha_compra, $total);

    if (!$stmt->execute()) {
        throw new Exception("Error al registrar la compra: " . $stmt->error);
    }

    $compra_id = $conn->insert_id;

    $result_cesta->data_seek(0);
    while ($producto = $result_cesta->fetch_assoc()) {
        if (empty($producto['product_id'])) {
            throw new Exception("El producto en el carrito no tiene un ID válido.");
        }

        $query_detalle_compra = "INSERT INTO detalle_compra (compra_id, carrito_id, talla, cantidad, precio_total, producto_id, user_id) 
                                    VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt_detalle_compra = $conn->prepare($query_detalle_compra);
        $stmt_detalle_compra->bind_param("iisddii", $compra_id, $producto['id'], $producto['talla'], $producto['cantidad'], 
                                           $producto['precio_total'], $producto['product_id'], $producto['user_id']);

        if (!$stmt_detalle_compra->execute()) {
            throw new Exception("Error al registrar el detalle del producto: " . $stmt_detalle_compra->error);
        }

        $query_stock = "UPDATE tallas SET stock = stock - ? WHERE producto_id = ? AND talla = ?";
        $stmt_stock = $conn->prepare($query_stock);
        $stmt_stock->bind_param("iis", $producto['cantidad'], $producto['product_id'], $producto['talla']);

        if (!$stmt_stock->execute()) {
            throw new Exception("Error al actualizar el stock: " . $stmt_stock->error);
        }
    }

    $query_eliminar_cesta = "DELETE FROM carrito WHERE user_id = ?";
    $stmt_eliminar_cesta = $conn->prepare($query_eliminar_cesta);
    $stmt_eliminar_cesta->bind_param("i", $user_id);

    if (!$stmt_eliminar_cesta->execute()) {
        throw new Exception("Error al eliminar productos del carrito: " . $stmt_eliminar_cesta->error);
    }

    $conn->commit();

    echo json_encode(['success' => true, 'compra_id' => $compra_id, 'total' => $total]);

} catch (Exception $e) {
    if (isset($conn)) {
        $conn->rollback(); 
    }
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
} finally {
    if (isset($conn)) {
        $conn->close();
    }
}
