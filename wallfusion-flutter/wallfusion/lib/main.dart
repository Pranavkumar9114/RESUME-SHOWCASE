import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallfusion/Custom_Widgets/theme.dart';
import 'package:wallfusion/services/zip_operation.dart';
import 'package:wallfusion/pages/splashscreen.dart';  // Replace with the correct import path
import 'route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool extractionDone = prefs.getBool('extractionDone') ?? false;

  runApp(MyApp(extractionDone: extractionDone));
}

class MyApp extends StatelessWidget {
  final bool extractionDone;

  const MyApp({super.key, required this.extractionDone});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallfusion',
      themeMode: ThemeMode.system,
      theme: MyTheme.LightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
      home: extractionDone ? const SplashScreen() : ZipExtractorPage(),
      routes: {
        Myroutes.splashscreenroute: (context) => const SplashScreen(),
        // Other routes can be added here
      },
    );
  }
}
