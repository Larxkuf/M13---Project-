<?php 
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : 0;

if ($user_id <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'ID de usuario no válido']);
    exit();
}

$sql = "
    SELECT 
        c.id, 
        c.metodo_pago, 
        c.metodo_envio, 
        c.direccion, 
        c.fecha_compra, 
        c.total
    FROM 
        compras c
    WHERE 
        c.user_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);  

$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $compras = [];
    while ($row = $result->fetch_assoc()) {
        $compras[] = $row;
    }
    echo json_encode(['compras' => $compras]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No se encontraron compras']);
}

$stmt->close();
$conn->close();
?>
