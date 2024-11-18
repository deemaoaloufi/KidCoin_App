import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'sign_up_page.dart';
import 'parent_main_screen.dart'; // Import ParentMainScreen

class ParentLoginPage extends StatefulWidget {
  const ParentLoginPage({super.key});

  @override
  _ParentLoginPageState createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = await AuthService().loginWithEmail(email, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Navigate to ParentMainScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ParentMainScreen(
              parentId: user.uid, // Pass the parentId
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parent Login',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold), // White bold text
        ),
        backgroundColor: Colors.purple[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log In to KidCoin',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[900]), // Dark purple text
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[200]!,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900]),
                    ),
                  ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _navigateToSignUp,
              child: Text(
                'Don’t have an account? Sign Up',
                style: TextStyle(color: Colors.purple[900]),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
