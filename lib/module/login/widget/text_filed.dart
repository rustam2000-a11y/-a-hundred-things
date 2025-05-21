import 'package:flutter/material.dart';
import '../../../presentation/colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
     this.hintText,
    this.isPasswordField = false,
    this.height,
  }) : super(key: key);

  final TextEditingController controller;
  final Widget? hintText;
  final bool isPasswordField;
  final double? height;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: widget.height ?? 60,
      child: Stack(
        children: [
          TextField(
            controller: widget.controller,
            obscureText: widget.isPasswordField && _isObscured,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.black : Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: isDarkMode
                      ? AppColors.blueGradient.colors.first
                      : Colors.black,
                ),
              ),
              suffixIcon: widget.isPasswordField
                  ? IconButton(
                icon: Icon(
                  size: 12,
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: isDarkMode
                      ? Colors.white
                      : AppColors.mutedBlueGrey,
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
          Positioned(
            left: 12,
            top: 12,
            child: IgnorePointer(
              child: Opacity(
                opacity: widget.controller.text.isEmpty ? 0.5 : 0,
                child: widget.hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
