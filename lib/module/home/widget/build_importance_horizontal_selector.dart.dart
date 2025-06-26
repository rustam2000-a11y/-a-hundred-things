


import 'package:flutter/material.dart';

Widget buildImportanceHorizontalSelector({
  required String selectedValue,
  required ValueChanged<String> onChanged,
}) {
  final List<String> options = ['High', 'Medium', 'Low'];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Importance:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 12),
        ToggleButtons(
          isSelected: options.map((e) => e == selectedValue).toList(),
          onPressed: (index) {
            onChanged(options[index]);
          },
          borderRadius: BorderRadius.circular(2),
          selectedColor: Colors.white,
          color: Colors.black,
          fillColor: Colors.transparent,
          borderColor: Colors.grey.shade400,
          selectedBorderColor: Colors.black,
          constraints: const BoxConstraints(minHeight: 36),
          children: options.map((level) {
            final bool isSelected = level == selectedValue;
            return Container(
              color: isSelected ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                level,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
