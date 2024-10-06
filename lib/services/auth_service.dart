import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return result.user; // This returns User? (nullable)
    } catch (e) {
      print(e.toString());
      return null; // Return null if there's an error
    }
  }

  // Sign in user
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return result.user; // This returns User? (nullable)
    } catch (e) {
      print(e.toString());
      return null; // Return null if there's an error
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}


