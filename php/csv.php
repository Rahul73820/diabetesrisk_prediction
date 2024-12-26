<?php
// Include database connection file
//require 'dbh.php'; // Ensure this file establishes a proper PDO connection in $conn

// Check if "download" parameter is set in the request
if (isset($_GET['download']) && $_GET['download'] === 'csv') {
    try {
        // Prepare SQL query to fetch patient data
        $stmt = $conn->prepare("
            SELECT DISTINCT
                p.id AS PatientId, 
                p.name AS Name, 
                p.age AS Age, 
                p.gender AS Gender, 
                r.Predicted_VF_Area, 
                r.Pancreas_Density, 
                r.Diabetes_Risk 
            FROM patientdetails p
            JOIN risk r ON p.id = r.id
        ");
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Check if there is any data
        if (empty($results)) {
            // No data available
            header('Content-Type: text/plain');
            echo 'No data available to download.';
            exit;
        }

        // Set headers to force CSV file download
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="patient_report.csv"');

        // Open output stream to generate CSV
        $output = fopen('php://output', 'w');

        // Write CSV column headers
        fputcsv($output, ['PatientId', 'Name', 'Age', 'Gender', 'Predicted VF Area', 'Pancreas Density', 'Diabetes Risk']);

        // Write data rows to the CSV
        foreach ($results as $row) {
            fputcsv($output, $row);
        }

        // Close the output stream
        fclose($output);
        exit; // Ensure no further output is sent
    } catch (PDOException $e) {
        // Handle any errors during the process
        header('Content-Type: text/plain');
        echo "Error generating CSV: " . $e->getMessage();
        exit;
    }
} else {
    try {
        // If "download" is not set, return JSON data
        $stmt = $conn->prepare("
            SELECT DISTINCT
                p.id AS PatientId, 
                p.name AS Name, 
                p.age AS Age, 
                p.gender AS Gender, 
                r.Predicted_VF_Area, 
                r.Pancreas_Density, 
                r.Diabetes_Risk 
            FROM patientdetails p
            JOIN risk r ON p.id = r.id
        ");
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Return JSON response
        header('Content-Type: application/json');
        echo json_encode($results);
        exit;
    } catch (PDOException $e) {
        // Handle errors and send a JSON error message
        header('Content-Type: application/json');
        echo json_encode(['error' => 'Error fetching data: ' . $e->getMessage()]);
        exit;
    }
}
