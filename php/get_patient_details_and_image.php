<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json");

include 'dbh.php'; // Ensure database connection is properly initialized

// Query to fetch patient details from the database
$query = "SELECT * FROM patientdetails";
$stmt = $conn->prepare($query);
$stmt->execute();
$patients = $stmt->fetchAll(PDO::FETCH_ASSOC);

$response = [];

foreach ($patients as $patient) {
    // Get the image path from the database
    $imagePath = $patient['image']; // The path to the image stored in the 'patients/' folder

    if (file_exists($imagePath)) {
        // Get the image data and encode it to base64
        $imageData = base64_encode(file_get_contents($imagePath));
    } else {
        $imageData = null; // If image does not exist, set to null or handle it
    }

    // Add the patient data and image to the response array
    $response[] = [
        'id' => $patient['id'],
        'name' => $patient['name'],
        'age' => $patient['age'],
        'gender' => $patient['gender'],
        'image' => $imageData, // Send the base64 image data
    ];
}

echo json_encode(['success' => true, 'data' => $response]);
