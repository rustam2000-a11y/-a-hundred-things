import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Ширина экрана
    final screenHeight = MediaQuery.of(context).size.height; // Высота экрана
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      // Фон зависит от темы
      body: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.05, // Отступ сверху 5% от высоты экрана
          left: screenWidth * 0.05, // Отступ слева 5% от ширины экрана
          right: screenWidth * 0.05, // Отступ справа 5% от ширины экрана
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Text(
              "Забыли пароль?",
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                // Размер шрифта зависит от ширины экрана
                fontWeight: FontWeight.bold, // Толстый шрифт
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Отступ между текстом и следующим элементом
            Text(
              "Пожалуйста, введите свой адрес электронной почты для сброса пароля",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                // Размер шрифта зависит от ширины экрана
                fontWeight: FontWeight.normal, // Обычный шрифт
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Отступ перед текстфилдом
            Text("Введите почту"),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Отступ перед кнопкой
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Введите ваш email")),
                  );
                  return;
                }

                try {
                  // Отправка запроса на восстановление пароля
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Ссылка для сброса пароля отправлена на ваш email")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ошибка: $e")),
                  );
                }
              },
              child: Text("Отправить запрос"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.9, 50),
                // Кнопка займет 90% ширины экрана
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}