import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
//names from https://chir.ag/
class AppColors {
  const AppColors();
  static const Color whiteColor = Colors.white;
  static const Color silverColor = Color(0xFF7984FF);

  static const Color orangeSand = Color(0xFFFF7648);
    static const Color violetSand = Color(0xFF5C65CD);
  static const Color greySand = Color(0xFFA9A9A9);
  static const Color blackSand = Color(0xFF242C3B);
  static const Color blueSand = Color(0xFF3C9EEA);
  static const Color lightviolet = Color(0xFFD0D4FF);
  static const Color grey = Color(0xFF747474);
  static const Color greyNew = Color(0xFF5D5D5D);
  static const Color mutedBlueGrey = Color(0xFFACB5BB);
  static const LinearGradient whiteToBlackGradient = LinearGradient(
    colors: [
      Color(0xFF000000),Color(0xFFFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [
      Color(0xFF4DE0FE),
      Color(0xFF316AEF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkBlueGradient = LinearGradient(
    colors: [
      Color(0xFF363E51), Color(0xFF3E475C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [
      Color(0xFF242E3D),
      Color(0xFF2075A3),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient greyBlue = LinearGradient(
    colors: [
      Color(0xFF242E3D),
      Color(0xFF2C6584),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient blueDark = LinearGradient(
  colors: [

  Color(0xFF316AEF), Color(0xFF4DDFFE),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  );

  static const LinearGradient greyWhite = LinearGradient(
    colors: [

      Color(0xFFF1F1F1), Color(0xFF8B8B8B)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

