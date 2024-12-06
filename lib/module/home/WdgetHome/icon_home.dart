import 'package:flutter/material.dart';

import '../../../presentation/colors.dart';

class ReusableIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor; // Можно указать null, чтобы использовать тему
  final Color iconColor;
  final double screenWidth; // Ширина экрана, передается при вызове
  final double borderRadius;

  const ReusableIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.screenWidth, // Обязательный параметр для размера
    this.backgroundColor, // Опционально: позволяет использовать цвет темы
    this.iconColor = Colors.black, // Цвет иконки по умолчанию
    this.borderRadius = 8.0, // Радиус скругления по умолчанию
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Проверяем текущую тему
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: screenWidth * 0.10, // Размер зависит от ширины экрана
      height: screenWidth * 0.10,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDarkTheme
                ? AppColors.blueSand // Цвет для темной темы
                : Colors.white.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
