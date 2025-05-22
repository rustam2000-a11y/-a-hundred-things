import 'package:flutter/material.dart';

import '../colors.dart';


final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.blackSand,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
    iconTheme: IconThemeData(color: AppColors.orangeSand),
    titleTextStyle: TextStyle(color: AppColors.orangeSand, fontSize: 20),
  ),
  iconTheme: const IconThemeData(color: AppColors.orangeSand),
);
