
<?php
$servername = "localhost";
$username = "root"; 
$password = "";     
$dbname = "clothes_app"; 

include('db.php');

error_reporting(E_ALL);
ini_set('display_errors', 1);

$error_message = ''; 

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nombre = $_POST['nombre'] ?? '';
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    $confirm_password = $_POST['confirm_password'] ?? '';
    $dni = $_POST['dni'] ?? '';
    $role = $_POST['role'] ?? '';

    if (empty($nombre) || empty($email) || empty($password) || empty($confirm_password) || empty($dni) || empty($role)) {
        $error_message = "Todos los campos son obligatorios.";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error_message = "El correo electrónico no es válido.";
    } elseif ($password !== $confirm_password) {
        $error_message = "Las contraseñas no coinciden.";
    } else {
        $password_hashed = password_hash($password, PASSWORD_BCRYPT);

        $stmt = $conn->prepare("SELECT * FROM users_trabajadores WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $error_message = "El correo electrónico ya está registrado.";
        } else {
            $stmt = $conn->prepare("INSERT INTO users_trabajadores (nombre, email, password, dni, role, status) 
                                    VALUES (?, ?, ?, ?, ?, 'active')");
            $stmt->bind_param("sssss", $nombre, $email, $password_hashed, $dni, $role);

            if ($stmt->execute()) {
                header("Location: http://127.0.0.1/electron-app/screens/index.html");
                exit(); 
            } else {
                $error_message = "Error al registrar el trabajador: " . $stmt->error;
            }
        }
    }
}
?>

