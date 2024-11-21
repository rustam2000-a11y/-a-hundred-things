import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_hundred_things/module/login/widget/login_form_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../main.dart';
import '../../presentation/colors.dart';
import 'widget/registration_form_widget.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  int _currentIndex = 0;



  Future<void> addUserToFirestore(User? user) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
        'email': user.email ?? 'No Email',
        'birthday': _birthdayController.text.trim(),
        'password': _passwordController.text.trim(),
        // Store password securely (for demo purposes only)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, screenHeight * 0.25),
        child: AppBar(
          backgroundColor: AppColors.silverColor,
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
          flexibleSpace: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Logo",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Начните сейчас",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  "Зарегистрируйтесь или войдите в систему, чтобы узнать больше о нашем приложении.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentIndex == 0
                            ? Colors.white
                            : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide.none,
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      child: Text("Register"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentIndex == 1
                            ? Colors.white
                            : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide.none,
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _currentIndex == 0 ? LoginFormWidget() : RegistrationFormWidget(),
        ],
      ),
    );
  }

}