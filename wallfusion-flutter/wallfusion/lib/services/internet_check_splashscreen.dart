import 'dart:io'; 
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:wallfusion/pages/splashscreen.dart';

class InternetCheckUtil {
  static Future<bool> checkInternetConnection(BuildContext context) async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
  
      print("Initial internet connection status: $result");
      if (!result) {
     
        await _showErrorDialog(context);
      }
      return result;
    } catch (e) {
     
      print("Error checking internet connection: $e");
      return false;
    }
  }

  static Future<void> _showErrorDialog(BuildContext context) async {
    bool shouldExit = false;

    while (true) {
      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {

        Navigator.of(context).pop();
       
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
        return; 
      }

      await showDialog(
  
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
                  Navigator.of(context).pop(); 
                  await Future.delayed(const Duration(seconds: 2)); 
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
        exit(0); 
   
        return; 
      }
    }
  }
}
