import 'package:flutter/material.dart';
import '../../../presentation/colors.dart'; // Путь к вашему файлу с цветами

abstract class CustomButton {
  String get text;
  VoidCallback get onPressed;
}

class ReusableButton extends StatelessWidget implements CustomButton {
  @override
  final String text;

  @override
  final VoidCallback onPressed;

  const ReusableButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Использование одинаковой ширины, как у текстовых полей
    final double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: buttonWidth, // Используем фиксированную ширину
        decoration: BoxDecoration(
          gradient: isDarkMode ? AppColors.blueGradient : null, // Градиент для тёмной темы
          color: isDarkMode ? null : Colors.blueAccent, // Цвет для светлой темы
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent, // Прозрачный фон для ElevatedButton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 15), // Высота кнопки
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
