import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildListTile(
            title: 'FAQs',
            subtitle: 'Frequently Asked Questions',
            icon: Icons.question_answer,
            onTap: () {
              // Navigate to FAQs screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQsScreen()),
              );
            },
          ),
          _buildListTile(
            title: 'Contact Support',
            subtitle: 'Get help from our support team',
            icon: Icons.support_agent,
            onTap: () {
              // Navigate to Contact Support screen or open email client
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ContactSupportScreen()),
              );
            },
          ),
          _buildListTile(
            title: 'Submit Feedback',
            subtitle: 'Let us know your thoughts',
            icon: Icons.feedback,
            onTap: () {
              // Navigate to Feedback form screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackScreen()),
              );
            },
          ),
          _buildListTile(
            title: 'Troubleshooting Guide',
            subtitle: 'Fix common issues',
            icon: Icons.build,
            onTap: () {
              // Navigate to Troubleshooting Guide screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TroubleshootingScreen()),
              );
            },
          ),
          const Divider(),
          _buildListTile(
            title: 'Terms of Service',
            subtitle: 'Review our terms and conditions',
            icon: Icons.description,
            onTap: () {
              // Navigate to Terms of Service screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen()),
              );
            },
          ),
          _buildListTile(
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            icon: Icons.privacy_tip,
            onTap: () {
              // Navigate to Privacy Policy screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}

// Placeholder FAQs Screen
class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: const Center(
        child: Text('FAQs content goes here.'),
      ),
    );
  }
}

// Placeholder Contact Support Screen
class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
      ),
      body: const Center(
        child: Text('Contact Support content goes here.'),
      ),
    );
  }
}

// Placeholder Feedback Screen
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
      ),
      body: const Center(
        child: Text('Feedback form content goes here.'),
      ),
    );
  }
}

// Placeholder Troubleshooting Screen
class TroubleshootingScreen extends StatelessWidget {
  const TroubleshootingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Troubleshooting Guide'),
      ),
      body: const Center(
        child: Text('Troubleshooting guide content goes here.'),
      ),
    );
  }
}

// Placeholder Terms of Service Screen
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: const Center(
        child: Text('Terms of Service content goes here.'),
      ),
    );
  }
}

// Placeholder Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Center(
        child: Text('Privacy Policy content goes here.'),
      ),
    );
  }
}