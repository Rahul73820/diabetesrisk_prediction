import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>> _reportData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  // Fetch data from the server
  Future<void> fetchReportData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://180.235.121.245/diabetesrisk/csv.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _reportData = List<Map<String, dynamic>>.from(data);
        });
      } else {
        _showErrorDialog('Failed to fetch report data.');
      }
    } catch (error) {
      _showErrorDialog('An error occurred while fetching the report data.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Download CSV File
  Future<void> _downloadCSV() async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isGranted) {
        final response = await http.get(
          Uri.parse('http://180.235.121.245/diabetesrisk/csv.php?download=csv'),
        );

        if (response.statusCode == 200) {
          // Get the Downloads directory
          final directory = await getExternalStorageDirectory();
          final downloadPath = '${directory!.path}/Download';
          final downloadDir = Directory(downloadPath);

          if (!downloadDir.existsSync()) {
            downloadDir.createSync(recursive: true);
          }

          final file = File('$downloadPath/patient_report.csv');
          await file.writeAsBytes(response.bodyBytes);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('File downloaded to: ${file.path}'),
          ));
        } else {
          _showErrorDialog('Failed to download the CSV file.');
        }
      } else {
        _showErrorDialog('Storage permission denied.');
      }
    } catch (error) {
      _showErrorDialog('An error occurred while downloading the file.');
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Build the data table widget
  Widget _buildDataTable() {
    if (_reportData.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 18, color: Colors.redAccent),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Patient ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Age')),
          DataColumn(label: Text('Gender')),
          DataColumn(label: Text('Predicted VF Area')),
          DataColumn(label: Text('Pancreas Density')),
          DataColumn(label: Text('Diabetes Risk')),
        ],
        rows: _reportData.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data['PatientId'].toString())),
              DataCell(Text(data['Name'].toString())),
              DataCell(Text(data['Age'].toString())),
              DataCell(Text(data['Gender'].toString())),
              DataCell(Text(data['Predicted_VF_Area'].toString())),
              DataCell(Text(data['Pancreas_Density'].toString())),
              DataCell(Text(data['Diabetes_Risk'].toString())),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('CSV Report'),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _downloadCSV,
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildDataTable(),
            ),
    );
  }
}
