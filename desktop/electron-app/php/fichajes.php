<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

if (!isset($_SESSION['user_id'])) {
    echo json_encode(["error" => "No estás autenticado."]);
    exit();
}

require_once('db.php'); 

$user_id = $_SESSION['user_id'];
$mensaje = '';
$trabajador = null;

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $sql_fichajes = "SELECT f.fecha_hora 
                     FROM fichajes f 
                     WHERE f.id_trabajador = ? 
                     ORDER BY f.fecha_hora DESC";

    $stmt_fichajes = $conn->prepare($sql_fichajes);
    $stmt_fichajes->bind_param("i", $user_id); 
    $stmt_fichajes->execute(); 
    $result_fichajes = $stmt_fichajes->get_result();

    $fichajes = [];

    if ($result_fichajes->num_rows > 0) {
        while ($row_fichajes = $result_fichajes->fetch_assoc()) {
            $fichajes[] = [
                'fecha_hora' => $row_fichajes['fecha_hora'],
            ];
        }
    } else {
        $fichajes[] = ["mensaje" => "No se han registrado fichajes aún."];
    }

    echo json_encode($fichajes);
    exit();
}


if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['numero_tarjeta'])) {
    $numero_tarjeta = $_POST['numero_tarjeta'];

    $stmt = $conn->prepare("SELECT * FROM users_trabajadores WHERE numero_tarjeta = ?");
    $stmt->bind_param("s", $numero_tarjeta);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $trabajador = $result->fetch_assoc();

        if ($trabajador['id'] == $user_id) {
            $fecha_hora = date('Y-m-d H:i:s');
            $stmt = $conn->prepare("INSERT INTO fichajes (id_trabajador, fecha_hora) VALUES (?, ?)");
            $stmt->bind_param("is", $trabajador['id'], $fecha_hora);
            if ($stmt->execute()) {
                $mensaje = "Fichaje realizado con éxito";
            } else {
                $mensaje = "Hubo un error al fichar. Inténtalo de nuevo.";
            }
        } else {
            $mensaje = "El número de tarjeta no corresponde con tu cuenta.";
        }
    } else {
        $mensaje = "Tarjeta no encontrada.";
    }

    echo json_encode(["mensaje" => $mensaje]);
    exit();
}
?>
