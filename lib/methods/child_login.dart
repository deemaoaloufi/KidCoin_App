import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'child_main_page.dart'; // Importing the ChildMainPage

// ChildLoginScreen child enters unique id and navigates to the main page.
class ChildLoginScreen extends StatefulWidget {
  const ChildLoginScreen({super.key});

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

  // Verifies unique ID with the stored childId in Firestore
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
      // Query Firestore to find an exisiting child with the entered childId
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: enteredId)
          .get();

      if (query.docs.isNotEmpty) {
        // stores the child's name and goes to the ChildMainPage
        setState(() {
          _childName = query.docs.first['name'];
        });

        //  passes the childId to the ChildMainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChildMainPage(childId: enteredId),
          ),
        );
      } else {
        // Shows "Incorrect unique ID" if no matching childId is found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect unique ID')),
        );
      }
      // Shows "Error verifying ID" if no matching childId is found
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
        title: const Text('Child Login',
         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple[300],
        elevation: 6,
      ),
      backgroundColor: Colors.white, // Set background to white
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
                    onPressed: _signIn, // Updates the button action
                    child: const Text('Sign In'), // Change button to "Sign In"
                  ),
                ],
              ),
            ),
    );
  }
}
