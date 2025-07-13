// ignore_for_file: avoid_print

// ignore: unused_import
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallfusion/services/sliders_url_manager/dayimageurl_t_phoneimageslider.dart';

class PhoneCustomCarouselSlider extends StatefulWidget {
  const PhoneCustomCarouselSlider({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneCustomCarouselSliderState createState() =>
      _PhoneCustomCarouselSliderState();
}

class _PhoneCustomCarouselSliderState extends State<PhoneCustomCarouselSlider> {
  List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    loadImagesFromJson();
  }

  Future<void> loadImagesFromJson() async {
    try {
      DaysData daysData = await loadDaysData();
      String currentDay = getCurrentDay();
      DayImageUrls? dayImages = daysData.days.firstWhere(
        (day) => day.day == currentDay,
        orElse: () => DayImageUrls(day: currentDay, urls: []),
      );

      setState(() {
        imgList = dayImages.urls;
      });
    } catch (e) {
      print('Error loading images from JSON: $e');
    }
  }

  Future<String> getInternalStoragePath() async {
    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    return path;
  }

  Future<void> downloadAndSaveImage(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      final downloadsDir = Directory('/storage/emulated/0/Download');

      if (!(await downloadsDir.exists())) {
        await downloadsDir.create(recursive: true);
      }

      String fileName =
          'downloaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String filePath = '${downloadsDir.path}/$fileName';

      await File(filePath).writeAsBytes(bytes);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? downloadedFiles =
          prefs.getStringList('downloadedFiles') ?? [];
      downloadedFiles.add(filePath);
      await prefs.setStringList('downloadedFiles', downloadedFiles);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to Downloads folder: $filePath')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading or saving image: $e')),
      );
    }
  }

  Future<Uint8List?> compressImage(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      List<int> compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minHeight: 480,
        minWidth: 640,
        quality: 80,
      );

      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  Future<void> saveCompressedImage(String url, Uint8List compressedImage) async {
    try {
      String internalStoragePath = await getInternalStoragePath();
      final directory = Directory('$internalStoragePath/files');
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/${Uri.parse(url).pathSegments.last}';
      final file = File(filePath);
      await file.writeAsBytes(compressedImage);

      print('Compressed image saved at: $filePath');
    } catch (e) {
      print('Error saving compressed image: $e');
    }
  }

  Future<Uint8List?> loadCompressedImage(String url) async {
    try {
      String internalStoragePath = await getInternalStoragePath();
      final filePath =
          // ignore: unnecessary_brace_in_string_interps
          '${internalStoragePath}/files/${Uri.parse(url).pathSegments.last}';
      final file = File(filePath);

      if (await file.exists()) {
        print('Loading compressed image from: $filePath');
        return await file.readAsBytes();
      } else {
        print('Compressed image not found locally, will download and compress.');
        Uint8List? compressedImage = await compressImage(url);
        if (compressedImage != null) {
          await saveCompressedImage(url, compressedImage);
          return compressedImage;
        }
      }
    } catch (e) {
      // ignore: duplicate_ignore
      // ignore: avoid_print
      print('Error loading compressed image: $e');
    }
    return null;
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
            height: 400,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PhotoView(
                    imageProvider: NetworkImage(url),
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
                      minimumSize: const Size(double.infinity, 50),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 8, right: 16.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: FaIcon(FontAwesomeIcons.tree),
              ),
              const SizedBox(width: 8.0),
              Text(
                'Trendings',
                style: GoogleFonts.afacad(
                  textStyle: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // ignore: sized_box_for_whitespace
        Container(
          height: MediaQuery.of(context).size.width * (9 / 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: imgList.map((url) {
                return FutureBuilder<Uint8List?>(
                  future: loadCompressedImage(url),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: MediaQuery.of(context).size.width * (9 / 16),
                        height: MediaQuery.of(context).size.width * (9 / 16),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return Container(
                        width: MediaQuery.of(context).size.width * (9 / 16),
                        height: MediaQuery.of(context).size.width * (9 / 16),
                        alignment: Alignment.center,
                        child: const Icon(Icons.error),
                      );
                    }
                    return GestureDetector(
                      onTap: () => _showImagePopup(url),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
