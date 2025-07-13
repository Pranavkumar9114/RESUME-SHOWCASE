import 'dart:convert'; // Import the dart:convert library for JSON parsing
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for loading JSON files
import 'package:google_fonts/google_fonts.dart';
import 'package:wallfusion/pages/home.dart'; // Import the home page
import 'package:wallfusion/pages/drawer.dart';
import 'package:wallfusion/pages/login.dart';
import 'package:wallfusion/pages/switch_bar_pages/ai_wall.dart';
import 'package:wallfusion/pages/switch_bar_pages/download.dart';
import 'package:wallfusion/pages/switch_bar_pages/live_wall.dart';
import 'package:wallfusion/services/internet_check_splashscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate background process

    String firstLetter =
        user?.email?.isNotEmpty ?? false ? user!.email![0].toUpperCase() : 'N';

    if (user != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SwipePageView(email: firstLetter)));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  Future<void> preloadHomePage() async {
    final List<String> allFiles = [
      'assets/images/days_data_carouselslider.json',
      'assets/images/days_data_t_phoneimageslider.json',
      'assets/images/days_data_p_phoneimageslider.json',
      'assets/images/grid/days_data_anime_gridimageshower.json',
      'assets/images/grid/days_data_marvel_gridimageshower.json',
      'assets/images/singleimageslider/slide1.json',
      'assets/images/singleimageslider/slide2.json',
      'assets/images/singleimageslider/slide3.json',
      'assets/images/singleimageslider/slide4.json',
      'assets/images/singleimageslider/slide5.json',
      'assets/images/singleimageslider/slide6.json',
      'assets/images/singleimageslider/slide7.json',
      'assets/images/singleimageslider/slide8.json',
      'assets/images/singleimageslider/slide9.json',
      'assets/images/singleimageslider/slide10.json',
      'assets/images/logo1.png',
      'assets/images/logo4.png',
      'assets/images/splashscreen_background/splashscreen_bg.jpg',
      // 'assets/images/splashscreen_background/splashscreen_bg2.png'
      // 'assets/images/splashscreen_background/splashscreen_bg3.jpg'
      // 'assets/images/splashscreen_background/splashscreen_bg4.png'
      // 'assets/images/splashscreen_background/splashscreen_bg5.png'
      // 'assets/images/splashscreen_background/splashscreen_bg6.jpg'
      // 'assets/images/splashscreen_background/splashscreen_bg7.jpg'
    ];

    List<String> imageUrls = [];
    List<String> localImagePaths = [];

    // Get current day of the week as lowercase
    String currentDay = DateTime.now().weekday.toString().toLowerCase();

    for (String file in allFiles) {
      if (file.endsWith('.json')) {
        // Load JSON data
        final String response = await rootBundle.loadString(file);
        final data = json.decode(response);

        // Extract URLs for the current day (case insensitive)
        var dayData = data['days'].firstWhere(
          (day) => day['day'].toString().toLowerCase() == currentDay,
          orElse: () => null,
        );

        if (dayData != null) {
          imageUrls.addAll(List<String>.from(dayData['urls']));
        }
      } else {
        // Directly add local image paths to localImagePaths
        localImagePaths.add(file);
      }
    }

    // Preload images
    for (String url in imageUrls) {
      if (url.endsWith('.json')) {
        // Load JSON file and process
        final String response = await rootBundle.loadString(url);
        final data = json.decode(response);

        // Process JSON data, if needed
        // ignore: avoid_print
        print(data);
      } else {
        // Precache NetworkImage for URLs
        // ignore: use_build_context_synchronously
        await precacheImage(NetworkImage(url), context);
      }
    }

    // Precache local images
    for (String imagePath in localImagePaths) {
      final ImageProvider imageProvider = AssetImage(imagePath);
      // ignore: use_build_context_synchronously
      await precacheImage(imageProvider, context);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInternetAndProceed();
  }

Future<void> _checkInternetAndProceed() async {
  try {
    if (!mounted) return;
    bool isConnected = await InternetCheckUtil.checkInternetConnection(context);
    // ignore: avoid_print
    print("Internet connection status: $isConnected");
    if (isConnected) {
      await preloadHomePage();
      await checkAuthentication();
    } else {
      // ignore: avoid_print
      print("No internet connection");
    }
  } catch (e) {
    // ignore: avoid_print
    print("Error during internet check or processing: $e");
  }
}

  String _getBackgroundImagePath() {
    final int dayOfWeek = DateTime.now().weekday;
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'assets/images/splashscreen_background/splashscreen_bg2.png';
      case DateTime.tuesday:
        return 'assets/images/splashscreen_background/splashscreen_bg3.jpg';
      case DateTime.wednesday:
        return 'assets/images/splashscreen_background/splashscreen_bg.jpg';
      case DateTime.thursday:
        return 'assets/images/splashscreen_background/splashscreen_bg4.png';
      case DateTime.friday:
        return 'assets/images/splashscreen_background/splashscreen_bg5.png';
      case DateTime.saturday:
        return 'assets/images/splashscreen_background/splashscreen_bg6.jpg';
      case DateTime.sunday:
        return 'assets/images/splashscreen_background/splashscreen_bg7.jpg';
      default:
        return 'assets/images/splashscreen_background/splashscreen_bg.jpg';
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDarkMode ? Colors.black : Colors.black;
    Color textColor = isDarkMode ? Colors.white : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage(_getBackgroundImagePath()),
                fit: BoxFit.cover,
              ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'WallFusion',
                        style: GoogleFonts.aboreto(
                          textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Innovative | MuralFusion | Dynamic",
                        style: GoogleFonts.abel(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Version 1.0.0',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ],
        ),
    );
  }
}

class SwipePageView extends StatelessWidget {
  final String email;
  final PageController _pageController = PageController(initialPage: 1);

  SwipePageView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.page != 1) {
          _pageController.jumpToPage(1);
          return false;
        }
        return true;
      },
      child: PageStorage(
        bucket: PageStorageBucket(),
        child: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          children: [
            HalfPageDrawer(
              onaiwallpaperView: () {
                _pageController.jumpToPage(3); // Navigate to AI Wallpaper page
              },
              onlivewallpaperView: () {
                _pageController
                    .jumpToPage(2); // Navigate to Live Wallpaper page
              },
              ondownloadwallpaperView: () {
                _pageController.jumpToPage(4); // Navigate to Download page
              },
            ),
            MyHomePage(title: 'Hello', email: email),
            const LiveWallpaperPage(),
            const AIWallpaperPage(),
            const DownloadPage(),
          ],
        ),
      ),
    );
  }
}
