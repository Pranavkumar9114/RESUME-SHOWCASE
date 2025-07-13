import 'package:flutter/material.dart';

class FireBorderWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const FireBorderWidget({
    super.key,
    required this.child,
    this.borderRadius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.orange,
          width: 3,
        ),
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.orange, Colors.yellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}
