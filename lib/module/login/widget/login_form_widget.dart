import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one_hundred_things/module/login/widget/registration_form_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../generated/l10n.dart';
import '../../home/my_home_page.dart';
import 'button_basic.dart';
import 'forgot_widget.dart';
import 'text_filed.dart';

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
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginEmailController.text.trim(),
        password: _loginPasswordController.text.trim(),
      );

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
              const SizedBox(height: 25),
              Text(S.of(context).mail, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _loginEmailController,
                labelText: 'Email',
              ),
              const SizedBox(height: 16),
              Text(S.of(context).password,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _loginPasswordController,
                labelText: 'Password',
                isPasswordField: true,
              ),
              const SizedBox(height: 16),
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
                      Text(S.of(context).remember,
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (context) => const ForgotPassword()),
                      );
                    },
                    child: Text(
                      S.of(context).forgotYourPassword,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ReusableButton(
                text: S.of(context).login,
                onPressed: () => _login(context),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                      child: Divider(thickness: 1, color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(S.of(context).or,
                        style: const TextStyle(color: Colors.grey)),
                  ),
                  const Expanded(
                      child: Divider(thickness: 1, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  final User? user = await signInWithGoogle();
                  if (user != null) {
                    await addUserToFirestore(user);
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute<dynamic>(
                          builder: (_) => MyHomePage(toggleTheme: () {})),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ошибка входа через Google')),
                    );
                  }
                },
                icon: const Icon(Icons.login, color: Colors.red),
                label: Text(S.of(context).continueWithGoogle),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Added border radius
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    User? user = await signInWithApple();
                    if (user != null) {
                      await addUserToFirestore(user);
                      if (context.mounted) {
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (_) => MyHomePage(toggleTheme: () {}),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Ошибка входа через Apple")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ошибка: $e")),
                    );
                  }
                },
                icon: const Icon(Icons.apple, color: Colors.black),
                label: Text(S.of(context).continueWithApple),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Future<User?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      print('Google sign-in cancelled');
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
    print('Google sign-in successful: ${userCredential.user?.uid}');
    return userCredential.user;
  } catch (e) {
    print('Error signing in with Google: $e');
    return null;
  }
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