import 'package:flutter/material.dart';
import '../methods/sign_up_page.dart'; // Import Sign Up Page
import '../methods/parent_login_page.dart'; // Import Parent Login Page
import '../methods/child_registration.dart'; // Import Child Registration Page
import '../methods/child_main_page.dart'; // Import Child Main Page

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Next Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // White bold text
        ),
        backgroundColor: Colors.purple[300], // Lighter purple for the AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[200]!), // Lighter purple for buttons
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[900]), // Dark purple for button text
              ),
            ),
            const SizedBox(height: 10), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParentLoginPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[200]!), // Lighter purple for buttons
              ),
              child: Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[900]), // Dark purple for button text
              ),
            ),
            const SizedBox(height: 10), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChildRegistrationForm()), // Use the registration form here
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[200]!), // Lighter purple for buttons
              ),
              child: Text(
                'Child Registration',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[900]), // Dark purple for button text
              ),
            ),
            const SizedBox(height: 10), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChildMainPage(childId: '',)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple[200]!), // Lighter purple for buttons
              ),
              child: Text(
                'Child Main Page',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[900]), // Dark purple for button text
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
    );
  }
}
