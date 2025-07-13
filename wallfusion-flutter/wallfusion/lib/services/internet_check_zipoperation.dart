import 'dart:io'; // For exit()
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:wallfusion/services/zip_operation.dart';

class InternetCheckUtil {
  static Future<bool> checkInternetConnection(BuildContext context) async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      // ignore: avoid_print
      print("Initial internet connection status: $result");
      if (!result) {
        // ignore: use_build_context_synchronously
        await _showErrorDialog(context);
      }
      return result;
    } catch (e) {
      // ignore: avoid_print
      print("Error checking internet connection: $e");
      return false;
    }
  }

  static Future<void> _showErrorDialog(BuildContext context) async {
    bool shouldExit = false;

    while (true) {
      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(); // Dismiss the current dialog
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ZipExtractorPage()),
        );
        return; // Exit the loop and method
      }

      await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'No Internet Connection',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(height: 16),
                Text(
                  'Please check your internet connection and try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  shouldExit = true;
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the current dialog
                  await Future.delayed(const Duration(seconds: 2)); // Wait before retrying
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
          );
        },
      );

      if (shouldExit) {
        exit(0); // Close the application if the user chooses to exit
        // ignore: dead_code
        return; // Exit the method
      }
    }
  }
}
