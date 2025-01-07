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

$servername = "localhost";
$username = "root";  
$password = "";      
$dbname = "clothes_app"; 
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

if (isset($_GET['user_id'])) {
    $userId = intval($_GET['user_id']); 

    $sql = "SELECT id, email, dni, country, language, currency
            FROM users
            WHERE id = ?";
    
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("i", $userId); 
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $userData = $result->fetch_assoc();

            echo json_encode($userData);
        } else {
            echo json_encode(["error" => "Usuario no encontrado"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["error" => "Error al consultar la base de datos"]);
    }
} else {
    echo json_encode(["error" => "ID de usuario no proporcionado"]);
}

$conn->close();
?>