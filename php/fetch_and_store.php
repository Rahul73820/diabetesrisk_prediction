<?php
session_start();

include 'dbh.php';

// Flask API URL
$flask_api_url = "http://192.168.26.135:5000/generate-data"; // Change to your Flask API URL


// Fetch new prediction data from Flask API
function fetch_from_flask_api($flask_api_url) {
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, $flask_api_url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    $response = curl_exec($curl);
    curl_close($curl);
    return json_decode($response, true);
}

// Get user_id from session
$user_id = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : null;

if (!$user_id) {
    echo json_encode(["error" => "User not logged in"]);
    exit();
}

// Check if the user has already seen the latest prediction
$sql = "SELECT * FROM risk WHERE user_id = ? ORDER BY id DESC LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$latest_prediction = $result->fetch_assoc();

// If the user has not seen the latest prediction, fetch a new one from the Flask API
if (!$latest_prediction) {
    // Fetch the data from the Flask API
    $new_prediction = fetch_from_flask_api($flask_api_url);
    if (!$new_prediction || empty($new_prediction['samples'])) {
        echo json_encode(["error" => "Failed to fetch data from Flask API"]);
        exit();
    }

    // Assuming that the Flask API returns an array of samples
    foreach ($new_prediction['samples'] as $data) {
        // Extract prediction data from Flask API
        $gender = $data['Gender'] ?? 'Unknown';
        $predicted_vf_area = $data['Predicted VF Area (cm²)'] ?? 0.0;
        $pancreas_density = $data['Pancreas Density (HU)'] ?? 0.0;
        $diabetes_risk = ($pancreas_density < 40 || $predicted_vf_area > 100) ? 'Yes' : 'No';

        // Insert new prediction into the risk table
        $sql = "INSERT INTO risk (user_id, Gender, Predicted_VF_Area, Pancreas_Density, Diabetes_Risk) 
                VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("issds", $user_id, $gender, $predicted_vf_area, $pancreas_density, $diabetes_risk);
        $stmt->execute();
    }

    // Fetch the latest prediction for the user
    $sql = "SELECT * FROM risk WHERE user_id = ? ORDER BY id DESC LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $latest_prediction = $result->fetch_assoc();
}

// Return the latest prediction for display
if ($latest_prediction) {
    echo json_encode($latest_prediction);
} else {
    echo json_encode(["error" => "No prediction data found"]);
}

// Close connection
$conn->close();
?>
