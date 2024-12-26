import 'package:flutter/material.dart';
import 'login.dart' as login;
import 'signup.dart' as signup; // Added prefix for SignupScreen
import 'dashboard.dart' as dashboard;
import 'patient_details.dart' as patient;
import 'image_component.dart' as image;
import 'welcome.dart';
import 'report_screen.dart';
import 'diabetes_risk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diabetes Risk Prediction',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(), // Ensure WelcomeScreen has a const constructor
        '/login': (context) => const login.LoginScreen(), // Using prefix for LoginScreen
        '/signup': (context) => const signup.SignupScreen(), // Using prefix for SignupScreen
        '/dashboard': (context) => const dashboard.DashboardScreen(),
         '/report_screen': (context) => const ReportScreen(),
        '/patient_details': (context) => const patient.PatientDetails(), // Using prefix for PatientDetails
        '/image_component': (context) => const image.ImageComponent(), // Using prefix for ImageComponent
         '/diabetes_risk': (context) => const DiabetesRisk(), // Added DiabetesRisk route
      },
    );
  }
}
