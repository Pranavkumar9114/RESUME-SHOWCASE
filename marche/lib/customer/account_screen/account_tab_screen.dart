import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marche/customer/account_screen/account_setting_screen.dart';
import 'package:marche/customer/account_screen/app_setting_screen.dart';
import 'package:marche/customer/account_screen/notification_setting_screen.dart';
import 'package:marche/customer/account_screen/privacy_setting_screen.dart';
import 'package:marche/customer/account_screen/help_support_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: theme.scaffoldBackgroundColor, // Use background color based on theme
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(theme),
            const SizedBox(height: 20),
            _buildMenuItem(
              icon: Icons.person,
              text: 'Account Settings',
              onTap: () =>
                  _smoothNavigateTo(context, const AccountSettingsScreen()),
              textColor: theme.textTheme.bodyMedium?.color, // Updated to bodyMedium
            ),
            _buildDivider(theme),
            _buildMenuItem(
              icon: Icons.settings,
              text: 'App Settings',
              onTap: () =>
                  _smoothNavigateTo(context, const AppSettingsScreen()),
              textColor: theme.textTheme.bodyMedium?.color, // Updated to bodyMedium
            ),
            _buildDivider(theme),
            _buildMenuItem(
              icon: Icons.notifications,
              text: 'Notifications',
              onTap: () => _smoothNavigateTo(
                  context, const NotificationsSettingsScreen()),
              textColor: theme.textTheme.bodyMedium?.color, // Updated to bodyMedium
            ),
            _buildDivider(theme),
            _buildMenuItem(
              icon: Icons.lock,
              text: 'Privacy',
              onTap: () =>
                  _smoothNavigateTo(context, const PrivacySettingsScreen()),
              textColor: theme.textTheme.bodyMedium?.color, // Updated to bodyMedium
            ),
            _buildDivider(theme),
            _buildMenuItem(
              icon: Icons.help,
              text: 'Help & Support',
              onTap: () =>
                  _smoothNavigateTo(context, const HelpSupportScreen()),
              textColor: theme.textTheme.bodyMedium?.color, // Updated to bodyMedium
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: CachedNetworkImageProvider(
              'https://via.placeholder.com/150'), // Placeholder for profile image
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
                color: theme.textTheme.headlineMedium?.color, // Updated to headlineMedium
              ),
            ),
            Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodySmall?.color, // Updated to bodySmall
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
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.black),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      color: theme.dividerColor, // Use theme divider color
      height: 1,
      thickness: 0.5,
    );
  }
}

void _smoothNavigateTo(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}
