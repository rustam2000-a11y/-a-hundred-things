import 'package:flutter/material.dart';

class WidgetDrawerContainer extends StatelessWidget {
  const WidgetDrawerContainer({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Closing", style: TextStyle(fontSize: 16)),
            SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
