<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include 'dbh.php';

$input = json_decode(file_get_contents('php://input'), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($input['username'] ?? '');
    $password = trim($input['password'] ?? '');

    if (!$username || !$password) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Username and password are required.']);
        exit();
    }

    try {
        // Fetch user from the database
        $stmt = $conn->prepare("SELECT password FROM registration WHERE username = :username");
        $stmt->bindValue(':username', $username);
        $stmt->execute();
        $result = $stmt->fetch(); // Remove the argument or set fetch mode globally

        if ($result && password_verify($password, $result['password'])) {
            http_response_code(200);
            echo json_encode(['success' => true, 'message' => 'Login successful.']);
        } else {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Invalid username or password.']);
        }
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
}
?>
