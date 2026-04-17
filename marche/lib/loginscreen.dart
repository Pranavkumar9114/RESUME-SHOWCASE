import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marche/signupscreen.dart';
import 'package:marche/splashscreen.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null) {
 
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PageViewScreen()),
        );
      }
    });

   
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

   
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo or Header
                  Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: isDarkMode ? Colors.white : Colors.blueAccent,
                  ),
                  const SizedBox(height: 20),

                 
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: nameController,
                    builder: (context, value, child) {
               
                      String firstName = value.text.split(' ').first;
                      return Text(
                        'Welcome ${firstName.isEmpty ? 'Back!' : firstName}!',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please sign in to your account',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Name Input Field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: GoogleFonts.roboto(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white30 : Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : Colors.blue,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Email Input Field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: GoogleFonts.roboto(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white30 : Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : Colors.blue,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Password Input Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.roboto(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white30 : Colors.blue,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: isDarkMode ? Colors.white : Colors.blue,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Login Button
                  ElevatedButton(
                    onPressed: () async {
                      try {
                 
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const PageViewScreen()),
                          (Route<dynamic> route) =>
                              false, 
                        );
                      } catch (e) {
                       
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to login: $e'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.blueAccent : Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: isDarkMode ? Colors.blueAccent : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Optional: Social Media Sign-In Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.email,
                          size: 30,
                          color: isDarkMode ? Colors.redAccent : Colors.red,
                        ),
                        onPressed: () async {
                       
                          GoogleSignIn googleSignIn = GoogleSignIn();

                          try {
                        
                            await googleSignIn.signOut();

                      
                            GoogleSignInAccount? googleUser =
                                await googleSignIn.signIn();
                            if (googleUser != null) {
                              GoogleSignInAuthentication googleAuth =
                                  await googleUser.authentication;
                              AuthCredential credential =
                                  GoogleAuthProvider.credential(
                                accessToken: googleAuth.accessToken,
                                idToken: googleAuth.idToken,
                              );
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);

                      
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PageViewScreen()),
                                (Route<dynamic> route) =>
                                    false,
                              );
                            }
                          } catch (e) {
                        
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to sign in with Google: $e')),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.facebook,
                          size: 30,
                          color: isDarkMode ? Colors.blueAccent : Colors.blue,
                        ),
                        onPressed: () {
                          // Facebook login logic
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
