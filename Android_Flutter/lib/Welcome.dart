import 'package:flutter/material.dart';
//import 'login.dart'; // Import the Login page

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: const Text(
          'Welcome',
          textAlign: TextAlign.center, // Center the AppBar title
        ),
        backgroundColor: Colors.blue,
        centerTitle: true, // Center the title in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the contents vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center the contents horizontally
          children: [
            // Use Align widget to center the text
            const Align(
              alignment: Alignment.center, // Center the text
              child: Text(
                 'Diabetes Risk Prediction',
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between text and image
            Image.asset(
              'assets/diabetes1.png', // Ensure the image path is correct
              width: 350, // Increased width
              height: 400, // Increased height
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30), // Space between image and button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Ensure the route is defined in the MaterialApp routes
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.blue, // Use backgroundColor instead of primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Increased border radius to 20
                ),
              ),
              child: const Text(
                "Let's Get Started",
                textAlign: TextAlign.center, // Center the button text
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
