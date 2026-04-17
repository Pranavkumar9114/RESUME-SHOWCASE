import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:marche/customer/scannerscreen.dart';
import 'package:marche/customer/microphone.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController searchController;
  final SpeechRecognitionService _speechRecognitionService = SpeechRecognitionService();

  SearchPage({super.key, required this.searchController}) {
    _speechRecognitionService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.white : Colors.white;
    final iconColor = isDarkMode ? Colors.grey[850] : Colors.grey[850];
    final textColor = isDarkMode ? Colors.grey[850] : Colors.grey[850];
    final hintTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final cursorColor = isDarkMode ? Colors.grey[850] : Colors.grey[850];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Hero(
          tag: 'searchBarHero',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Increased padding
            decoration: BoxDecoration(
              color: backgroundColor,
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
                  icon: Icon(Icons.search,color: isDarkMode?Colors.black:Colors.black),
                  onPressed: () {
                  },
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    cursorColor: cursorColor,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: hintTextColor),
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                  ),
                ),
                IconButton(
                  icon: Icon(MdiIcons.barcodeScan, color: iconColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScannerPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.mic, color: iconColor),
                  onPressed: () {
                    _speechRecognitionService.listen(context, searchController);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Search Results",
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
