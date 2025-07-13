//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:wallfusion/pages/home.dart';
//import 'package:wallfusion/pages/search.dart';
//import 'package:wallfusion/pages/home.dart';
import 'package:wallfusion/pages/signup.dart';
import 'package:wallfusion/pages/forgetpassword.dart';
import 'package:wallfusion/services/login_database.dart';
import 'package:wallfusion/services/google_signin.dart';
import 'package:wallfusion/pages/splashscreen.dart';

class Login extends StatefulWidget {
  // ignore: use_super_parameters
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _welcomeMessage = '';
  final LoginDatabase _loginDatabase = LoginDatabase();
  final AuthService _authService = AuthService();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    _loginIfAlreadyLoggedIn();
  }

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _loginIfAlreadyLoggedIn() async {
    User? user = await _loginDatabase.getCurrentUser();
    if (user != null) {
      // User is already logged in, navigate to home page
      _navigateToHome(user.email!);
    }
  }

  void _updateWelcomeMessage() {
    setState(() {
      _welcomeMessage =
          _nameController.text.isEmpty ? '' : 'Welcome ${_nameController.text}';
    });
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        String name = _nameController.text;
        User? user = await _loginDatabase.signInWithEmailAndPassword(
            _emailController.text, _passwordController.text, name);
        if (user != null) {
          // Login successful, navigate to home page
          _navigateToHome(user.email!);
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid credentials')),
          );
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: $e')),
        );
      }
    }
  }

  void _navigateToHome(String email) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SwipePageView(email: email)),
    ).then((_) {
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _welcomeMessage = '';
      });
      FocusScope.of(context).requestFocus(_emailFocus);
    });
  }

  // void _login(BuildContext context) {
  //   // Navigate to Home Page after login button pressed
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => MyHomePage(title: 'Hello', email: _emailController.text)),
  //   );
  //   Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(builder: (context) => MyHomePage(title: 'Hello', email: _emailController.text)),
  // ).then((_) {
  //   // Clear text fields when navigating back to Login page
  //   _nameController.clear();
  //   _emailController.clear();
  //   _passwordController.clear();
  //   // Reset welcome message
  //   setState(() {
  //     _welcomeMessage = '';
  //   });
  //   FocusScope.of(context).requestFocus(_nameFocus);
  // });
  // }

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  }

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPasswordPage()),
    );
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      // Navigate to home page
      _navigateToHome(user.email!);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220.0),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 18, 14, 31),
          flexibleSpace: Center(
            child: SizedBox(
              width: 200.0, // Set the width of the logo
              height: 200.0, // Set the height of the logo
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/secure.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 16, 30, 30),
              Color.fromARGB(255, 67, 21, 53)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0, top: 20.0),
                    child: Text(
                      _welcomeMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                      controller: _nameController,
                      cursorColor: const Color.fromARGB(255, 39, 18, 18),
                      focusNode: _nameFocus,
                      style: const TextStyle(
                          color: Color.fromARGB(
                              255, 39, 18, 18)), // Text color inside TextField
                      decoration: InputDecoration(
                        //labelText: 'Name',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 39, 18, 18)),
                        hintText: 'Enter Your Name',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(
                                255, 39, 18, 18)), // Hint text color
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color:
                                Color.fromARGB(255, 39, 18, 18), // Border color
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(
                                255, 39, 18, 18), // Border color when focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(
                                255, 39, 18, 18), // Border color when enabled
                          ),
                        ),
                      ),
                      onChanged: (_) => _updateWelcomeMessage(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    cursorColor: const Color.fromARGB(255, 39, 18, 18),
                    style: const TextStyle(
                        color: Color.fromARGB(
                            255, 39, 18, 18)), // Text color inside TextField
                    decoration: InputDecoration(
                      //labelText: 'Email',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 39, 18, 18)),
                      hintText: 'Enter Your Email',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(
                              255, 39, 18, 18)), // Hint text color
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color:
                              Color.fromARGB(255, 39, 18, 18), // Border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 39, 18, 18), // Border color when focused
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 39, 18, 18), // Border color when enabled
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    cursorColor: const Color.fromARGB(255, 39, 18, 18),
                    style: const TextStyle(
                        color: Color.fromARGB(
                            255, 39, 18, 18)), // Text color inside TextField
                    decoration: InputDecoration(
                      //labelText: 'Password',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 39, 18, 18)),
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(
                              255, 39, 18, 18)), // Hint text color
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color:
                              Color.fromARGB(255, 39, 18, 18), // Border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 39, 18, 18), // Border color when focused
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 39, 18, 18), // Border color when enabled
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ?  Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePasswordView,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: const Color.fromARGB(255, 36, 18, 47),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _navigateToForgotPassword(context),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () => _navigateToSignUp(context),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => _loginWithGoogle(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 58, 24, 28),
                    ),
                    child: const Text('Login with Google'),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}
// class SwipePageView extends StatelessWidget {
//   final String email;
//   final PageController _pageController = PageController(initialPage: 0);

//   SwipePageView({super.key, required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller: _pageController,
//       children: [
//         MyHomePage(title: 'Hello', email: email),
//         const SearchPage(),
//       ],
//     );
//   }
// }