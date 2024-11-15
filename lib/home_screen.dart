import 'package:flutter/material.dart';
import 'next_screen.dart'; // Import Next Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KidCoin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[300], // Lighter purple for the AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Hello, KidCoin User!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[900]), // Dark purple
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const NextScreen()), // Navigate to Next Screen
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.purple[200]!), // Lighter purple for buttons
              ),
              child: Text(
                'Access Other Screens',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[900]), // Dark purple for button text
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
    );
  }
}
