import 'package:flutter/material.dart';
import '../../../presentation/colors.dart';
import '../../home/widget/new_custom_app_bar.dart';
import '../widget/custom_text.dart';
import '../widget/login_form_widget.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.toggleTheme});

  final VoidCallback toggleTheme;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


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
        body: LoginFormWidget(),
      ),
    );
  }
}

