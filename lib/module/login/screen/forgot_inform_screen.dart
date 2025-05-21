import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../home/widget/new_custom_app_bar.dart';
import '../widget/button_basic.dart';
import '../widget/custom_text.dart';
import 'forgot_screen.dart';

class ForgotInfoScreen extends StatelessWidget {
  const ForgotInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NewCustomAppBar(
          showBackButton:false,
           showSearchIcon:false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(

          children: [
            const SizedBox(height: 50,),
            const CustomText(text:
              'REQuest received',
            ),
            const SizedBox(height: 40),
            const CustomText4(text:
              'Thanks for creating an account. We’ve sent you an email with the info nedded to confirm your account',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const CustomText4(text:
              'The email might take a couple of minutes to reach your account. Please check your junk mail to ensure you receive it.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ReusableButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (context) => const ForgotPassword(),
                  ),
                );
              },
              text: S.of(context).openEmail,
            ),

          ],
        ),
      ),
    );
  }
}