import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color defaultBackground = isDarkMode
        ? (widget.darkThemeColor ?? Colors.black)
        : (widget.lightThemeColor ?? Colors.white);

    return Container(
      decoration: BoxDecoration(
        color: isPressed ? Colors.black : defaultBackground,
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
          leading: Icon(
            widget.icon,
            color: isPressed ? Colors.white : Colors.black,
          ),
          title: Text(
            widget.text,
            style: TextStyle(
              color: isPressed ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
