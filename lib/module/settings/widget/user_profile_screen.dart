import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../../presentation/colors.dart';
import '../../login/screen/login_screen.dart';
import 'account.dart';


class UserProfileScreen extends StatefulWidget {

  const UserProfileScreen({Key? key, required this.toggleTheme}) : super(key: key);
  final VoidCallback toggleTheme;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _selectedTheme = 'Light';
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadLanguagePreference();
  }

  Future<void> saveThemePreference(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme);
  }

  Future<void> saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  Future<void> _loadThemePreference() async {
    final appState = context.findAncestorStateOfType<MyAppState>();
    final themeMode = appState?.themeMode;
    setState(() {
      _selectedTheme = themeMode == ThemeMode.dark ? 'Dark' : 'Light';
    });
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('languageCode') ?? 'en';
    setState(() {
      _selectedLanguage = savedLanguageCode;
    });
    await S.load(Locale(savedLanguageCode));
  }

  void _changeTheme(String theme) {
    final appState = context.findAncestorStateOfType<MyAppState>();
    if (theme == 'Dark') {
      appState?.themeMode = ThemeMode.dark;
    } else {
      appState?.themeMode = ThemeMode.light;
    }
    appState?.saveThemePreference();
    appState?.setState(() {});
    setState(() {
      _selectedTheme = theme;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    setState(() {
      _selectedLanguage = languageCode;
    });
    await saveLanguagePreference(languageCode);
    await S.load(Locale(languageCode));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.01;
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.06;

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String userEmail = currentUser?.email ?? 'Неизвестный пользователь';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isDarkTheme ? AppColors.tealGradient : null,
              color: !isDarkTheme ? AppColors.silverColor : null,
            ),
          ),
          Container(
            width: double.infinity,
            color: isDarkTheme ? Colors.transparent : AppColors.silverColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/IMG_4650(1).png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/100 Things(3).png',
                              width: 106,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                        iconSize: 38,
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<Widget>(
                              builder: (context) => LoginPage(toggleTheme: () {}),
                            ),
                                (route) => false,
                          );

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
                        S.of(context).accountSettings, // Локализованный текст
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
                          S.of(context).editProfile,
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
                          S.of(context).applicationLanguage,
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: DropdownButton<String>(
                          value: _selectedLanguage,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                          underline: const SizedBox(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _changeLanguage(newValue);
                            }
                          },
                          items: <String>['en', 'ru']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value == 'en' ? 'English' : 'Русский',
                                style: TextStyle(
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          S.of(context).pushNotifications,
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
                          S.of(context).theme,
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
                          S.of(context).aboutUs,
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
                          S.of(context).privacyPolicy,
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
                          S.of(context).termsOfUse,
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