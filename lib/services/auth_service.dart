import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up with Email and Password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign Up Error: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

  // Login with Email and Password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Login Error: $e');
      throw Exception('Failed to login: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout Error: $e');
      throw Exception('Failed to log out: $e');
    }
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;
}
