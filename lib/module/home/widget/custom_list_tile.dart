import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    Key? key,
    this.icon,
    this.imagePath,
    required this.text,
    required this.onTap,
    this.lightThemeColor,
    this.darkThemeColor,
    this.textColor,
  }) : super(key: key);

  final IconData? icon;
  final String? imagePath;
  final String text;
  final VoidCallback onTap;
  final Color? lightThemeColor;
  final Color? darkThemeColor;
  final Color? textColor;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  bool isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isPressed
        ? Colors.black
        : (isDarkMode
        ? widget.darkThemeColor ?? Colors.black
        : widget.lightThemeColor ?? Colors.white);

    final effectiveTextColor =
    isPressed ? Colors.white : widget.textColor ?? Colors.black;

    Widget? leadingWidget;
    if (widget.icon != null) {
      leadingWidget = Icon(widget.icon, color: effectiveTextColor);
    } else if (widget.imagePath != null) {
      leadingWidget = Image.asset(
        widget.imagePath!,
        width: 24,
        height: 24,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(
          top: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ListTile(
          leading: leadingWidget,
          title: Text(
            widget.text,
            style: TextStyle(color: effectiveTextColor),
          ),
        ),
      ),
    );
  }
}
