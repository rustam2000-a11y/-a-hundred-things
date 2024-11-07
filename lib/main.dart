import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:one_hundred_things/presentation/colors.dart';
import 'generated/codegen_loader.g.dart';
import 'package:one_hundred_things/generated/locale_keys.g.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await FirebaseAuth.instance.signInAnonymously();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; // Начальная тема - светлая

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Firestore Demo',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        primaryColor: AppColors.royalBlue, // Основной цвет для приложения
        scaffoldBackgroundColor: AppColors.royalBlue, // Задний фон для всего приложения
        appBarTheme: AppBarTheme(color: AppColors.royalBlue), // Цвет AppBar
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.dandelion), // Цвет кнопок
        ),
      ),
      darkTheme: ThemeData.dark(), // Темная тема остается стандартной
      themeMode: _themeMode,
      home: MyHomePage(toggleTheme: _toggleTheme),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MyHomePage({super.key, required this.toggleTheme});

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
          SnackBar(content: Text(LocaleKeys.text_added_to_firestore.tr())),
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
      appBar: AppBar(
        title: Text(LocaleKeys.add_text_to_firestore.tr()),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: LocaleKeys.enter_text.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addToFirestore,
              child: Text(LocaleKeys.add_text_to_firestore.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale('ru'));
              },
              child: Text(LocaleKeys.switch_language.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale('en'));
              },
              child: Text("Switch to English".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
