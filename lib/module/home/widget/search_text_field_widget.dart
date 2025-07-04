import 'package:flutter/material.dart';

class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isDarkMode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'WHAT ARE YOU LOOKING FOR?',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: hasText ? Colors.black : Colors.grey,
            ),
            onPressed: hasText ? controller.clear : null,
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
