import 'package:flutter/material.dart';

abstract class CustomButton {
  String get text;
  VoidCallback get onPressed;
}

class ReusableButton extends StatelessWidget implements CustomButton {

  const ReusableButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  @override
  final String text;

  @override
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;


    const double buttonWidth = double.infinity;

    return Align(
      child: Container(
        width: buttonWidth,
        decoration: BoxDecoration(

          color: isDarkMode ? null :Colors.black ,
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
    required this.icon,
    required this.onPressed,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 4,
  });
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
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
  });

  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}



