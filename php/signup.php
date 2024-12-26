<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'dbh.php';

$input = json_decode(file_get_contents('php://input'), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($input['name'] ?? '');
    $mobile = trim($input['mobile'] ?? '');
    $email = trim($input['email'] ?? '');
    $username = trim($input['username'] ?? '');
    $password = trim($input['password'] ?? '');
    $registration_date = trim($input['registration_date'] ?? '');

    if (!$name || !$mobile || !$email || !$username || !$password || !$registration_date) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'All fields are required.']);
        exit();
    }

    // Validate email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Invalid email format.']);
        exit();
    }

    // Validate mobile
    if (!preg_match('/^[0-9]{10}$/', $mobile)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Invalid mobile number.']);
        exit();
    }

    // Check if username exists
    $checkQuery = "SELECT * FROM registration WHERE username = :username";
    $stmt = $conn->prepare($checkQuery);
    $stmt->bindValue(':username', $username);
    $stmt->execute();
    if ($stmt->rowCount() > 0) {
        http_response_code(409);
        echo json_encode(['success' => false, 'message' => 'Username already exists.']);
        exit();
    }

    // Hash password
    $hashed_password = password_hash($password, PASSWORD_BCRYPT);

    // Insert user into database
    $insertQuery = "INSERT INTO registration (name, mobile, email, username, password, registration_date) 
                    VALUES (:name, :mobile, :email, :username, :password, :registration_date)";
    $stmt = $conn->prepare($insertQuery);
    $stmt->bindValue(':name', $name);
    $stmt->bindValue(':mobile', $mobile);
    $stmt->bindValue(':email', $email);
    $stmt->bindValue(':username', $username);
    $stmt->bindValue(':password', $hashed_password);
    $stmt->bindValue(':registration_date', $registration_date);

    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode(['success' => true, 'message' => 'Registration successful.']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Registration failed.']);
    }
}
?>
