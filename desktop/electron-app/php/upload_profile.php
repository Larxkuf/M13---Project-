<?php 
session_start();
include 'db.php'; 

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['profile_picture'])) {
    $user_id = $_SESSION['user_id']; 
    $target_dir = "uploads/";
    $file_name = basename($_FILES['profile_picture']['name']);
    $target_file = $target_dir . time() . "_" . $file_name;
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

    $allowed_types = ['jpg', 'jpeg', 'png', 'gif'];
    if (!in_array($imageFileType, $allowed_types)) {
        echo "Solo se permiten archivos JPG, JPEG, PNG y GIF.";
        exit;
    }

    if (move_uploaded_file($_FILES['profile_picture']['tmp_name'], $target_file)) {
        $sql = "UPDATE users_trabajadores SET profile_picture = ? WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("si", $target_file, $user_id);

        if ($stmt->execute()) {
            header("Location: start.php"); 
            exit;
        } else {
            echo "Error al guardar la imagen en la base de datos.";
        }
    } else {
        echo "Error al subir el archivo.";
    }
}
?>
