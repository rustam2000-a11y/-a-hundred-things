import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_hundred_things/module/login/widget/login_form_widget.dart';
import '../../generated/l10n.dart';
import '../../presentation/colors.dart';
import 'widget/registration_form_widget.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.toggleTheme});

  final VoidCallback toggleTheme;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDarkTheme ? AppColors.greyBlue : null,
         color: isDarkTheme ? null : AppColors.silverColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 200),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace:  Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Две картинки вместо текста "Logo"
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Закругленные углы для первой картинки
                          child: Image.asset(
                            'assets/images/IMG_4650(1).png', // Путь к первой картинке
                            width: 32, // Ширина картинки
                            height: 31, // Высота картинки
                            fit: BoxFit.cover, // Масштабируем изображение под размеры
                          ),
                        ),
                         SizedBox(width: 4), // Отступ между картинками
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Закругленные углы для второй картинки
                          child: Image.asset(
                            'assets/images/100 Things(3).png', // Путь ко второй картинке
                            width: 106, // Ширина картинки
                            height: 20, // Высота картинки
                            fit: BoxFit.cover, // Масштабируем изображение под размеры
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      S.of(context).startNow,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      S.of(context).registerOrLoginToLearnMoreAboutOurApplication,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                )

            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDarkTheme ? AppColors.blackSand : Colors.white,
                  borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                decoration: BoxDecoration(
                  color: isDarkTheme ? null : Colors.grey[200],
                  gradient: isDarkTheme ? null : null,
                  border: Border.all(
                    color:
                        isDarkTheme ? AppColors.blueSand : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: _currentIndex == 0
                                ? AppColors.blueGradient
                                : null,
                            color: _currentIndex == 0
                                ? null
                                : isDarkTheme
                                    ? AppColors.blackSand
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: _currentIndex == 0
                                    ? Colors.white
                                    : isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: _currentIndex == 1
                                ? AppColors.blueGradient
                                : null,
                            color: _currentIndex == 1
                                ? null
                                : isDarkTheme
                                    ? AppColors.blackSand
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: _currentIndex == 1
                                    ? Colors.white
                                    : isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _currentIndex == 0
                    ? const LoginFormWidget()
                    : const RegistrationFormWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
