<?php
header("Content-Type: application/json");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app";

include 'db.php'; 

$user_id = 1; 

$sql = "SELECT nombre, email, role, profile_picture FROM users_trabajadores WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id); 
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $worker_info = $result->fetch_assoc();
    echo json_encode($worker_info);
} else {
    echo json_encode(["error" => "Usuario no encontrado"]);
}

$stmt->close();
$conn->close();
?>
