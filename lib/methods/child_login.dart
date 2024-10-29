import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'child_main_page.dart'; // Import the ChildMainPage

class ChildLoginScreen extends StatefulWidget {
  const ChildLoginScreen({Key? key}) : super(key: key);

  @override
  _ChildLoginScreenState createState() => _ChildLoginScreenState();
}

class _ChildLoginScreenState extends State<ChildLoginScreen> {
  late TextEditingController _idController;
  String? _childName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

  // Verify the unique ID with the stored childId in Firestore
  Future<void> _signIn() async {
    String enteredId = _idController.text.trim().toUpperCase();

    if (enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your unique ID')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Query Firestore to find a child with the entered childId
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: enteredId)
          .get();

      if (query.docs.isNotEmpty) {
        // Get the child's name and navigate to ChildMainPage
        setState(() {
          _childName = query.docs.first['name'];
        });

        // Navigate to ChildMainPage and pass the childId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChildMainPage(childId: enteredId),
          ),
        );
      } else {
        // Show error if no matching childId is found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect unique ID')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying ID: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Login'),
        backgroundColor: Colors.purple[300],
      ),
      backgroundColor: Colors.white, // Set background color of Scaffold to white
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_childName != null) ...[
                    Text(
                      'Welcome, $_childName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your unique ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signIn, // Update the button action
                    child: const Text('Sign In'), // Change button text to "Sign In"
                  ),
                ],
              ),
            ),
    );
  }
}
