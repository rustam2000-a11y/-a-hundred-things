import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'generated/codegen_loader.g.dart';
import 'package:one_hundred_things/generated/locale_keys.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  await FirebaseAuth.instance.signInAnonymously();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations', // Путь к файлам перевода
      fallbackLocale: Locale('en'), // Язык по умолчанию
      assetLoader: CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Firestore Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addToFirestore() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('rill').add({
          'text': text,
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'timestamp': Timestamp.now(),
        });
        _controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.text_added_to_firestore.tr())), // Используем локализованный текст
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.add_text_to_firestore.tr())), // Используем ключ для перевода
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: LocaleKeys.enter_text.tr(), // Используем ключ для перевода
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addToFirestore,
              child: Text(LocaleKeys.add_text_to_firestore.tr()), // Используем ключ для перевода
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale('ru')); // Устанавливаем локаль на русский
              },
              child: Text(LocaleKeys.switch_language.tr()), // Используем ключ для перевода
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale('en')); // Устанавливаем локаль на английский
              },
              child: Text("Switch to English".tr()), // Используем локализованный текст
            ),
          ],
        ),
      ),
    );
  }
}
