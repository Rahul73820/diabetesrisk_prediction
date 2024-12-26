import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'patient_details.dart'; // Import the PatientDetails screen
import 'login.dart'; 
import 'report_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  // Fetch patient details from the API
  Future<void> fetchPatientDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://180.235.121.245/diabetesrisk/get_patient_details_and_image.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _patients = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          _showAlertDialog('Error', 'Failed to fetch patient details: ${data['message']}');
        }
      } else {
        _showAlertDialog('Error', 'Failed to fetch patient details (Server error).');
      }
    } catch (error) {
      _showAlertDialog('Error', 'An error occurred while fetching patient details.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show alert dialog in case of errors
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Build the patient card widget
  Widget _buildPatientCard(Map<String, dynamic> patient) {
    var imageBytes = patient['image'] != null && patient['image'].isNotEmpty
        ? base64Decode(patient['image'])
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile icon (CircleAvatar)
          CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.blueAccent,
            child: imageBytes != null
                ? ClipOval(child: Image.memory(imageBytes, fit: BoxFit.cover, width: 80, height: 80))
                : const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(width: 16.0),

          // Patient data next to the profile icon
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient['name'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text('ID: ${patient['id']}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 5),
                Text('Age: ${patient['age']}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 5),
                Text('Gender: ${patient['gender']}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to LoginScreen and clear all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove all previous routes from the stack
        );
        return false; // Prevent default back action
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                );
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.blue[50],
                padding: const EdgeInsets.all(16.0),
                child: _patients.isNotEmpty
                    ? ListView.builder(
                        itemCount: _patients.length > 10 ? 10 : _patients.length, // Display up to 10 patients
                        itemBuilder: (context, index) {
                          return _buildPatientCard(_patients[index]);
                        },
                      )
                    : const Center(
                        child: Text(
                          'No patient data available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to the PatientDetails screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PatientDetails()),
              ).then((_) {
                // After returning from PatientDetails screen, refresh the patient list
                fetchPatientDetails();
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Patient Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
