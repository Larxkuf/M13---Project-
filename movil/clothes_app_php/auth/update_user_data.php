<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$email = isset($_POST['email']) ? $_POST['email'] : '';
$country = isset($_POST['country']) ? $_POST['country'] : '';
$language = isset($_POST['language']) ? $_POST['language'] : '';
$currency = isset($_POST['currency']) ? $_POST['currency'] : '';
$id = isset($_POST['id']) ? (int)$_POST['id'] : 0;

if (empty($email) || empty($country) || empty($language) || empty($currency) || $id === 0) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Todos los campos son obligatorios y el ID debe ser válido'
    ]);
    exit();
}

$sql = "UPDATE users SET email = ?, country = ?, language = ?, currency = ? WHERE id = ?";
$stmt = $conn->prepare($sql);

if ($stmt === false) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Error al preparar la consulta'
    ]);
    exit();
}

$stmt->bind_param("ssssi", $email, $country, $language, $currency, $id);

if ($stmt->execute()) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Datos actualizados con éxito'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Error al actualizar los datos'
    ]);
}

$stmt->close();
$conn->close();
?>
