import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:wallfusion/pages/switch_bar_pages/ai_wall.dart';
//import 'package:wallfusion/pages/switch_bar_pages/download.dart';
//import 'package:wallfusion/pages/switch_bar_pages/live_wall.dart';
import 'package:wallfusion/pages/helpandsupport.dart';
import 'package:wallfusion/pages/feeback.dart';

class HalfPageDrawer extends StatelessWidget {
  final VoidCallback onaiwallpaperView;
  final VoidCallback onlivewallpaperView;
  final VoidCallback ondownloadwallpaperView;

  const HalfPageDrawer({
    super.key,
    required this.onaiwallpaperView,
    required this.onlivewallpaperView,
    required this.ondownloadwallpaperView,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width / 2, 
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo4.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'WALLFUSION',
                      style: GoogleFonts.abel(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('AI Wallpaper'),
                onTap: onaiwallpaperView,
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Live Wallpaper'),
                onTap: onlivewallpaperView,
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Downloads'),
                onTap: ondownloadwallpaperView,
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help and Support'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child:const SizedBox(height: 600,child:  HelpSupportPage())
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () {
                  showFeedbackDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
