import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isObscuredCurrent = true;
  bool _isObscuredNew = true;
  bool _isObscuredConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildPasswordField(
                label: 'Current Password',
                controller: _currentPasswordController,
                isObscured: _isObscuredCurrent,
                onVisibilityToggle: () {
                  setState(() {
                    _isObscuredCurrent = !_isObscuredCurrent;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'New Password',
                controller: _newPasswordController,
                isObscured: _isObscuredNew,
                onVisibilityToggle: () {
                  setState(() {
                    _isObscuredNew = !_isObscuredNew;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'Confirm New Password',
                controller: _confirmPasswordController,
                isObscured: _isObscuredConfirm,
                onVisibilityToggle: () {
                  setState(() {
                    _isObscuredConfirm = !_isObscuredConfirm;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleChangePassword,
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        // Call the API or authentication method to change the password.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context); // Navigate back after password is changed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New passwords do not match')),
        );
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}