import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealTimeDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpAndSaveData({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserData(userCredential.user!.uid, name, email, password);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> _saveUserData(String userId, String name, String email, String password) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'password': password, 
      });
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }
}
