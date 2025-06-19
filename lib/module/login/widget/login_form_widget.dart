import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../generated/l10n.dart';
import '../../../presentation/colors.dart';
import '../../home/my_home_page.dart';
import '../screen/forgot_inform_screen.dart';
import '../screen/registration_screen.dart';
import 'button_basic.dart';
import 'custom_divider.dart';
import 'custom_text.dart';
import 'text_filed.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
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
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 64,
              ),
              const CustomText(text: 'LOGIN'),
              const SizedBox(
                height: 64,
              ),
              CustomText3(
                text:  S.of(context).emailAdderss,
              ),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _loginEmailController,
              ),
              const SizedBox(height: 16),
              CustomText3(
                text: S.of(context).password,
              ),
              const SizedBox(height: 5),
              CustomTextField(
                controller: _loginPasswordController,
                // ),
                isPasswordField: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.black;
                          }
                          return Colors.transparent;
                        }),
                        checkColor: Colors.white,
                      ),

                      CustomText2(
                        text: S.of(context).remember,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (context) => const ForgotInfoScreen()),
                      );
                    },
                    child: CustomText2(
                        text: S.of(context).forgotYourPassword,
                        underline: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ReusableButton(
                text: S.of(context).login,
                onPressed: () => _login(context),
              ),
              const SizedBox(height: 16),
              DividerWithText(text: S.of(context).or),
              const SizedBox(height: 30),
              CustomButtonRegist(
                text: S.of(context).continueWithGoogle,
                icon: Icons.login,
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
              ),
              const SizedBox(height: 20),
              CustomButtonRegist(
                text: S.of(context).continueWithApple,
                icon: Icons.apple,
                onPressed: () async {
                  final User? user = await signInWithApple();
                  if (!context.mounted) return;

                  if (user != null) {
                    await addUserToFirestore(user);
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => MyHomePage(toggleTheme: () {}),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).appleSignInError)),
                    );
                  }
                },
              ),

              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const CustomText2(
                  text: 'Create My Profile',
                  underline: true,
                ),
              ),
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
  if (!Platform.isIOS && !kIsWeb) {
    print('Apple Sign-In is only available on iOS or web');
    return null;
  }

  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    if (credential.givenName != null && credential.familyName != null) {
      final displayName = '${credential.givenName} ${credential.familyName}';
      await userCredential.user?.updateDisplayName(displayName);
    }

    return userCredential.user;
  } catch (e) {
    print('Apple sign-in error: $e');
    return null;
  }
}
