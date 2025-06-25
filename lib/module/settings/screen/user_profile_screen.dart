import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';

import '../../home/widget/appBar/new_custom_app_bar.dart';

import '../widget/account.dart';
import '../widget/settings_list_widget.dart';
import 'language_screen.dart';
import 'them_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.toggleTheme})
      : super(key: key);
  final VoidCallback toggleTheme;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _selectedTheme = 'Light';
  String _selectedLanguage = 'en';
  int selectedValue = 100;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadLanguagePreference();
    _loadMaxItemsFromFirestore();
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

  Future<void> _loadMaxItemsFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists && doc.data()?['maxItems'] != null) {
      setState(() {
        selectedValue = doc['maxItems'];
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme
        .of(context)
        .brightness == Brightness.dark;


    return Scaffold(
      appBar: const NewCustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ),
          ProfileListTile(
            title: S
                .of(context)
                .editProfile,
            showTopDivider: true,
            isDarkTheme: isDarkTheme,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) => const Account(),
                ),
              );
            },
          ),
          ProfileListTile(
            title: S
                .of(context)
                .applicationLanguage,
            isDarkTheme: isDarkTheme,
            onTap: () async {
              final newLanguage = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LanguageSelectionScreen(
                        selectedLanguage: _selectedLanguage,
                      ),
                ),
              );
              if (newLanguage != null && newLanguage != _selectedLanguage) {
                setState(() {
                  _selectedLanguage = newLanguage;
                });
              }
            },
          ),
          ProfileListTile(
            title: S
                .of(context)
                .pushNotifications,
            isDarkTheme: isDarkTheme,
            onTap: () {},
          ),
          ProfileListTile(
            title: 'Number of items',
            isDarkTheme: isDarkTheme,
            onTap: () {},
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(2),
              ),
              child: DropdownButton<int>(
                value: selectedValue,
                dropdownColor: isDarkTheme ? Colors.black : Colors.white,
                style:
                TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
                underline: const SizedBox(),
                icon: Icon(Icons.keyboard_arrow_down_outlined,
                    color: isDarkTheme ? Colors.white : Colors.black),
                items: List.generate(
                  51,
                      (index) {
                    final value = 100 - index;
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  },
                ),
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedValue = value;
                    });

                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId != null) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .set({'maxItems': value}, SetOptions(merge: true));
                    }
                  }
                },
              ),
            ),
          ),
          ProfileListTile(
            title: S
                .of(context)
                .theme,
            isDarkTheme: isDarkTheme,
            onTap: () async {
              final selectedTheme = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ThemeSelectionScreen(
                        selectedTheme: _selectedTheme,
                      ),
                ),
              );
              if (selectedTheme != null && selectedTheme != _selectedTheme) {
                _changeTheme(selectedTheme);
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'More',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ProfileListTile(
            showTopDivider: true,
            title: S
                .of(context)
                .aboutUs,
            isDarkTheme: isDarkTheme,
            onTap: () {},
          ),
          ProfileListTile(
            title: S
                .of(context)
                .privacyPolicy,
            isDarkTheme: isDarkTheme,
            onTap: () {},
          ),
          ProfileListTile(
            title: S
                .of(context)
                .termsOfUse,
            isDarkTheme: isDarkTheme,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
