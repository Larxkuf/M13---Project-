<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clothes_app"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}
?>
