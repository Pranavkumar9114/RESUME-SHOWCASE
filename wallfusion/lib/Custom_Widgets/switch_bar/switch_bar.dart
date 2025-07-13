import 'package:flutter/material.dart';
import 'package:wallfusion/pages/switch_bar_pages/live_wall.dart';
import 'package:wallfusion/pages/switch_bar_pages/ai_wall.dart';
import 'package:wallfusion/pages/switch_bar_pages/download.dart';

class SwitchBar extends StatefulWidget {
  const SwitchBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SwitchBarState createState() => _SwitchBarState();
}

class _SwitchBarState extends State<SwitchBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index != 0) {
      switch (index) {
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LiveWallpaperPage()),
          ).then((value) {
            setState(() {
              _selectedIndex = 0; // Navigate back to Home sets Home icon as selected
            });
          });
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIWallpaperPage()),
          ).then((value) {
            setState(() {
              _selectedIndex = 0; // Navigate back to Home sets Home icon as selected
            });
          });
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DownloadPage()),
          ).then((value) {
            setState(() {
              _selectedIndex = 0; // Navigate back to Home sets Home icon as selected
            });
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              Icons.home,
              key: ValueKey<int>(_selectedIndex),
              color: iconColor,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.live_tv, color: iconColor),
          label: 'Live Wallpaper',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wallpaper, color: iconColor),
          label: 'AI Wallpaper',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download, color: iconColor),
          label: 'Download',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
