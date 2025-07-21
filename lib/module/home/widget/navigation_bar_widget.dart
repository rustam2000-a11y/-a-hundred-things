import 'package:flutter/material.dart';
import 'item_progress_bar_widget.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({
    Key? key,
    required this.isDarkMode,
    required this.types,
    required this.maxItems,
    required this.totalQuantity,
    this.hide = false,
  }) : super(key: key);

  final bool isDarkMode;
  final List<String> types;
  final int maxItems;
  final int totalQuantity;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    if (hide) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalQuantity / $maxItems',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ItemProgressBar(
            progress: (totalQuantity / maxItems).clamp(0.0, 1.0),
          ),
        ],
      ),
    );
  }
}
