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
        title: const Text('Next Screen'),
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
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParentLoginPage()),
                );
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChildRegistrationForm()), // Use the registration form here
                );
              },
              child: const Text('Child Registration'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChildMainPage(childId: '',)),
                );
              },
              child: const Text('Child Main Page'),
            ),
          ],
        ),
      ),
    );
  }
}
