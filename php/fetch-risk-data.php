<?php
// Database connection details
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "diabetesrisk";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Fetch data from the 'risk' table
$sql = "SELECT * FROM risk ORDER BY TIMESTAMP DESC LIMIT 1";  // Fetch the latest record
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Fetch the first record
    $row = $result->fetch_assoc();
    echo json_encode(["success" => true, "data" => [$row]]);
} else {
    echo json_encode(["success" => false, "error" => "No data found."]);
}

$conn->close();
?>
