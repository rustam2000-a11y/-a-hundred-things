import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
//names from https://chir.ag/
class AppColors {
  const AppColors();


  static const Color whiteColor = Colors.white; // HexColor('#F2EFF8');
  static const Color silverColor = Color(0xFF7984FF); // HexColor('#F2EFF8');
  static const Color royalBlue = Color(0xFF7984FF); // HexColor('#F2EFF8');
  static const Color silverSand = Color(0xFFC7C8C9); // HexColor('#F2EFF8');
  static const Color orangeSand = Color(0xFFFF7648);
    static const Color violetSand = Color(0xFF5C65CD);
  static const Color greySand = Color(0xFFA9A9A9);
  static const Color blackSand = Color(0xFF242C3B);
  static const Color blueSand = Color(0xFF3C9EEA);
  static const LinearGradient whiteToBlackGradient = LinearGradient(
    colors: [
      Color(0xFF000000),Color(0xFFFFFFFF), // Чёрный
    ],
    begin: Alignment.topLeft, // Начало градиента
    end: Alignment.bottomRight, // Конец градиента
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [
      Color(0xFF4DE0FE), // Светло-голубой
      Color(0xFF316AEF), // Тёмно-синий
    ],
    begin: Alignment.topLeft, // Начало градиента
    end: Alignment.bottomRight, // Конец градиента
  );
  static const LinearGradient darkBlueGradient = LinearGradient(
    colors: [
      Color(0xFF363E51), Color(0xFF3E475C), // Тёмно-синий оттенок 2
    ],
    begin: Alignment.topLeft, // Начало градиента
    end: Alignment.bottomRight, // Конец градиента
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [
      Color(0xFF242E3D), // Тёмный серо-синий
      Color(0xFF2075A3), // Сине-зелёный
    ],
    begin: Alignment.topLeft, // Начало градиента
    end: Alignment.bottomRight, // Конец градиента
  );
  static const LinearGradient greyBlue = LinearGradient(
    colors: [
      Color(0xFF242E3D), // Сине-зелёный
      Color(0xFF2C6584),
    ],
    begin: Alignment.topLeft, // Начало градиента
    end: Alignment.bottomRight, // Конец градиента
  );
  static const LinearGradient blueDark = LinearGradient(
  colors: [
   // Тёмный серо-синий
  Color(0xFF316AEF), Color(0xFF4DDFFE),// Сине-зелёный
  ],
  begin: Alignment.topLeft, // Начало градиента
  end: Alignment.bottomRight, // Конец градиента
  );

  static const LinearGradient greyWhite = LinearGradient(
    colors: [
      // Тёмный серо-синий
      Color(0xFFF1F1F1), Color(0xFF8B8B8B)
    ],
    begin: Alignment.topLeft, // Начало градиента
    end: Alignment.bottomRight, // Конец градиента
  );
}

