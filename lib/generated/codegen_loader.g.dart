// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en = {
    "text_added_to_firestore": "Text added to Firestore",
    "switch_language": "Switch language to Russian",
    "add_text_to_firestore": "Add text to Firestore",
    "enter_text": "Enter text",
  };

  static const Map<String, dynamic> ru = {
    "text_added_to_firestore": "Текст добавлен в Firestore",
    "switch_language": "Сменить язык на русский",
    "add_text_to_firestore": "Добавить текст в Firestore",
    "enter_text": "Введите текст",
  };

  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "ru": ru,
  };
}

