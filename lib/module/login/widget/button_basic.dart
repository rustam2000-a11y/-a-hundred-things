import 'package:flutter/material.dart';

import '../../../presentation/colors.dart';

abstract class CustomButton {
  String get text;

  VoidCallback? get onPressed;
}

class ReusableButton extends StatelessWidget implements CustomButton {
  const ReusableButton({
    required this.text,
    this.onPressed,
    Key? key,
  }) : super(key: key);
  @override
  final String text;

  @override
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    const double buttonWidth = double.infinity;

    return Align(
      child: Container(
        width: buttonWidth,
        decoration: BoxDecoration(
          color: isDarkMode ? null : Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CustomButtonRegist extends StatelessWidget {
  const CustomButtonRegist({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.image,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 4,
    this.iconSize = 24,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final ImageProvider<Object>? image;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    Widget leading;

    if (icon != null) {
      leading = Icon(
        icon,
        color: textColor,
        size: iconSize,
      );
    } else if (image != null) {
      leading = Image(
        image: image!,
        width: iconSize,
        height: iconSize,
      );
    } else {
      leading = const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: leading,
      label: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

class CustomMainButton extends StatelessWidget {
  const CustomMainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = isEnabled ? textColor : Colors.white;
    final effectiveBackgroundColor =
        isEnabled ? backgroundColor : AppColors.grey;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const RoundedRectangleBorder(),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: effectiveTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
