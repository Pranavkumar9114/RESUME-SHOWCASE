import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallfusion/Custom_Widgets/sliders/aigridimageshower.dart';

class AIWallpaperPage extends StatefulWidget {
  const AIWallpaperPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AIWallpaperPageState createState() => _AIWallpaperPageState();
}

class _AIWallpaperPageState extends State<AIWallpaperPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.robot,
              color: Color.fromARGB(255, 239, 18, 107),
              size: 35,
            ),
            const SizedBox(width: 57), // Adjust the spacing between icon and text as needed
            Text(
              'AI-WALLPAPER',
              style: GoogleFonts.alata(
                textStyle: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: const GridImageShower(
            jsonPath: 'assets/images/grid/days_data_aiwall_gridimageshower.json', // Update with your JSON path
            headerIcon: FontAwesomeIcons.robot, // Example icon, replace as needed
            iconColor: Colors.blue, // Example color, replace as needed
            iconSize: 0.0, // Example size, adjust as needed
            height: 15599,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
