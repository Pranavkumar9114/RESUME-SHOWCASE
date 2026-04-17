import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marche/customer/account_screen/edit_profile_screen.dart';
import 'package:marche/customer/account_screen/change_password_screen.dart';
import 'package:marche/loginscreen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the current theme mode (light or dark)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Account Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: isDarkMode
            ? Colors.black
            : Colors.white, // Background color based on theme
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(isDarkMode),
            const SizedBox(height: 20),
            _buildMenuItem(
              icon: Icons.person,
              text: 'Edit Profile',
              onTap: () => _navigateTo(context, const EditProfileScreen()),
              isDarkMode: isDarkMode,
            ),
            _buildDivider(isDarkMode),
            _buildMenuItem(
              icon: Icons.security,
              text: 'Change Password',
              onTap: () => _navigateTo(context, const ChangePasswordScreen()),
              isDarkMode: isDarkMode,
            ),
            _buildDivider(isDarkMode),
            _buildMenuItem(
              icon: Icons.logout,
              text: 'Logout',
              textColor: Colors.red,
              onTap: () => _logout(context),
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? Colors.white
                    : Colors.black, // Text color based on theme
              ),
            ),
            Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? (isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      trailing: Icon(Icons.chevron_right,
          color: isDarkMode ? Colors.white : Colors.black),
      onTap: onTap,
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
      height: 1,
      thickness: 0.5,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Sign out the user session
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(); // Close the dialog
              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                MaterialPageRoute(
                  //builder: (context) => const RoleDecisionPage(),
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
