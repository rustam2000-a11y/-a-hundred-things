import 'package:flutter/material.dart';

class WidgetDrawerContainer extends StatelessWidget {
  const WidgetDrawerContainer({super.key, required this.onTap, this.typ});
  final String? typ;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              typ ?? 'Categories',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

