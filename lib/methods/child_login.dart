import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'child_main_page.dart'; // Importing the ChildMainPage

class ChildLoginScreen extends StatefulWidget {
  const ChildLoginScreen({super.key});

  @override
  _ChildLoginScreenState createState() => _ChildLoginScreenState();
}

class _ChildLoginScreenState extends State<ChildLoginScreen> {
  late TextEditingController _idController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

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
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('children')
          .where('childId', isEqualTo: enteredId)
          .get();

      if (query.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChildMainPage(childId: enteredId),
          ),
        );
      } else {
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
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: const Text(
          'Child Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple[300],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/ParentUI.png'), // Use a similar background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to KidCoin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.85),
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Unique ID Input Field
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple[100]!, Colors.purple[300]!],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'Unique ID',
                          prefixIcon: Icon(Icons.person, color: Colors.purple[600]),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7), // Softer hint text
                          ),
                          border: InputBorder.none, // Remove the border
                          focusedBorder: InputBorder.none, // Remove the border when focused
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.85), // Softer white text
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[200]!,
                              elevation: 8, // Add elevation for shadow effect
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
