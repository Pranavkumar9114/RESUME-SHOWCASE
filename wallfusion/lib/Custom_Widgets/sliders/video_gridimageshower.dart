// ignore: unused_import
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
// ignore: unused_import
import 'package:flutter/services.dart' show rootBundle;
import 'package:wallfusion/services/sliders_url_manager/daysimageurl_video_gridimageshower.dart';

// ignore: use_key_in_widget_constructors
class VideoGridScreen extends StatefulWidget {
  final String jsonPath;

  const VideoGridScreen({super.key, required this.jsonPath});

  @override
  // ignore: library_private_types_in_public_api
  _VideoGridScreenState createState() => _VideoGridScreenState();
}

class _VideoGridScreenState extends State<VideoGridScreen> {
  List<Map<String, dynamic>> videoUrls = [];

  @override
  void initState() {
    super.initState();
    loadVideoUrls();
  }

  Future<void> loadVideoUrls() async {
    try {
      // Simulating loading daysData from JSON, replace with actual implementation
      DaysData daysData = await loadDaysData(widget.jsonPath);
      String currentDay = getCurrentDay();
      DayImageUrls? todayVideos = daysData.days.firstWhere(
        (dayImageUrls) => dayImageUrls.day == currentDay,
        orElse: () => DayImageUrls(day: '', videos: []),
      );

      if (todayVideos.videos.isNotEmpty) {
        setState(() {
          videoUrls = todayVideos.videos.map((video) {
            return {
              'url': video['url'],
              'thumbnail': video['thumbnail'],
              'type': video['type'],
            };
          }).toList();
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading video URLs: $e');
    }
  }

  Future<String> getInternalStoragePath() async {
    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    return path;
  }

  Future<Uint8List?> compressImage(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      // Compress image bytes
      List<int> compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minHeight: 200, // Adjust dimensions as needed
        minWidth: 200,
        quality: 70, // Adjust quality (0 - 100)
      );

      // Save compressed image to local storage
      await saveCompressedImage(url, compressedBytes);

      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      // ignore: avoid_print
      print('Error compressing image: $e');
      return null;
    }
  }

  Future<void> saveCompressedImage(String url, List<int> compressedImage) async {
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
      final filePath = '$internalStoragePath/files/${Uri.parse(url).pathSegments.last}';
      final file = File(filePath);

      if (await file.exists()) {
        // ignore: avoid_print
        print('Loading compressed image from: $filePath');
        return await file.readAsBytes();
      } else {
        // ignore: avoid_print
        print('Compressed image not found locally, will download and compress.');
        // If not found locally, download and compress again
        return await compressImage(url);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading compressed image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videoUrls.isEmpty
          // ignore: prefer_const_constructors
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
              ),
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showVideoDialog(context, videoUrls[index]),
                  child: FutureBuilder<Uint8List?>(
                    future: loadCompressedImage(videoUrls[index]['thumbnail']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return _buildErrorWidget(); // Display error widget
                      } else {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                videoUrls[index]['type'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 32,
      ),
    );
  }

  void _showVideoDialog(BuildContext context, Map<String, dynamic> videoInfo) {
    showDialog(
      context: context,
      builder: (context) {
        return VideoPlayerDialog(videoUrl: videoInfo['url']);
      },
    );
  }
}

class VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;

  // ignore: use_key_in_widget_constructors
  const VideoPlayerDialog({required this.videoUrl});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _downloadVideo(String url) async {
    setState(() {
      _isDownloading = true;
    });

    try {
      var response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      final downloadsDir = Directory('/storage/emulated/0/Download');

      if (!(await downloadsDir.exists())) {
        await downloadsDir.create(recursive: true);
      }

      String fileName =
          'downloaded_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      String filePath = '${downloadsDir.path}/$fileName';

      await File(filePath).writeAsBytes(bytes);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? downloadedFiles = prefs.getStringList('downloadedFiles') ?? [];
      downloadedFiles.add(filePath);
      await prefs.setStringList('downloadedFiles', downloadedFiles);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video saved to Downloads folder: $filePath')),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error downloading or saving video: $e');

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading or saving video: $e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: AspectRatio(
        aspectRatio: _controller.value.isInitialized
            ? _controller.value.aspectRatio
            : 16 / 9,
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                  _PlayPauseOverlay(controller: _controller),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
      actions: [
        TextButton(
          onPressed: _isDownloading ? null : () => _downloadVideo(widget.videoUrl),
          child: _isDownloading ? const CircularProgressIndicator() : const Text('Download'),
        ),
      ],
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: controller.value.isPlaying
                ? const SizedBox.shrink()
                : Container(
                    color: Colors.black26,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}