// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:marche/customer/mapscreen.dart';
import 'package:marche/customer/searchscreen.dart';
import 'package:marche/customer/scannerscreen.dart';
// import 'package:marche/customer/microphone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marche/customer/carouselslider1.dart';
import 'package:marche/customer/productgrid1.dart';
import 'package:marche/customer/productgrid2.dart';
import 'package:marche/customer/productgrid3.dart';
import 'package:marche/customer/productgrid4.dart';
import 'package:marche/customer/cart_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  // late SpeechRecognitionService _speechRecognitionService;
  late SharedPreferences _prefs;
  String? _selectedLocation;
  bool _locationSelected = false;

  final List<String> _locations = [
    'Saket Select Walk',
    'Ansal Plaza',
    'Ambience Mall, Gurgaon',
  ];

  @override
  void initState() {
    super.initState();
    // _speechRecognitionService = SpeechRecognitionService();
    // _speechRecognitionService.initialize();
    _loadLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  bool get wantKeepAlive => true;

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    FocusScope.of(context).unfocus();
  }

  void _onSearchBarTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          searchController: TextEditingController(),
        ),
      ),
    ).then((_) {
      FocusScope.of(context).unfocus();
    });
  }

  // void _onMicPressed() {
  //   _speechRecognitionService.listen(context, TextEditingController());
  // }

  void _onLocationChanged(String? newLocation) {
    if (newLocation != null) {
      setState(() {
        _selectedLocation = newLocation;
        _locationSelected = true;
      });
      _saveLocation(newLocation);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(selectedLocation: newLocation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? Colors.black : const Color.fromARGB(255, 191, 244, 99),
        title: Row(
          children: [
            Image.asset(
              'assets/logo/without_bg.png',
              height: 40,
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Marché',
              style: GoogleFonts.aboreto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(MdiIcons.faceManProfile),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              color: isDarkMode ? Colors.grey[850] : Colors.grey[300],
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedLocation,
                      hint: const Text("Please select your location"),
                      onChanged: _onLocationChanged,
                      items: _locations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(
                            location,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.edit_location,
                  //     color: isDarkMode ? Colors.white : Colors.black,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => MapPage(
                  //           selectedLocation: _selectedLocation!,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search,
                        color: isDarkMode ? Colors.black : Colors.black),
                    onPressed: _onSearchBarTap,
                  ),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(),
                      style: TextStyle(
                          color: isDarkMode ? Colors.black : Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.transparent,
                      onTap: _onSearchBarTap,
                    ),
                  ),
                  IconButton(
                    icon: Icon(MdiIcons.barcodeScan,
                        color: isDarkMode ? Colors.black : Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScannerPage()),
                      );
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.mic, color: isDarkMode ? Colors.black : Colors.black),
                  //   onPressed: _onMicPressed,
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                carouselslider1(),
                SizedBox(height: 50),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Grocery',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ]),
                SizedBox(height: 10),
                productgrid1(),
                SizedBox(height: 10),
                productgrid2(),
                SizedBox(height: 10),
                productgrid3(),
                SizedBox(height: 10),
                productgrid4(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
