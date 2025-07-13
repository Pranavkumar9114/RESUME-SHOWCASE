import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallfusion/services/sliders_url_manager/daysimageurl_gridshower.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GridImageShower extends StatefulWidget {
  final String jsonPath;
  final String headerText;
  final IconData headerIcon;
  final Color iconColor;
  final double iconSize;
  final double height;

  const GridImageShower({
    super.key,
    required this.jsonPath,
    required this.headerText,
    required this.headerIcon,
    required this.iconColor,
    required this.iconSize,
    required this.height,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GridImageShowerState createState() => _GridImageShowerState();
}

class _GridImageShowerState extends State<GridImageShower> {
  List<String> imgList = [];

  @override
  void initState() {
    super.initState();
    loadImagesFromJson();
  }

  Future<void> loadImagesFromJson() async {
    try {
      DaysData daysData = await loadDaysData(widget.jsonPath);
      String currentDay = getCurrentDay();
      DayImageUrls? dayImages = daysData.days.firstWhere(
        (day) => day.day == currentDay,
        orElse: () => DayImageUrls(day: currentDay, urls: []),
      );

      setState(() {
        imgList = dayImages.urls;
      });
    } catch (e) {
      // ignore: avoid_print
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

      // ignore: avoid_print
      print('Image saved to Downloads folder: $filePath');

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to Downloads folder: $filePath')),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error downloading or saving image: $e');

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
      // ignore: avoid_print
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

      // ignore: avoid_print
      print('Compressed image saved at: $filePath');
    } catch (e) {
      // ignore: avoid_print
      print('Error saving compressed image: $e');
    }
  }

  Future<Uint8List?> loadCompressedImage(String url) async {
    try {
      String internalStoragePath = await getInternalStoragePath();
      // ignore: unnecessary_brace_in_string_interps
      final filePath = '${internalStoragePath}/files/${Uri.parse(url).pathSegments.last}';
      final file = File(filePath);

      if (await file.exists()) {
        // ignore: avoid_print
        print('Loading compressed image from: $filePath');
        return await file.readAsBytes();
      } else {
        // ignore: avoid_print
        print('Compressed image not found locally, will download and compress.');
      }
    } catch (e) {
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
          padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 8, right: 16.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              FaIcon(
                widget.headerIcon,
                size: widget.iconSize,
                color: widget.iconColor,
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                height: widget.headerText.isEmpty ? 0 : 40,
                child: Text(
                  widget.headerText,
                  style: GoogleFonts.afacad(
                    textStyle: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // ignore: sized_box_for_whitespace
        Container(
          height: widget.height,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 10,
              childAspectRatio: 9 / 16,
            ),
            itemCount: imgList.length,
            itemBuilder: (BuildContext context, int index) {
              String url = imgList[index];
              return GestureDetector(
                onTap: () => _showImagePopup(url),
                child: FutureBuilder<Uint8List?>(
                  future: loadCompressedImage(url),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return AspectRatio(
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
                      );
                    } else {
                      return FutureBuilder<Uint8List?>(
                        future: compressImage(url),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            saveCompressedImage(url, snapshot.data!);
                            return AspectRatio(
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
                            );
                          } else {
                            return const Center(child: Text('No Data'));
                          }
                        },
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
