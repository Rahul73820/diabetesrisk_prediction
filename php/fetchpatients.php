<?php
header('Content-Type: application/json');

include 'dbh.php';

// Fetch patients data, limit to 10
$sql = "SELECT patientId, name, age, gender, image FROM patientdetails LIMIT 10";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $patients = array();
    while ($row = $result->fetch_assoc()) {
        $patients[] = $row;
    }
    echo json_encode(array('success' => true, 'patients' => $patients));
} else {
    echo json_encode(array('success' => false, 'message' => 'No patients found'));
}

$conn->close();
?>
