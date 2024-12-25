import 'dart:math';

import 'package:flutter/material.dart';


// ignore: avoid_classes_with_only_static_members
class PresentationUtils{

  static Color? getColorFromHex(String? hexColor) {
    if (hexColor == null || !hexColor.startsWith('#')) return null;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
    } catch (e) {
      return null;
    }
  }

  static String getRandomColor() {
    final random = Random();
    return '#${random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }
}