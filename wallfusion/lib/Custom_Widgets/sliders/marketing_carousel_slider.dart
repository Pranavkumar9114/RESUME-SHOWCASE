// ignore: unused_import
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wallfusion/services/sliders_url_manager/dayimageurl_mcarouselslider.dart';
import 'package:wallfusion/Custom_Widgets/borders/rgb_border.dart';

// ignore: camel_case_types
class M_CustomCarouselSlider extends StatefulWidget {
  const M_CustomCarouselSlider({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _M_CustomCarouselSliderState createState() => _M_CustomCarouselSliderState();
}

// ignore: camel_case_types
class _M_CustomCarouselSliderState extends State<M_CustomCarouselSlider> {
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
                      ? RGBLightBorderWidget(
                        child: Image.memory(
                          imageCache[item]!,
                          fit: BoxFit.cover,
                        ),
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
      ],
    );
  }
}
