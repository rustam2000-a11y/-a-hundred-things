import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_hundred_things/module/login/widget/text_field_custom.dart';
import 'package:one_hundred_things/module/login/widget/text_filed.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../main.dart';
import '../../../presentation/colors.dart';
import '../../home/widget/home_widget.dart';
import 'button_basic.dart';
import 'forgot_widget.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
  TextEditingController();

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

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginEmailController.text.trim(),
        password: _loginPasswordController.text.trim(),
      );

      // Действия после успешного входа
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<dynamic>(
            builder: (_) => MyHomePage(toggleTheme: () {})),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 25),
              Text("Почта", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              CustomTextField(
                controller: _loginEmailController,
                labelText: "Email", // Замените на подходящий текст
              ),
              SizedBox(height: 16),
              Text("Пароль", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              CustomTextField(
                controller: _loginPasswordController,
                labelText: "Пароль",
                isPasswordField: true, // Включение функционала скрытия/отображения пароля
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {
                          // setState(() {
                          //   _rememberMe = value!;
                          // });
                        },
                      ),
                      Text("Запомнить", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                    child: Text(
                      "Забыл пароль?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ReusableButton(
                text: 'Войти',
                onPressed: () => _login(context),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("или", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  User? user = await signInWithGoogle();
                  if (user != null) {
                    await addUserToFirestore(user);
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (_) => MyHomePage(toggleTheme: () {})),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ошибка входа через Google")),
                    );
                  }
                },
                icon: Icon(Icons.login, color: Colors.red),
                label: Text("Продолжить с Google"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10), // Added border radius
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  User? user = await signInWithApple();
                  if (user != null) {
                    await addUserToFirestore(user);
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (_) => MyHomePage(toggleTheme: () {})),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ошибка входа через Apple")),
                    );
                  }
                },
                icon: Icon(Icons.apple, color: Colors.black),
                label: Text("Продолжить с Apple"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10), // Added border radius
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}


Future<User?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    return null;
  }
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  return userCredential.user;
}

Future<User?> signInWithApple() async {
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.email
    ],
  );
  final oauthCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    accessToken: appleCredential.authorizationCode,
  );
  final userCredential =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  return userCredential.user;
}
