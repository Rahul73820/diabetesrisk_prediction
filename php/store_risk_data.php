<?php
// Set up headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

try {
    // Ensure the request is a POST request
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); // Method Not Allowed
        echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
        exit();
    }

    // Include database connection file
    include 'dbh.php'; // Ensure this file connects to your MySQL database

    // Get the input JSON data from the body
    $data = json_decode(file_get_contents("php://input"), true);

    if ($data === null) {
        http_response_code(400); // Bad Request
        echo json_encode(['success' => false, 'message' => 'Invalid JSON input']);
        exit();
    }

    // Validate required fields
    $requiredFields = ['Gender', 'Predicted_VF_Area', 'Pancreas_Density', 'Diabetes_Risk'];
    foreach ($requiredFields as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            http_response_code(400); // Bad Request
            echo json_encode(['success' => false, 'message' => "Missing field: $field"]);
            exit();
        }
    }

    // Retrieve data from the request
    $gender = $data['Gender'];
    $predicted_vf_area = floatval($data['Predicted_VF_Area']);
    $pancreas_density = floatval($data['Pancreas_Density']);
    $diabetes_risk = $data['Diabetes_Risk'];

    // Prepare the SQL query to insert the data into the database
    $query = "INSERT INTO risk (Gender, Predicted_VF_Area, Pancreas_Density, Diabetes_Risk, TIMESTAMP) 
              VALUES (:Gender, :Predicted_VF_Area, :Pancreas_Density, :Diabetes_Risk, NOW())";

    // Prepare the SQL statement
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':Gender', $gender, PDO::PARAM_STR);
    $stmt->bindParam(':Predicted_VF_Area', $predicted_vf_area, PDO::PARAM_STR);
    $stmt->bindParam(':Pancreas_Density', $pancreas_density, PDO::PARAM_STR);
    $stmt->bindParam(':Diabetes_Risk', $diabetes_risk, PDO::PARAM_STR);

    // Execute the query
    if ($stmt->execute()) {
        http_response_code(201); // Created
        echo json_encode(['success' => true, 'message' => 'Diabetes Risk data stored successfully']);
    } else {
        http_response_code(500); // Internal Server Error
        echo json_encode(['success' => false, 'message' => 'Failed to store data']);
    }

} catch (Exception $e) {
    // Handle any exceptions
    http_response_code(500); // Internal Server Error
    echo json_encode(['success' => false, 'message' => 'An error occurred: ' . $e->getMessage()]);
}
?>
