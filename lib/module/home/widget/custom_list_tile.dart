import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.lightThemeColor,
    this.darkThemeColor,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? lightThemeColor;
  final Color? darkThemeColor;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;


    final Color backgroundColor = isDarkMode
        ? (darkThemeColor ?? Colors.black)
        : (lightThemeColor ?? Colors.white);


    final Color iconTextColor = isDarkMode ? Colors.white : const Color(0xFF757575);

    return ListTile(
      leading: Icon(
        icon,
        color: iconTextColor,
      ),
      title: Text(
        text,
        style: TextStyle(color: iconTextColor),
      ),
    );
  }
}