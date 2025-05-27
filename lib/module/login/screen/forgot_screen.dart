import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../widget/button_basic.dart';
import '../widget/custom_text.dart';
import '../widget/text_filed.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: const NewCustomAppBar(
        showBackButton: false,
        showSearchIcon: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const CustomText(
              text: 'REset password',
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomLeft,
              child: CustomText3(
                text: S.of(context).emailAdderss,
              ),
            ),
            CustomTextField(
              controller: _emailController,
              // hintText: CustomText4(text: 'Email'),
            ),
            const SizedBox(height: 24),
            ReusableButton(
              text: 'SUBMIT',
              onPressed: () async {
                final email = _emailController.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Введите ваш email')),
                  );
                  return;
                }

                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.of(context).aPasswordResetLinkHasBeenSentToYourEmail,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
