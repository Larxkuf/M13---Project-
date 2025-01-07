<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

if (isset($_GET['id']) && !empty($_GET['id'])) {
    $proveedor_id = $_GET['id'];

    if (!is_numeric($proveedor_id)) {
        echo json_encode(["mensaje" => "ID de proveedor no válido."]);
        exit();
    }

    $sql = "SELECT p.id, p.nombre, p.precio, t.stock, t.talla, p.imagen
            FROM productos p
            JOIN tallas t ON p.id = t.producto_id
            WHERE p.proveedor_id = ?";

    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("i", $proveedor_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $productos = [];
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $productos[] = [
                    'id' => $row['id'],
                    'nombre' => $row['nombre'],
                    'precio' => $row['precio'],
                    'cantidad' => $row['stock'], 
                    'talla' => $row['talla'],  
                    'imagen' => $row['imagen']
                ];
            }
            echo json_encode($productos);
        } else {
            echo json_encode(["mensaje" => "No se encontraron productos para este proveedor."]);
        }
        $stmt->close();
    } else {
        echo json_encode(["mensaje" => "Error al preparar la consulta."]);
    }
} else if (isset($_POST['producto_id']) && isset($_POST['cantidad'])) {
    $producto_id = $_POST['producto_id'];
    $cantidad = $_POST['cantidad'];

    if (!is_numeric($producto_id) || !is_numeric($cantidad) || $cantidad <= 0) {
        echo json_encode(["mensaje" => "Datos no válidos para la actualización del stock."]);
        exit();
    }

    $sql_update = "UPDATE tallas SET stock = stock + ? WHERE producto_id = ?";
    
    if ($stmt = $conn->prepare($sql_update)) {
        $stmt->bind_param("ii", $cantidad, $producto_id);
        if ($stmt->execute()) {
            echo json_encode(["mensaje" => "Stock actualizado con éxito."]);
        } else {
            echo json_encode(["mensaje" => "Error al actualizar el stock."]);
        }
        $stmt->close();
    } else {
        echo json_encode(["mensaje" => "Error al preparar la consulta de actualización."]);
    }
} else {
    echo json_encode(["mensaje" => "ID de proveedor no proporcionado."]);
}

$conn->close();
?>
