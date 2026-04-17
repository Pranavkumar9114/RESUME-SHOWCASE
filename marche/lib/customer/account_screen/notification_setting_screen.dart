import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsSettingsScreenState createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _sound = true;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSwitchListTile(
            title: 'Push Notifications',
            subtitle: 'Receive notifications on your device',
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          _buildSwitchListTile(
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          _buildSwitchListTile(
            title: 'SMS Notifications',
            subtitle: 'Receive notifications via SMS',
            value: _smsNotifications,
            onChanged: (bool value) {
              setState(() {
                _smsNotifications = value;
              });
            },
          ),
          const Divider(),
          _buildSwitchListTile(
            title: 'Notification Sound',
            subtitle: 'Enable sound for notifications',
            value: _sound,
            onChanged: (bool value) {
              setState(() {
                _sound = value;
              });
            },
          ),
          _buildSwitchListTile(
            title: 'Vibration',
            subtitle: 'Enable vibration for notifications',
            value: _vibration,
            onChanged: (bool value) {
              setState(() {
                _vibration = value;
              });
            },
          ),
        ],
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
}