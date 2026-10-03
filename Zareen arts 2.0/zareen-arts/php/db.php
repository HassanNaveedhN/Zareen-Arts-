<?php
header("Content-Type: application/json");

$host = "localhost";
$db   = "zareen_arts";
$user = "root";
$pass = "";

// Turn on error reporting for MySQLi
mysqli_report(MYSQLI_REPORT_OFF);

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Database connection failed: " . $conn->connect_error
    ]);
    exit;
}

// Set UTF-8 character encoding
$conn->set_charset("utf8mb4");
?>