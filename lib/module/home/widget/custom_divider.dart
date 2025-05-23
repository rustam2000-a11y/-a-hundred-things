import 'package:flutter/material.dart';
import '../../../presentation/colors.dart';


class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      color: isDarkTheme ? Colors.black : Colors.black,
      height: 2,
    );
  }
}
