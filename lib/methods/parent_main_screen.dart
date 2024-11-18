import 'package:flutter/material.dart';
import 'child_registration.dart';
import 'view_children_screen.dart'; // Import corrected child list screen
// ignore: unused_import
import 'child_progress_screen.dart'; // Import corrected child progress screen

class ParentMainScreen extends StatelessWidget {
  final String parentId;

  const ParentMainScreen({Key? key, required this.parentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parent Main Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChildRegistrationForm(parentId: parentId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[200],
              ),
              child: const Text(
                'Register a Child',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewChildrenScreen(parentId: parentId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[200],
              ),
              child: const Text(
                'View Children List',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 3d56edda834ad61f0588f94baab7d6e32cc138ca
