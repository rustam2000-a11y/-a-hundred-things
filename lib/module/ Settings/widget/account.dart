import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../presentation/colors.dart';
import '../../login/widget/text_filed.dart';
import 'account_text_field.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final userDoc =
      await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        nameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        passwordController.text = userData['password'] ?? '';
      }
    }
  }

  Future<void> _updateUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await FirebaseFirestore.instance.collection('user').doc(userId).update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Данные успешно обновлены')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось обновить данные')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.blackSand : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient:
                isDarkTheme ? AppColors.tealGradient : null, // Градиент
                color: !isDarkTheme ? AppColors.silverColor : null,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    bottom: -screenHeight * 0.07,
                    child: CircleAvatar(
                      radius: screenHeight * 0.08,
                      backgroundImage: AssetImage('assets/avatar.png'),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 45),
                          Expanded(
                            child: Text(
                              'Редактировать Профиль',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
            Center(
              child: Text(
                "Изменить",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Имя',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: nameController,
                    labelText: 'Введите имя',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Емеил',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Введите имеил',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Номер',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: phoneController,
                    labelText: 'Введите номер',
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Пароль',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Введите пароль',
                  ),
                  SizedBox(
                    height: screenHeight * 0.08,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _updateUserData,
                      child: Text(
                        "Обновить",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.3,
                          vertical: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: isDarkTheme
                            ? AppColors.blueGradient.colors.first // Используем первый цвет из градиента
                            : AppColors.silverColor, // Цвет для светлой темы
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
