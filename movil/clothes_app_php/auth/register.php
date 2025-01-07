<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization"); 

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit; 
}

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$data = json_decode(file_get_contents('php://input'), true);

error_log("Datos recibidos: " . print_r($data, true)); 

if (!is_array($data)) {
    echo json_encode(['success' => false, 'message' => 'Datos inválidos']);
    exit;
}

$email = isset($data['email']) ? trim($data['email']) : null;
$password = isset($data['password']) ? trim($data['password']) : null;
$dni = isset($data['dni']) ? trim($data['dni']) : null; 
$currency = isset($data['currency']) ? trim($data['currency']) : null;
$country = isset($data['country']) ? trim($data['country']) : null;
$language = isset($data['language']) ? trim($data['language']) : null;

if (empty($email) || empty($dni) || empty($password) || empty($country) || empty($language) || empty($currency)) {
    echo json_encode(['success' => false, 'message' => 'Todos los campos son requeridos']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['success' => false, 'message' => 'Correo no válido']);
    exit;
}

$query = "SELECT * FROM users WHERE email = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if ($user) {
    echo json_encode(['success' => false, 'message' => 'El correo ya está registrado']);
    exit;
}

$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

try {
    $query = "INSERT INTO users (email, password, currency, dni, country, language) VALUES (?, ?, ?, ?, ?, ?);";
    $stmt = $conn->prepare($query);
    
    $stmt->bind_param("ssssss", $email, $hashedPassword, $currency, $dni, $country, $language); 
    $stmt->execute();
    
    echo json_encode(['success' => true, 'message' => 'Registro exitoso']);
} catch (Exception $e) {
    error_log("Error al registrar el usuario: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Error al registrar el usuario']);
}

$conn->close();
?>
