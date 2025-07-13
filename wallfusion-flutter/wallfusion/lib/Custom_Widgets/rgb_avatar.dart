import 'package:flutter/material.dart';

class RgbAvatar extends StatefulWidget {
  final double radius;
  final ImageProvider image;

  // ignore: use_super_parameters
  const RgbAvatar({Key? key, required this.radius, required this.image}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RgbAvatarState createState() => _RgbAvatarState();
}

class _RgbAvatarState extends State<RgbAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = _controller.drive(
      ColorTween(
        begin: const Color.fromARGB(0, 189, 255, 35),
        end: const Color.fromARGB(0, 69, 246, 219),
      ).chain(
        CurveTween(curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: widget.image,
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: _animation.value!,
                spreadRadius: 5,
              ),
            ],
          ),
        );
      },
    );
  }
}
