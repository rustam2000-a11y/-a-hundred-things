import 'package:flutter/material.dart';

import '../../login/widget/button_basic.dart';


class CustomBottomNavbar extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomBottomNavbar({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomMainButton(
              text: buttonText,
              onPressed: onPressed,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
