<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Content-Type: application/json");

include 'dbh.php'; // Ensure database connection is properly initialized

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit();
}

$data = json_decode(file_get_contents("php://input"), true);

if ($data === null) {
    http_response_code(400); // Bad Request
    echo json_encode(['success' => false, 'message' => 'Invalid JSON']);
    exit();
}

$requiredFields = ['id', 'name', 'age', 'gender', 'image'];
foreach ($requiredFields as $field) {
    if (empty($data[$field])) {
        http_response_code(400); // Bad Request
        echo json_encode(['success' => false, 'message' => "Missing field: $field"]);
        exit();
    }
}

// Decode and save the image
$imageData = base64_decode($data['image']);
$imageDir = 'patients/';

if (!is_dir($imageDir) && !mkdir($imageDir, 0777, true)) {
    http_response_code(500); // Internal Server Error
    echo json_encode(['success' => false, 'message' => 'Failed to create image directory']);
    exit();
}

$imageName = uniqid() . '.png';
$imagePath = $imageDir . $imageName;

if (!file_put_contents($imagePath, $imageData)) {
    http_response_code(500); // Internal Server Error
    echo json_encode(['success' => false, 'message' => 'Failed to upload image']);
    exit();
}

// Insert data into the database
$query = "INSERT INTO patientdetails (id, name, age, gender, image) VALUES (:id, :name, :age, :gender, :image)";
$stmt = $conn->prepare($query);

try {
    $stmt->bindParam(':id', $data['id']);
    $stmt->bindParam(':name', $data['name']);
    $stmt->bindParam(':age', $data['age'], PDO::PARAM_INT);
    $stmt->bindParam(':gender', $data['gender']);
    $stmt->bindParam(':image', $imagePath);

    if ($stmt->execute()) {
        http_response_code(201); // Created
        echo json_encode(['success' => true, 'message' => 'Patient details added successfully']);
    } else {
        error_log(message: 'Database execution error: ' . print_r($stmt->errorInfo(), true));
        http_response_code(500); // Internal Server Error
        echo json_encode(['success' => false, 'message' => 'Failed to add details']);
    }
} catch (PDOException $e) {
    http_response_code(500); // Internal Server Error
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
