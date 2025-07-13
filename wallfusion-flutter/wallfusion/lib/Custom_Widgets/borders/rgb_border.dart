import 'package:flutter/material.dart';

class RGBLightBorderWidget extends StatefulWidget {
  final Widget child;
  final double borderRadius;

  const RGBLightBorderWidget({
    super.key,
    required this.child,
    this.borderRadius = 18.0,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RGBLightBorderWidgetState createState() => _RGBLightBorderWidgetState();
}

class _RGBLightBorderWidgetState extends State<RGBLightBorderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: const Color.fromARGB(255, 255, 242, 0),
          end: const Color.fromARGB(255, 0, 246, 254),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: const Color.fromARGB(255, 0, 246, 254),
          end: const Color.fromARGB(255, 1, 254, 149),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: const Color.fromARGB(255, 1, 254, 149),
          end: const Color.fromARGB(255, 174, 255, 0),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: const Color.fromARGB(255, 234, 255, 3),
          end: const Color.fromARGB(255, 255, 153, 0),
        ),
        weight: 1,
      ),
    ]).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _colorAnimation.value ?? const Color.fromARGB(255, 255, 179, 0),
          width: 4,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: widget.child,
      ),
    );
  }
}
