import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:marche/splashscreen.dart';
// import 'package:marche/routes.dart';
import 'package:marche/theme.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'customer/cart_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();                     
  await Firebase.initializeApp();
  InAppPayments.setSquareApplicationId('sandbox-sq0idb-iE20wkr1zSCQV9cw8ox0nA');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
      title: 'Marche',
      themeMode: ThemeMode.system,
      theme: MyTheme.LightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // routes: {
      // Myroutes.splashscreenroute: (context) => const SplashScreen(),
      // },
    ),
    );
  }
}
