<?php

include 'dbh.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $patientId = $_POST['patientId'];
    $name = $_POST['name'];
    $age = $_POST['age'];
    $sex = $_POST['sex'];

    // Prepare and bind SQL statement for inserting patient details
    $stmt = $conn->prepare("INSERT INTO patients (patientId, name, age, sex) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssis", $patientId, $name, $age, $sex);

    // Execute SQL statement for inserting patient details
    if ($stmt->execute()) {
        // Send success response
        $response = [
            'success' => true,
            'message' => 'Patient details added successfully',
        ];
        echo json_encode($response);
    } else {
        // Error executing SQL statement for inserting patient details
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Failed to insert patient details']);
    }

    // Close statement for inserting patient details
    $stmt->close();
    // Close connection
    $conn->close();
} else {
    // Invalid request method
    http_response_code(405); // Method Not Allowed
    echo json_encode(['error' => 'Invalid request method']);
}
?>
