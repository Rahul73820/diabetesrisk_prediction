<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json");

include 'dbh.php'; // Ensure database connection is properly initialized

// Read the patient ID from the POST body
$data = json_decode(file_get_contents("php://input"), true);

// Check if the ID is provided
if (isset($data['id']) && !empty($data['id'])) {
    $patientId = $data['id'];

    // Delete the patient record from the database
    $query = "DELETE FROM patientdetails WHERE id = :id";
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':id', $patientId);

    // Execute the query and check if the deletion is successful
    if ($stmt->execute()) {
        // Optionally, delete the associated image file from the server if necessary
        $imageQuery = "SELECT image FROM patientdetails WHERE id = :id";
        $imageStmt = $conn->prepare($imageQuery);
        $imageStmt->bindParam(':id', $patientId);
        $imageStmt->execute();
        $patient = $imageStmt->fetch(PDO::FETCH_ASSOC);

        if ($patient && file_exists($patient['image'])) {
            unlink($patient['image']); // Delete the image file
        }

        echo json_encode(['success' => true, 'message' => 'Patient deleted successfully']);
    } else {
        http_response_code(500); // Internal Server Error
        echo json_encode(['success' => false, 'message' => 'Failed to delete patient']);
    }
} else {
    http_response_code(400); // Bad Request
    echo json_encode(['success' => false, 'message' => 'Patient ID is required']);
}
?>
