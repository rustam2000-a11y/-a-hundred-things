import 'package:flutter/material.dart';

class WidgetDrawerContainer extends StatelessWidget {
  const WidgetDrawerContainer({
    super.key,
    required this.onTap,
    this.types,
  });

  final List<String>? types;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typesText =
        (types == null || types!.isEmpty) ? 'Categories' : types!.join(', ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                typesText,
                style: const TextStyle(fontSize: 24),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
