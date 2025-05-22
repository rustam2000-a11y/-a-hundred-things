import 'package:flutter/material.dart';

import '../../../presentation/colors.dart';
import '../../home/widget/new_custom_app_bar.dart';
import '../widget/registration_form_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});


  @override
  _RegistrationScreen createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {


  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDarkTheme ? AppColors.greyBlue : null,
        color: isDarkTheme ? null : AppColors.whiteColor,
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NewCustomAppBar(
          showBackButton: false,
          showSearchIcon: false,
        ),
        body: RegistrationFormWidget(),
      ),
    );
  }
}

