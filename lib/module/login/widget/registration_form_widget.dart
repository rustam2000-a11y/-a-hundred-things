import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../generated/l10n.dart';
import '../../home/my_home_page.dart';
import '../../home/widget/custom_divider.dart';
import 'button_basic.dart';
import 'custom_divider.dart';
import 'custom_text.dart';
import 'text_filed.dart';

class RegistrationFormWidget extends StatefulWidget {
  const RegistrationFormWidget({super.key});

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 64,),
              const CustomText(text: 'Create a profile'),
              const SizedBox(height: 40,),
               Align(
                alignment: Alignment.bottomLeft,
                child: CustomText3(text:S.of(context).emailAdderss,
                    ),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextField(
                controller: _emailController,
                hintText: CustomText4(text: 'Email'),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomText3(text: S.of(context).password),
              ),
              const SizedBox(height: 4),
              CustomTextField(
                controller: _passwordController,
                // hintText: CustomText4(text: 'Password'),
                isPasswordField: true,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomText3(text: S.of(context).dateOfBirth),
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextField(
                controller: _birthdayController,
                // hintText: const CustomText4(text: 'Date of birth'),
              ),
              const SizedBox(height: 18),
              ReusableButton(
                text: S.of(context).next,
                onPressed: () async {
                  try {
                    final UserCredential userCredential = await FirebaseAuth
                        .instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                    await addUserToFirestore(userCredential.user);
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
                },
              ),
              const SizedBox(height: 16),
              DividerWithText(text: S.of(context).or),
              const SizedBox(height: 16),
              CustomButtonRegist(
                text: S.of(context).continueWithGoogle,
                icon: Icons.login,
                onPressed: () async {
                  final User? user = await signInWithGoogle();
                  if (user != null) {
                    await addUserToFirestore(user);

                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (_) => MyHomePage(toggleTheme: () {})),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google login error')),
                    );
                  }
                },

              ),
               const SizedBox(height: 15),
              CustomButtonRegist(
                text: S.of(context).continueWithApple,
                icon: Icons.apple,
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
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      print('Google sign-in cancelled');
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      print('Google Sign-In token is null');
      return null;
    }

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
