import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 


class DiabetesRisk extends StatefulWidget {
  const DiabetesRisk({Key? key}) : super(key: key);

  @override
  _DiabetesRiskState createState() => _DiabetesRiskState();
}

class _DiabetesRiskState extends State<DiabetesRisk> {
  Map<String, dynamic> predictionData = {};
  Map<String, dynamic> previousData = {};
   

  final Map<String, dynamic> defaultData = {
    "Gender": "Female",
    "Predicted VF Area (cm²)": 100.0,
    "Pancreas Density (HU)": 40.0,
    "Diabetes Risk": "No",
  };

  @override
  void initState() {
    super.initState();
    predictionData = Map.from(defaultData);
    previousData = Map.from(defaultData);
     
  }


  void _generateNextValues() {
    setState(() {
      previousData = Map.from(predictionData);

      double predictedVFArea = Random().nextDouble() * 100 + 50; // Random between 50-150
      double pancreasDensity = Random().nextDouble() * 60 + 20; // Random between 20-80
      String risk = predictedVFArea > 120 ? 'Yes' : 'No';

      predictionData = {
        "Gender": predictionData['Gender'],
        "Predicted VF Area (cm²)": predictedVFArea,
        "Pancreas Density (HU)": pancreasDensity,
        "Diabetes Risk": risk,
      };
    });
  }

  void _resetValues() {
    setState(() {
      predictionData = Map.from(previousData);
    });
  }

  Future<void> _submitIndex() async {
    final Map<String, dynamic> dataToSend = {
      'Gender': predictionData['Gender'],
      'Predicted_VF_Area': predictionData['Predicted VF Area (cm²)'],
      'Pancreas_Density': predictionData['Pancreas Density (HU)'],
      'Diabetes_Risk': predictionData['Diabetes Risk'],
    };

    try {
      final response = await http.post(
        Uri.parse('http://180.235.121.245/diabetesrisk/store_risk_data.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dataToSend),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          _showSnackBar(responseData['message'], Colors.green);
          _clearDataAfterSubmit();
        } else {
          _showSnackBar(responseData['message'], Colors.red);
        }
      } else {
        _showSnackBar(
          'Error: ${response.statusCode} - ${response.reasonPhrase}',
          Colors.red,
        );
      }
    } catch (e) {
      _showSnackBar('Error communicating with the server: $e', Colors.red);
    }
  }

  void _clearDataAfterSubmit() {
    setState(() {
      predictionData = Map.from(defaultData);
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

   

   
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diabetes Risk Prediction'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Diabetes Risk Prediction',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/risk.png', height: 200, fit: BoxFit.contain),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.blueAccent, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender: ${predictionData['Gender']}'),
                    Text(
                        'Predicted VF Area: ${predictionData['Predicted VF Area (cm²)'].toStringAsFixed(2)} cm²'),
                    Text(
                        'Pancreas Density: ${predictionData['Pancreas Density (HU)'].toStringAsFixed(2)} HU'),
                    Text(
                      'Diabetes Risk: ${predictionData['Diabetes Risk']}',
                      style: TextStyle(
                        color: predictionData['Diabetes Risk'] == 'Yes'
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateNextValues,
                child: const Text('Next'),
              ),
              ElevatedButton(
                onPressed: _resetValues,
                child: const Text('Reset'),
              ),
              ElevatedButton(
                  onPressed: _submitIndex, child: const Text('Submit Data')),
               
             
               
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: DiabetesRisk()));
}
