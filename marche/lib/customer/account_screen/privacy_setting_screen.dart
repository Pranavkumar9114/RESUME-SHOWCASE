import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrivacySettingsScreenState createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _locationAccess = false;
  bool _dataCollection = true;
  bool _adPersonalization = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Permissions'),
          _buildSwitchListTile(
            title: 'Location Access',
            subtitle: 'Allow the app to access your location',
            value: _locationAccess,
            onChanged: (bool value) {
              setState(() {
                _locationAccess = value;
              });
            },
          ),
          _buildSwitchListTile(
            title: 'Data Collection',
            subtitle: 'Allow collection of usage data',
            value: _dataCollection,
            onChanged: (bool value) {
              setState(() {
                _dataCollection = value;
              });
            },
          ),
          _buildSwitchListTile(
            title: 'Ad Personalization',
            subtitle: 'Use your data to personalize ads',
            value: _adPersonalization,
            onChanged: (bool value) {
              setState(() {
                _adPersonalization = value;
              });
            },
          ),
          const Divider(),
          _buildSectionTitle('Legal'),
          _buildListTile(
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              // Handle privacy policy navigation
              _navigateToPrivacyPolicy(context);
            },
          ),
          _buildListTile(
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            onTap: () {
              // Handle terms of service navigation
              _navigateToTermsOfService(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: const Color.fromARGB(255, 33, 150, 243),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    // Placeholder for Privacy Policy navigation
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const PrivacyPolicyScreen()), // Navigate to actual Privacy Policy screen
    );
  }

  void _navigateToTermsOfService(BuildContext context) {
    // Placeholder for Terms of Service navigation
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const TermsOfServiceScreen()), // Navigate to actual Terms of Service screen
    );
  }
}

// Placeholder PrivacyPolicyScreen (implement according to your app's needs)
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Center(
        child: Text('Privacy Policy Content goes here.'),
      ),
    );
  }
}

// Placeholder TermsOfServiceScreen (implement according to your app's needs)
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: const Center(
        child: Text('Terms of Service Content goes here.'),
      ),
    );
  }
}