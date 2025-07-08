import 'package:flutter/material.dart';

class ThingImagePlaceholder extends StatelessWidget {
  const ThingImagePlaceholder({super.key, required this.screenWidth});
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.5,
      height: screenWidth * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/camera_icon.png',
          width: screenWidth * 0.18,
          height: screenWidth * 0.18,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
