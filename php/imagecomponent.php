<?php

// Set the headers for CORS and API content type
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Include database connection
include 'dbh.php';

// Check if a POST request is received
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    // Check if a file is uploaded
    if (isset($_FILES['file_0'])) {
        
        $target_dir = "uploads/";

        // Create target directory if not exists
        if (!file_exists($target_dir)) {
            if (!mkdir($target_dir, 0755, true)) {
                http_response_code(500);
                echo json_encode(["success" => false, "message" => "Failed to create target directory"]);
                exit();
            }
        }

        $success = true;
        $messages = [];

        // Loop through the uploaded files
        foreach ($_FILES as $key => $file) {
            $original_file_name = $file['name'];
            $file_type = pathinfo($original_file_name, PATHINFO_EXTENSION); // Get file extension
            $unique_file_name = $target_dir . "imagecomponent." . $file_type; // Always save as "imagecomponent" with extension
            $file_size = $file['size'];

            // Validate file type (Only allow specific extensions)
            $allowed_types = ["jpg", "jpeg", "png", "gif", "pdf"];
            if (!in_array(strtolower($file_type), $allowed_types)) {
                $success = false;
                $messages[] = "Invalid file type for $original_file_name. Only JPG, JPEG, PNG, GIF, and PDF files are allowed.";
                continue;
            }

            // Validate file size (Max 5MB)
            if ($file_size > 5 * 1024 * 1024) {
                $success = false;
                $messages[] = "File size exceeds the limit of 5MB for $original_file_name.";
                continue;
            }

            // Move uploaded file to target directory
            if (move_uploaded_file($file['tmp_name'], $unique_file_name)) {
                
                // Prepare SQL statement to insert the file details into the images table
                $stmt = $conn->prepare("INSERT INTO images (filename, file_size, file_type, upload_date) VALUES (?, ?, ?, NOW())");

                // Bind values to the SQL statement
                $stmt->bindValue(1, $unique_file_name, PDO::PARAM_STR);
                $stmt->bindValue(2, $file_size, PDO::PARAM_INT);
                $stmt->bindValue(3, $file_type, PDO::PARAM_STR);

                // Execute the SQL statement
                if ($stmt->execute()) {
                    $messages[] = "File uploaded successfully: imagecomponent.$file_type.";
                } else {
                    $success = false;
                    $messages[] = "Error uploading $original_file_name: " . $stmt->errorInfo()[2];
                    error_log("Database error: " . $stmt->errorInfo()[2]);
                }

                // The PDOStatement will be automatically cleaned up when the script finishes execution, no need to call close() 
            } else {
                $success = false;
                $messages[] = "Sorry, there was an error uploading your file: $original_file_name.";
                error_log("File upload error for $original_file_name");
            }
        }

        // Return JSON response
        http_response_code($success ? 200 : 500);
        echo json_encode([
            "success" => $success,
            "message" => implode("\n", $messages)
        ]);
    } else {
        http_response_code(400); // Bad Request
        echo json_encode(["success" => false, "message" => "No files received."]);
    }
} else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(["success" => false, "message" => "Invalid request method. Only POST is allowed."]);
}

// Close the database connection
$conn = null;
?>
