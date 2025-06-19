import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/di/service_locator.dart';
import 'generated/l10n.dart';
import 'module/home/my_home_page.dart';
import 'module/login/screen/login_screen.dart';
import 'presentation/them/dark_theme.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    configureDependencies();
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
      _loadThemePreference();
    }

    Future<void> toggleTheme() async {
      setState(() {
        themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      });
      await saveThemePreference();
    }

    Future<void> saveThemePreference() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', themeMode == ThemeMode.dark ? 'Dark' : 'Light');
    }

    Future<void> _loadThemePreference() async {
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
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(color:  Colors.white,),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor:  Colors.white),
          ),
        ),
        darkTheme: darkTheme,
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

    const AuthCheck({super.key, required this.toggleTheme});
    final VoidCallback toggleTheme;
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }









