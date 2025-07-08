// lib/presentation/router/auth_check.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../module/home/my_home_page.dart';
import '../../module/home/widget/splash_screen.dart';
import '../../module/login/screen/login_screen.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;

  Future<User?> _delayedAuthCheck() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _delayedAuthCheck(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SplashScreen();
        }

        final user = snapshot.data;
        if (user == null) {
          return LoginPage(toggleTheme: toggleTheme);
        } else {
          return MyHomePage(toggleTheme: toggleTheme);
        }
      },
    );
  }
}
