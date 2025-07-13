// ignore: unused_import
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallfusion/services/sliders_url_manager/dayimageurl_carouselslider.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomCarouselSliderState createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> imgList = [];
  Map<String, Uint8List?> imageCache = {};

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

      for (String url in imgList) {
        if (!imageCache.containsKey(url)) {
          final imageData = await loadImage(url);
          if (imageData == null) {
            final downloadedData = await downloadImage(url);
            if (downloadedData != null) {
              await saveImage(url, downloadedData);
              imageCache[url] = downloadedData;
            }
          } else {
            imageCache[url] = imageData;
          }
        }
      }
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

  Future<void> saveImage(String url, Uint8List imageData) async {
    try {
      String internalStoragePath = await getInternalStoragePath();
      final directory = Directory('$internalStoragePath/files');
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/${Uri.parse(url).pathSegments.last}';
      final file = File(filePath);

      // Check if the file already exists
      if (await file.exists()) {
        // ignore: avoid_print
        print('Image already exists locally: $filePath');
        return; // Exit early if the file already exists
      }

      // Write the file asynchronously
      await file.writeAsBytes(imageData);

      // ignore: avoid_print
      print('Image saved at: $filePath');
    } catch (e) {
      // ignore: avoid_print
      print('Error saving image: $e');
    }
  }

  Future<Uint8List?> loadImage(String url) async {
    try {
      String internalStoragePath = await getInternalStoragePath();
      final filePath =
          '$internalStoragePath/files/${Uri.parse(url).pathSegments.last}';
      final file = File(filePath);

      if (await file.exists()) {
        // ignore: avoid_print
        print('Loading image from: $filePath');
        return await file.readAsBytes();
      } else {
        // ignore: avoid_print
        print('Image not found locally, will download.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading image: $e');
    }
    return null;
  }

  Future<Uint8List?> downloadImage(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error downloading image: $e');
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
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: CarouselSlider(
            items: imgList.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  final imageWidget = imageCache[item] != null
                      ? Image.memory(
                          imageCache[item]!,
                          fit: BoxFit.cover,
                        )
                      : FutureBuilder<Uint8List?>(
                          future: downloadImage(item),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            } else {
                              imageCache[item] = snapshot.data!;
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        );

                  return GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY((imgList.indexOf(item) - _current) * 0.1),
                        alignment: FractionalOffset.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18.0),
                          child: imageWidget,
                        ),
                      ),
                    ),
                    onTap: () => _showImagePopup(item),
                  );
                },
              );
            }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _current == entry.key ? Colors.blueAccent : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
