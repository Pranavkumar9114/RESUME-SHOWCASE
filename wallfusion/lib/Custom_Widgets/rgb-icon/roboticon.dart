import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RGBLightingIcon extends StatefulWidget {
  const RGBLightingIcon({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RGBLightingIconState createState() => _RGBLightingIconState();
}

class _RGBLightingIconState extends State<RGBLightingIcon> {
  Color _currentColor = const Color.fromARGB(255, 239, 20, 115);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startColorChange();
  }

  void _startColorChange() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      setState(() {
        _currentColor = _getNextColor(_currentColor);
      });
    });
  }

  Color _getNextColor(Color currentColor) {
    if (currentColor == const Color.fromARGB(255, 239, 20, 115)) {
      return const Color.fromARGB(255, 64, 244, 70);
    } else if (currentColor == const Color.fromARGB(255, 64, 244, 70)) {
      return const Color.fromARGB(255, 252, 25, 25);
    } else {
      return const Color.fromARGB(255, 239, 20, 115);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: FaIcon(
        FontAwesomeIcons.robot,
        key: ValueKey<Color>(_currentColor),
        color: _currentColor,
        size: 35,
      ),
    );
  }
}
