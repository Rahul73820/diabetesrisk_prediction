import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'patient_details.dart';
import 'diabetes_risk.dart';

class ImageComponent extends StatefulWidget {
  const ImageComponent({super.key});

  @override
  _ImageComponentState createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent> {
  List<File> selectedFiles = [];
  bool isLoading = false;
  bool isUploadSuccessful = false;

  Future<void> selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          selectedFiles = result.paths.map((path) => File(path!)).toList();
        });
      }
    } catch (e) {
      print('Error while picking file: $e');
      _showAlert('Error', 'There was an error selecting the file.');
    }
  }

  Future<void> submitFiles() async {
    if (selectedFiles.isEmpty) {
      _showAlert('No file selected', 'Please select a file before submitting.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('http://180.235.121.245/diabetesrisk/imagecomponent.php');
    var request = http.MultipartRequest('POST', uri);

    for (int i = 0; i < selectedFiles.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'file_$i',
        selectedFiles[i].path,
        filename: selectedFiles[i].path.split('/').last,
      ));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = json.decode(responseData.body);

        if (jsonResponse['success']) {
          setState(() {
            isUploadSuccessful = true;
            selectedFiles = [];
          });
          _showAlert('Success', 'Files uploaded successfully.');
        } else {
          _showAlert('Error', 'Failed to upload files. ${jsonResponse['message']}');
        }
      } else {
        _showAlert('Error', 'Failed to upload files. Please try again.');
      }
    } catch (e) {
      print('Error uploading files: $e');
      _showAlert('Error', 'Failed to upload files. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget renderFileIcons() {
    return Column(
      children: selectedFiles.map((file) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.insert_drive_file, size: 30),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  file.path.split('/').last,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFiles.remove(file);
                  });
                },
                child: const Icon(Icons.cancel, color: Colors.red, size: 24),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Upload CT Images (or) Files'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PatientDetails()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/CT-scan-machine.jpg',
                width: 350,
                height: 400,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: selectFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Select File'),
                  ),
                  ElevatedButton(
                    onPressed: submitFiles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (selectedFiles.isNotEmpty) renderFileIcons(),
              if (isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isUploadSuccessful
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiabetesRisk(),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUploadSuccessful ? Colors.orange : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
