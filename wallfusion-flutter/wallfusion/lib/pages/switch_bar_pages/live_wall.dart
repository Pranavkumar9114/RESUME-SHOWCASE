import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallfusion/Custom_Widgets/sliders/video_gridimageshower.dart';

class LiveWallpaperPage extends StatefulWidget {
  // ignore: use_super_parameters
  const LiveWallpaperPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LiveWallpaperPageState createState() => _LiveWallpaperPageState();
}

class _LiveWallpaperPageState extends State<LiveWallpaperPage> with AutomaticKeepAliveClientMixin {
     @override
  bool get wantKeepAlive => true;
  String currentCategory = 'anime'; // Default category

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
            const FaIcon(
              FontAwesomeIcons.tv,
              color: Color.fromARGB(255, 255, 103, 27),
              size: 25,
            ),
            const SizedBox(width: 53), 
              Text(
                'LIVE-WALLPAPER',
                style: GoogleFonts.aclonica(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: VideoGridScreen(
              key: Key(currentCategory), // Keying by currentCategory
              jsonPath: _getJsonPath(currentCategory),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab('Anime', 'anime'),
          _buildTab('Marvel', 'marvel'),
          _buildTab('Games', 'games'),
          _buildTab('Suggestions', 'suggestions'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String category) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    final isActive = currentCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentCategory = category;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(255, 44, 34, 83)
              : (isLightMode
                  ? const Color.fromARGB(255, 216, 201, 201)
                  : const Color.fromARGB(
                      255, 35, 45, 55)), // Adjust dark mode color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : (isLightMode ? Colors.black : Colors.white),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String _getJsonPath(String category) {
    switch (category) {
      case 'anime':
        return 'assets/images/video/anime_videourls.json';
      case 'marvel':
        return 'assets/images/video/marvel_videourls.json'; // Example path
      case 'games':
        return 'assets/images/video/games_videourls.json'; // Example path
      case 'suggestions':
        return 'assets/images/video/suggestions_videourls.json'; // Example path
      default:
        return 'assets/images/video/anime_videourls.json';
    }
  }
}