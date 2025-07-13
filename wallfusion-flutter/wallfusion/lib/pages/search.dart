import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ImageModel> images = [];
  List<ImageModel> filteredImages = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadImages();
    searchController.addListener(() {
      filterImages();
    });
  }

  Future<void> loadImages() async {
    // List of JSON files to load
    final List<String> jsonFiles = [
      'assets/images/days_data_carouselslider.json',
      'assets/images/days_data_t_phoneimageslider.json',
      'assets/images/days_data_p_phoneimageslider.json',
      'assets/images/grid/days_data_anime_gridimageshower.json',
      'assets/images/grid/days_data_marvel_gridimageshower.json',
      'assets/images/grid/days_data_aiwall_gridimageshower.json',
      'assets/images/grid/days_data_dc_gridimageshower.json',
      'assets/images/singleimageslider/slide1.json',
      'assets/images/singleimageslider/slide2.json',
      'assets/images/singleimageslider/slide3.json',
      'assets/images/singleimageslider/slide4.json',
      'assets/images/singleimageslider/slide5.json',
      'assets/images/singleimageslider/slide6.json',
      'assets/images/singleimageslider/slide7.json',
      'assets/images/singleimageslider/slide8.json',
      'assets/images/singleimageslider/slide9.json',
      'assets/images/singleimageslider/slide10.json',
    ];

    List<ImageModel> loadedImages = [];

    for (String filePath in jsonFiles) {
      final String response = await rootBundle.loadString(filePath);
      final Map<String, dynamic> data = json.decode(response);

      for (var day in data['days']) {
        for (var url in day['urls']) {
          loadedImages.add(ImageModel(url: url));
        }
      }
    }

    setState(() {
      images = loadedImages;
      filteredImages = []; // Initially show no images until user searches
    });
  }

  void filterImages() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredImages = [];
      } else {
        filteredImages = images.where((image) {
          return image.url.toLowerCase().contains(query);
        }).toList();
      }
    });
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

    Future<String> getInternalStoragePath() async {
    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    return path;
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



  Future<File?> loadCompressedImage(String url) async {
    try {
      String internalStoragePath = await getInternalStoragePath();
      // ignore: unnecessary_brace_in_string_interps
      final filePath =
          // ignore: unnecessary_brace_in_string_interps
          '${internalStoragePath}/files/${Uri.parse(url).pathSegments.last}';
      final file = File(filePath);

      if (await file.exists()) {
        // ignore: avoid_print
        print('Loading compressed image from: $filePath');
        return file;
      } else {
        // ignore: avoid_print
        print('Compressed image not found locally, will download and compress.');
        Uint8List? compressedImage = await compressImage(url);
        if (compressedImage != null) {
          await saveCompressedImage(url, compressedImage);
          return File(filePath);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading compressed image: $e');
    }
    return null;
  }

  void _showImagePopup(String url) {
    searchFocusNode.unfocus();
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

    Widget _buildGridTile(ImageModel image) {
    return FutureBuilder<File?>(
      future: loadCompressedImage(image.url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final file = snapshot.data!;
            return GestureDetector(
              onTap: () {
                _showImagePopup(image.url);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.file(file, fit: BoxFit.cover),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                _showImagePopup(image.url);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: image.url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = searchController.text.isNotEmpty;
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 70),
            const FaIcon(
              FontAwesomeIcons.searchengin,
              color: Color.fromARGB(255, 111, 27, 255),
              size: 25,
            ),
            const SizedBox(width: 5),
            Text(
              'SEARCH',
              style: GoogleFonts.anaheim(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 30),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 2, 2, 2)
                        : Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color.fromARGB(255, 252, 250, 250)
                          : Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search..',
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey
                            : Colors.white54,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey
                            : Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 255, 251, 251),
                        ),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                 if (!isSearching)
                  Text(
                    textAlign: TextAlign.justify,
                    'Note: The search will only filter images containing the specified text like (Anime,Marvel,DC,Ai).',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white54,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          // Only show GridView if there are filtered images
          if (filteredImages.isNotEmpty)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: filteredImages.length,
                itemBuilder: (context, index) {
                  return _buildGridTile(filteredImages[index]);
                },
              ),
            ),
          // Show message if no images are found
          if (filteredImages.isEmpty && searchController.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No images found.'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class ImageModel {
  final String url;

  ImageModel({required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(url: json['url']);
  }
}
