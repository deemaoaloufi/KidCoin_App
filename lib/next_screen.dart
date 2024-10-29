import 'package:flutter/material.dart';
import '../methods/sign_up_page.dart';
import '../methods/parent_login_page.dart';
import '../methods/child_registration.dart';
import '../methods/child_main_page.dart';
import '../methods/child_login.dart'; // Import Child Login Screen

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Next Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[300],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple[200]!),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[900]),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ParentLoginPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple[200]!),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[900]),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildRegistrationForm(
                            parentId: 'sampleParentId',
                          )),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple[200]!),
              ),
              child: Text(
                'Child Registration',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[900]),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChildMainPage(
                            childId: 'sampleChildId',
                          )),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple[200]!),
              ),
              child: Text(
                'Child Main Page',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[900]),
              ),
            ),
            const SizedBox(height: 10),
            // Button for Child Login Screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildLoginScreen()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple[200]!),
              ),
              child: Text(
                'Child Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[900]),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
