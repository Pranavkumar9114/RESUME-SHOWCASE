import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<String> downloadedFiles = [];

  @override
  void initState() {
    super.initState();
    loadDownloadedFiles();
  }

  Future<void> loadDownloadedFiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? files = prefs.getStringList('downloadedFiles') ?? [];
    setState(() {
      downloadedFiles = files;
    });
  }

  Future<void> deleteDownloadedFile(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? files = prefs.getStringList('downloadedFiles') ?? [];
      files.remove(filePath);
      await prefs.setStringList('downloadedFiles', files);
      setState(() {
        downloadedFiles = files;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File deleted: ${filePath.split('/').last}')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting file: $e')),
      );
    }
  }


  void showDeleteConfirmationDialog(String filePath) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete File'),
          content: Text('Are you sure you want to delete the file "${filePath.split('/').last}" because it will also be deleted from your local download folder.',textAlign: TextAlign.justify,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteDownloadedFile(filePath);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
                title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.download,
              color: Color.fromARGB(255, 176, 18, 239),
              size: 35,
            ),
            const SizedBox(width: 45), // Adjust the spacing between icon and text as needed
            Text(
              'DOWNLOADED FILES',
              style: GoogleFonts.aleo(
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: downloadedFiles.length,
        itemBuilder: (context, index) {
          String filePath = downloadedFiles[index];
          return ListTile(
            leading: const Icon(Icons.image),
            title: Text(filePath.split('/').last),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDeleteConfirmationDialog(filePath);
              },
            ),
            onTap: () {
              _showMediaPopup(context, filePath);
            },
          );
        },
      ),
    );
  }
}

void _showMediaPopup(BuildContext context, String filePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MediaPreviewDialog(filePath: filePath);
    },
  );
}

class MediaPreviewDialog extends StatefulWidget {
  final String filePath;

  const MediaPreviewDialog({super.key, required this.filePath});

  @override
  // ignore: library_private_types_in_public_api
  _MediaPreviewDialogState createState() => _MediaPreviewDialogState();
}

class _MediaPreviewDialogState extends State<MediaPreviewDialog> {
  late VideoPlayerController _controller;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.filePath.endsWith('.mp4');
    if (_isVideo) {
      // ignore: deprecated_member_use
      _controller = VideoPlayerController.network(widget.filePath)
        ..initialize().then((_) {
          setState(() {}); // Update UI once initialization is complete
          _controller.play();
          _controller.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    if (_isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: _isVideo ? _buildVideoPreview() : _buildImagePreview(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        Expanded(
          child: PhotoView(
            imageProvider: FileImage(File(widget.filePath)),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }
Widget _buildVideoPreview() {
  if (!_controller.value.isInitialized) {
    return const SizedBox(
      height: 300,
      width: 300,
      child: Center(child: CircularProgressIndicator()),
    );
  }
  return Column(
    children: [
      Expanded(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                VideoPlayer(_controller),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  child: _controller.value.isPlaying
                      ? Container()
                      : const Icon(
                          Icons.play_arrow,
                          size: 50.0,
                          color: Colors.white,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}


}