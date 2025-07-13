import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallfusion/pages/splashscreen.dart';
import 'package:wallfusion/services/internet_check_zipoperation.dart';

class ZipExtractorPage extends StatefulWidget {
  @override
  _ZipExtractorPageState createState() => _ZipExtractorPageState();
}

class _ZipExtractorPageState extends State<ZipExtractorPage> {
  bool _extractionDone = false;
  String _statusMessage = "Initializing...";
  bool _isDisposed = false;
  double _downloadProgress = 0.0;
  int _totalBytes = 0;
  int _downloadedBytes = 0;

  @override
  void initState() {
    super.initState();
    _checkInternetAndProceed();
  }

    Future<void> _checkInternetAndProceed() async {
    try {
      if (!mounted) return;
      bool isConnected = await InternetCheckUtil.checkInternetConnection(context);
      print("Internet connection status: $isConnected");
      if (isConnected) {
        await extractZipFromFirebase();
      } else {
        print("No internet connection");

        updateStatusMessage("No internet connection. Please try again later.");
      }
    } catch (e) {

      print("Error during internet check or processing: $e");
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Extracting Resources', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold,fontStyle: FontStyle.italic))) 
      ),
      body: Center(
        child: _extractionDone
            ? const Text('Extraction Completed!',style: TextStyle(fontFamily: 'Poppins', fontSize: 18))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _downloadProgress,
                  ),
                  const SizedBox(height: 20),
                  Text(_statusMessage,style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal)),
                  if (_totalBytes > 0)
                    Text(
                      'Downloaded: ${(_downloadProgress * 100).toStringAsFixed(2)}%',
                    ),
                  if (_totalBytes > 0)
                    Text(
                      'Total: ${(_totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB, '
                      'Remaining: ${((_totalBytes - _downloadedBytes) / (1024 * 1024)).toStringAsFixed(2)} MB',
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> extractZipFromFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _extractionDone = prefs.getBool('extractionDone') ?? false;

    if (!_extractionDone) {
      updateStatusMessage("Arranging resources for an optimized experience...");

      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('compress_image.zip');
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File tempFile = File('$tempPath/compress_image.zip');

        final StreamController<int> streamController = StreamController<int>();
        final StreamSubscription<int> streamSubscription =
            streamController.stream.listen((int downloadedBytes) {
          setState(() {
            _downloadedBytes = downloadedBytes;
            _downloadProgress =
                _totalBytes > 0 ? _downloadedBytes / _totalBytes : 0.0;
          });
        });

        await ref
            .writeToFile(tempFile)
            .snapshotEvents
            .listen((TaskSnapshot snapshot) {
          setState(() {
            _totalBytes = snapshot.totalBytes;
          });
          streamController.add(snapshot.bytesTransferred);
        }).asFuture();

        await streamSubscription.cancel();
        await streamController.close();

        List<int> bytes = await tempFile.readAsBytes();

        updateStatusMessage("Extracting files...");

        Archive archive = ZipDecoder().decodeBytes(bytes);
        for (ArchiveFile file in archive) {
          String filename = '$tempPath/${file.name}';
          if (file.isFile) {
            File outputFile = File(filename);
            await outputFile.create(recursive: true);
            await outputFile.writeAsBytes(file.content);
            // ignore: avoid_print
            print('Extracted File Path: $filename');
          } else {
            Directory dir = Directory(filename);
            await dir.create(recursive: true);
            // ignore: avoid_print
            print('Extracted Directory Path: $filename');
          }
        }

        updateStatusMessage("Moving extracted files...");

        await moveContentsToDestination(tempPath);

        await prefs.setBool('extractionDone', true);

        updateStatusMessage("Cleaning up temporary files...");

        if (tempFile.existsSync()) {
          await tempFile.delete();
    
          print('Deleted zip file: $tempPath/compress_image.zip');
        }

        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
  
          print('Temporary directory deleted: $tempPath');
        }

        await deleteZipFileFromInternalStorage();

        if (!_isDisposed) {
          setState(() {
            _extractionDone = true;
          });


          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SplashScreen()));
        }
      } catch (e) {
        if (!_isDisposed) {
          setState(() {
            _statusMessage = 'Error extracting zip file: $e';
          });
        }

        print('Error extracting zip file: $e');
      }
    } else {
      if (!_isDisposed) {
        setState(() {
          _extractionDone = true;
        });
 
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      }
    }
  }

  Future<void> deleteZipFileFromInternalStorage() async {
    try {
      String internalStoragePath = await getInternalStoragePath();
      final File zipFile =
          File('$internalStoragePath/files/compress_image.zip');

      if (zipFile.existsSync()) {
        await zipFile.delete();
  
        print(
            'Deleted zip file from internal storage: $internalStoragePath/files/compress_image.zip');
      }
    } catch (e) {

      print('Error deleting zip file from internal storage: $e');
    }
  }

  void updateStatusMessage(String message) {
    if (!_isDisposed) {
      setState(() {
        _statusMessage = message;
      });
    }
  }

  Future<void> moveContentsToDestination(String sourcePath) async {
    try {
      Directory sourceDir = Directory(sourcePath);
      String internalStoragePath = await getInternalStoragePath();
      final destinationDir = Directory('$internalStoragePath/files');

      print('Destination Directory Path: ${destinationDir.path}');

      if (!destinationDir.existsSync()) {
        destinationDir.createSync(recursive: true);
      }

      List<FileSystemEntity> files = sourceDir.listSync(recursive: true);
      for (FileSystemEntity file in files) {
        if (file is File) {
          String newPath =
              '${destinationDir.path}/${file.path.split('/').last}';
          await file.copy(newPath);
     
          print('Moved File Path: $newPath');
        } else if (file is Directory) {
          String newPath =
              '${destinationDir.path}/${file.path.split('/').last}';
          Directory newDir = Directory(newPath);
          if (!newDir.existsSync()) {
            await newDir.create(recursive: true);

            print('Created Directory Path: $newPath');
          }
        }
      }
    } catch (e) {

      print('Error moving files: $e');

      throw e;
    }
  }

  Future<String> getInternalStoragePath() async {
    try {
      Directory? directory = await getExternalStorageDirectory();
      String path = directory!.path;

      print('Internal Storage Path: $path');
      return path;
    } catch (e) {
 
      print('Error getting internal storage path: $e');
 
      throw e;
    }
  }
}
