// File: api/firebase/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseService.instance.auth;

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Login Error: ${e.message}");
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Register Error: ${e.message}");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
