import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../../presentation/colors.dart';
import '../../login/login_page.dart';
import 'account.dart';

class UserProfileScreen extends StatefulWidget {
  final VoidCallback toggleTheme;


  const UserProfileScreen({Key? key, required this.toggleTheme}) : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _selectedTheme = 'Light';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> saveThemePreference(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme);
  }

  Future<void> _loadThemePreference() async {
    final appState = context.findAncestorStateOfType<MyAppState>();
    final themeMode = appState?.themeMode;
    setState(() {
      _selectedTheme = themeMode == ThemeMode.dark ? 'Dark' : 'Light';
    });
  }

  void _changeTheme(String theme) {
    final appState = context.findAncestorStateOfType<MyAppState>();
    if (theme == 'Dark') {
      appState?.themeMode = ThemeMode.dark;
    } else {
      appState?.themeMode = ThemeMode.light;
    }
    appState?.saveThemePreference(); // Сохраните тему через MyAppState
    appState?.setState(() {}); // Примените изменения
    setState(() {
      _selectedTheme = theme; // Обновите текущую тему в Dropdown
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.01; // Отступы между элементами
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.06; // Горизонтальные отступы

    // Проверяем текущую тему
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Получение текущего аутентифицированного пользователя
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userEmail = currentUser?.email ?? 'Неизвестный пользователь';

    return Scaffold(
      body: Stack(
        children: [
          // Фоновый контейнер, занимающий весь экран
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isDarkTheme ? AppColors.tealGradient : null,
              color: !isDarkTheme ? AppColors.silverColor : null,
            ),
          ),
          // Верхний контейнер
          Container(
            width: double.infinity,
            color: isDarkTheme
                ? Colors.transparent
                : AppColors.silverColor, // Светлая тема
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Иконка слева
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Действие при нажатии — возвращение назад
                        },
                        icon: const Icon(Icons.arrow_back), // Иконка "назад"
                        color: isDarkTheme ? Colors.white : Colors.black, // Цвет иконки
                      ),
                    ],
                  ),
                  // Опускаем содержимое на несколько пикселей вниз
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Закругленные углы для первой картинки
                          child: Image.asset(
                            'assets/images/IMG_4650(1).png', // Путь к первой картинке
                            width: 32, // Ширина картинки
                            height: 32, // Высота картинки
                            fit: BoxFit.cover, // Масштабируем изображение под размеры
                          ),
                        ),
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
                      // Иконка настроек с другой стороны
                      IconButton(
                        icon: Icon(Icons.settings,
                            color: isDarkTheme ? Colors.white : Colors.white),
                        iconSize: 38,
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            await Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (context) => LoginPage(
                                  toggleTheme: () {
                                    // Логика переключения темы
                                  },
                                ),
                              ),
                            );
                          } catch (e) {
                            print('Ошибка при выходе: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.19,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.82,
              decoration: BoxDecoration(
                gradient: isDarkTheme ? AppColors.darkBlueGradient : null,
                color: !isDarkTheme ? Colors.white : null,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              userEmail,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Divider(
                        color: isDarkTheme ? Colors.blue : Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Text(
                        S.of(context).accountSettings,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Редактировать профиль',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: isDarkTheme ? Colors.white : Colors.black),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (context) => const Account()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Язык приложения',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: isDarkTheme ? Colors.white : Colors.black),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Push-уведомления',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Switch(
                          value: true,
                          onChanged: (bool value) {
                            // Действие
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Тема',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedTheme,
                            icon: Icon(Icons.arrow_drop_down,
                                color: isDarkTheme ? Colors.white : Colors.black),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _changeTheme(newValue);
                              }
                            },
                            items: <String>['Light', 'Dark']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: isDarkTheme
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Divider(
                        color: isDarkTheme ? Colors.blue : Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'О нас',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: isDarkTheme ? Colors.white : Colors.black),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Политика конфиденциальности',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: isDarkTheme ? Colors.white : Colors.black),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Условия использования',
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: isDarkTheme ? Colors.white : Colors.black),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}