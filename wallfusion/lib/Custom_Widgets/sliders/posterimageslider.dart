import 'dart:async';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class posterImageSlide extends StatefulWidget {
  const posterImageSlide({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _posterImageSlideState createState() => _posterImageSlideState();
}

// ignore: camel_case_types
class _posterImageSlideState extends State<posterImageSlide> {
  List<String> localImagePaths = [
    'assets/images/poster_image1.jpg',
    'assets/images/poster_image2.jpg', // Replace with your actual local image paths
  ];
  int _currentIndex = 0;
  late Timer _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % localImagePaths.length;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Calculate width and height based on constraints
        final width = maxWidth > 400 ? 400.0 : maxWidth;
        final height = maxHeight > 200 ? 200.0 : maxHeight;

        // ignore: sized_box_for_whitespace
        return Container(
          width: width,
          height: height,
          child: localImagePaths.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
                  controller: _pageController,
                  itemCount: localImagePaths.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      localImagePaths[index],
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.error)),
                    );
                  },
                ),
        );
      },
    );
  }
}
