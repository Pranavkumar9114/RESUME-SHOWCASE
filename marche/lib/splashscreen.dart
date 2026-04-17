import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marche/customer/homescreen.dart';
import 'package:marche/customer/scannerscreen.dart';
import 'package:marche/loginscreen.dart';
import 'package:marche/customer/product_screen/product_tab_screen.dart';
import 'package:marche/customer/account_screen/account_tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marche/customer/mapscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnLoginStatus();
  }

  _navigateBasedOnLoginStatus() async {
    await Future.delayed(const Duration(seconds: 5)); // Add a delay to show the splash screen

    // Check if the user is logged in (you can use Firebase Auth or SharedPreferences)
    User? user = FirebaseAuth.instance.currentUser; // Check Firebase Auth user status
    if (user != null) {
      // If the user is already logged in, navigate to PageViewScreen
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PageViewScreen(),
        ),
      );
    } else {
      // If the user is not logged in, navigate to LoginScreen
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Marché',
              style: GoogleFonts.aboreto(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Scan. Pay. Go.',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child:
                    Lottie.asset('assets/animation/splashscreen_loading.json'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.roboto(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  int _selectedIndex = 1;
  late SharedPreferences _prefs;
  String? _selectedLocation;
  bool _locationSelected = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  Future<void> _loadLocation() async {
    _prefs = await SharedPreferences.getInstance();
    _locationSelected = _prefs.getBool('locationSelected') ?? false;

    setState(() {
      if (_locationSelected) {
        _selectedLocation = _prefs.getString('selectedLocation');
      } else {
        _selectedLocation = null;
      }
    });
  }

  Future<void> _saveLocation(String location) async {
    await _prefs.setString('selectedLocation', location);
    await _prefs.setBool('locationSelected', true);
  }

  // Update the selected location when the user selects a new one
  // ignore: unused_element
  void _onLocationChanged(String? newLocation) {
    if (newLocation != null) {
      setState(() {
        _selectedLocation = newLocation;
        _locationSelected = true;
      });
      _saveLocation(newLocation);
    }
  }

  // Handle navigation between tabs
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 1) {
      setState(() {
        _selectedIndex = 1;
        _pageController.jumpToPage(1);
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          physics: _selectedIndex == 2
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          children: [
            const ScannerPage(),
            const MyHomePage(title: ''),
            MapPage(
              selectedLocation: _selectedLocation ?? '',
            ),
            const ProductOverviewScreen(),
            const AccountScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          selectedItemColor: isDarkMode ? Colors.blueAccent : Colors.blue,
          unselectedItemColor: isDarkMode ? Colors.grey : Colors.black54,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Product',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
