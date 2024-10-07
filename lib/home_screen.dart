import 'package:flutter/material.dart';
import 'next_screen.dart'; // Import Next Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KidCoin'),
        backgroundColor: Colors.blue[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Hello, KidCoin User!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue), 
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextScreen()), // Navigate to Next Screen
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo[100]!),
              ),
              child: Text(
                'Access Other Screens',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[900]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
