import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallfusion/pages/login.dart';
import 'package:wallfusion/services/signup_database.dart'; // Import your RealTimeDatabase class
import 'package:wallfusion/pages/home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _welcomeMessage = '';
  final RealTimeDatabase _realTimeDatabase = RealTimeDatabase();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _updateWelcomeMessage() {
    setState(() {
      _welcomeMessage =
          _nameController.text.isEmpty ? '' : 'Hi, ${_nameController.text}';
    });
  }

  Future<void> _signup(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        await _realTimeDatabase.signUpAndSaveData(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(title: 'Hello', email: _emailController.text)),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      // ignore: prefer_const_constructors
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220.0),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 16, 30, 30),
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
              Color.fromARGB(255, 18, 14, 31),
              Color.fromARGB(255, 67, 21, 53)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0, top: 20.0),
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
                      hintText: 'Enter your name',
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
                        return ('Please enter your name');
                      } else if (value.length < 3) {
                        return ('Name must be at least 3 characters long');
                      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return ('Name must contain only alphabetical characters and spaces');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    cursorColor: const Color.fromARGB(255, 39, 18, 18),
                    style: const TextStyle(
                        color: Color.fromARGB(
                            255, 39, 18, 18)), // Text color inside TextField
                    decoration: InputDecoration(
                      //labelText: 'Email',
                      hintText: 'Enter your email',
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
                        return ('Please enter your email');
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return ('Please enter a valid email');
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
                      //labelText: 'Create Password',
                      hintText: 'Enter your password',
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
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePasswordView,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('Please enter your password');
                      } else if (value.contains(RegExp(r'\s'))) {
                        return 'Password cannot contain spaces';
                      } else if (value.length < 8) {
                        return ('Need at least 8 characters long');
                      } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                        return ('Need at least one uppercase letter');
                      } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                        return ('Need at least one lowercase letter');
                      } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                        return ('Need at least one digit');
                      } else if (!RegExp(r'(?=.*[@$!%*?&.#])')
                          .hasMatch(value)) {
                        return ('Need at least one special character');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    cursorColor: const Color.fromARGB(255, 39, 18, 18),
                    style: const TextStyle(
                        color: Color.fromARGB(
                            255, 39, 18, 18)), // Text color inside TextField
                    decoration: InputDecoration(
                      //labelText: 'Rewrite Password',
                      hintText: 'Re-enter your password',
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
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('Please enter your password');
                      } else if (value.contains(RegExp(r'\s'))) {
                        return 'Password cannot contain spaces';
                      } else if (value.length < 8) {
                        return ('Need at least 8 characters long');
                      } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                        return ('Need at least one uppercase letter');
                      } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                        return ('Need at least one lowercase letter');
                      } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                        return ('Need at least one digit');
                      } else if (!RegExp(r'(?=.*[@$!%*?&.#])')
                          .hasMatch(value)) {
                        return ('Need at least one special character');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signup(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: const Color.fromARGB(
                          255, 36, 18, 47), // Background color
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _navigateToLogin(context),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 37),
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
    home: Signup(),
  ));
}
