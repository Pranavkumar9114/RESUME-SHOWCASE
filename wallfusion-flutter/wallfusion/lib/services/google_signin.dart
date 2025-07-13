import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        // ignore: avoid_print
        print('Google sign-in aborted by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        // ignore: avoid_print
        print('New user signed in with Google');
        // Handle new user scenario if needed
      } else {
        // ignore: avoid_print
        print('Existing user signed in with Google');
      }

      return userCredential.user;
    } catch (e) {
      // ignore: avoid_print
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect(); // Disconnect to clear cached credentials
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out: $e');
    }
  }
}
