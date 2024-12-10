  import 'dart:async';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_localization/flutter_localization.dart';
  import 'package:one_hundred_things/presentation/colors.dart';
  import 'generated/l10n.dart';
  import 'module/home/widget/home_widget.dart';
  import 'module/login/login_page.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:image_picker/image_picker.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await loadTypeColorsFromFirestore(); // Загружаем цвета типов
    runApp(
      const MyApp(),
    );
  }

  class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    MyAppState createState() => MyAppState();
  }

  class MyAppState extends State<MyApp> {
    ThemeMode themeMode = ThemeMode.light;
    final FlutterLocalization localization = FlutterLocalization.instance;

    @override
    void initState() {
      super.initState();
      _loadThemePreference(); // Загрузка сохраненной темы при запуске
    }

    Future<void> toggleTheme() async {
      setState(() {
        themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      });
      await saveThemePreference(); // Сохранение текущей темы
    }

    Future<void> saveThemePreference() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', themeMode == ThemeMode.dark ? 'Dark' : 'Light');
    }

    Future<void> _loadThemePreference() async {

      runApp(MyApp());
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('themeMode') ?? 'Light';
      setState(() {
        themeMode = savedTheme == 'Dark' ? ThemeMode.dark : ThemeMode.light;
      });
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Firestore Demo',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
          primaryColor: AppColors.silverColor,
          scaffoldBackgroundColor: AppColors.silverColor,
          appBarTheme: const AppBarTheme(color: AppColors.royalBlue),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style:
            ElevatedButton.styleFrom(backgroundColor: AppColors.silverColor),
          ),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        locale: const Locale('en'),
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: const [
          S.delegate,
        ],
        home: AuthCheck(toggleTheme: toggleTheme),
      );
    }
  }

  class AuthCheck extends StatelessWidget {
    final VoidCallback toggleTheme;

    const AuthCheck({super.key, required this.toggleTheme});
    @override
    Widget build(BuildContext context) {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return LoginPage(toggleTheme: toggleTheme);
            } else {
              return MyHomePage(toggleTheme: toggleTheme);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }









