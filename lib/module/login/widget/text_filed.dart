import 'package:flutter/material.dart';
import '../../../presentation/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPasswordField;
  final double? height; // Высота текстового поля

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPasswordField = false, // По умолчанию это не поле для пароля
    this.height, // Высота может быть задана или null
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: widget.height, // Используем высоту, если она задана
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPasswordField && _isObscured, // Скрытие текста
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.grey[400],
          ),
          filled: true,
          fillColor: Colors.transparent, // Прозрачный фон текстового поля
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.blueGradient.colors.first // Цвет для темной темы
                  : Colors.grey[400]!, // Цвет для светлой темы
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.blueGradient.colors.first // Цвет фокуса для темной темы
                  : Colors.grey.shade600, // Цвет фокуса для светлой темы
            ),
          ),
          suffixIcon: widget.isPasswordField
              ? IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              color: isDarkMode ? Colors.white : Colors.grey[400],
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
