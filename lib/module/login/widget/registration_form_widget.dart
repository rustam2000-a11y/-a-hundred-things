import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../main.dart';

class RegistrationFormWidget extends StatefulWidget {
  const RegistrationFormWidget({super.key});

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

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
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Text("Почта",
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
            ),
            TextField(
             // controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text("Пароль",
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
            ),
            TextField(
              //controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Пароль",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text("Дата рождения",
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
            ),
            TextField(
             // controller: _birthdayController,
              decoration: InputDecoration(
                labelText: "Дата рождения",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  await addUserToFirestore(userCredential.user);
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (_) =>
                            MyHomePage(toggleTheme: (){})),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: Text("Register"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
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
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                User? user = await signInWithGoogle();
                if (user != null) {
                  await addUserToFirestore(user);
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (_) =>
                            MyHomePage(toggleTheme:(){})),
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
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () async {
                User? user = await signInWithApple();
                if (user != null) {
                  await addUserToFirestore(user);
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (_) =>
                            MyHomePage(toggleTheme: (){})),
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
          ],
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
  final GoogleSignInAuthentication googleAuth =
  await googleUser.authentication;
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
