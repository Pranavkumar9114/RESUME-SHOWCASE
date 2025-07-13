import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        String storedName = userDoc['name'];
        if (storedName == name) {
          return userCredential.user;
        } else {
          throw Exception('Name does not match.');
        }
      } else {
        throw Exception('User document does not exist.');
      }
    } catch (e) {

      print('Error signing in: $e');

      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
