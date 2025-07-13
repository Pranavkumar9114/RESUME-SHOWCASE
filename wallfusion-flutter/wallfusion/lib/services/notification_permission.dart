import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionService {
  static bool _isRequesting = false;

  static Future<void> checkNotificationPermission(BuildContext context) async {
    if (_isRequesting) return;

    _isRequesting = true;
    try {
      final NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        final PermissionStatus status = await Permission.notification.request();

        if (status.isGranted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification permissions granted.')),
          );
        } else {
          // ignore: use_build_context_synchronously
          _showPermissionDialog(context);
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification permissions already granted.')),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error checking notification permission: $e");
    } finally {
      _isRequesting = false;
    }
  }

  static void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Text('Please enable notifications in your device settings to receive updates.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
