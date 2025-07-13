// ignore: unused_import
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'package:cached_network_image/cached_network_image.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes, unused_import
import 'package:flutter/services.dart' as rootBundle;
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallfusion/services/sliders_url_manager/daysimageurl_singleimageslider.dart';

class SingleImageSlide extends StatefulWidget {
  final String jsonPath;

  const SingleImageSlide({super.key, required this.jsonPath});

  @override
  // ignore: library_private_types_in_public_api
  _SingleImageSlideState createState() => _SingleImageSlideState();
}

class _SingleImageSlideState extends State<SingleImageSlide> {
  String url = '';

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    try {
      DaysData daysData = await loadDaysData(widget.jsonPath);
      String currentDay = getCurrentDay();
      DayImageUrls? todayImages = daysData.days.firstWhere(
        (dayImageUrls) => dayImageUrls.day == currentDay,
        orElse: () => DayImageUrls(day: '', urls: []),
      );

      if (todayImages.urls.isNotEmpty) {
        setState(() {
          url = todayImages.urls[0];
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading image URL: $e');
    }
  }

  Future<void> downloadAndSaveImage(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      // Get the Downloads directory
      final downloadsDir = Directory('/storage/emulated/0/Download');

      // Ensure the Downloads directory exists
      if (!(await downloadsDir.exists())) {
        await downloadsDir.create(recursive: true);
      }

      // Specify a file path with a unique name
      String fileName =
          'downloaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String filePath = '${downloadsDir.path}/$fileName';

      // Write the file
      await File(filePath).writeAsBytes(bytes);

      // Save file path to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? downloadedFiles =
          prefs.getStringList('downloadedFiles') ?? [];
      downloadedFiles.add(filePath);
      await prefs.setStringList('downloadedFiles', downloadedFiles);

      // Debug print
      // ignore: avoid_print
      print('Image saved to Downloads folder: $filePath');

      // Show snackbar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to Downloads folder: $filePath')),
      );
    } catch (e) {
      // Debug print
      // ignore: avoid_print
      print('Error downloading or saving image: $e');

      // Show snackbar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading or saving image: $e')),
      );
    }
  }

  void _showImagePopup(String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 400, // Set a fixed height for the popup
            width: 300, // Set a fixed width for the popup
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PhotoView(
                    imageProvider: CachedNetworkImageProvider(url),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      downloadAndSaveImage(url);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download Image'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                          double.infinity, 50), // Make the button full width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Calculate width and height based on constraints
        final width = maxWidth > 400 ? 400.0 : maxWidth;
        final height = maxHeight > 400 ? 400.0 : maxHeight;

        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0), // Add padding here
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0), // Add curved border
            // ignore: sized_box_for_whitespace
            child: Container(
              width: width,
              height: height,
              child: url.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () => _showImagePopup(url),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: url,
                            width: width -32, // Subtract padding to adjust image width
                            height: height,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                          const Positioned(
                              right: 8.0,
                              bottom: 8.0,
                              child: Icon(Icons.download, size: 30.0))
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
