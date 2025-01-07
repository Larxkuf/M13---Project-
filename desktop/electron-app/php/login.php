<?php
session_start();
include('db.php');

error_reporting(E_ALL);
ini_set('display_errors', 1);

$error_message = "";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];
    if (empty($email) || empty($password)) {
        $error_message = "Por favor ingrese ambos campos.";
    } else {
        $stmt = $conn->prepare("SELECT * FROM users_trabajadores WHERE email = ? AND status = 'active'");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();

        if ($user && password_verify($password, $user['password'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['role'] = $user['role'];

            error_log("Redirigiendo a start.html");

            header("Location: http://127.0.0.1/electron-app/screens/start.html");
            exit(); 
        } else {
            $error_message = "Correo o contraseña incorrectos o usuario inactivo.";
        }
    }
}
?>
