import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/app.dart';
import '../../../generated/l10n.dart';
import '../../home/my_home_page.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../bloc/account_bloc.dart';
import '../widget/account.dart';
import '../widget/max_items_picker_sheet.dart.dart';
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
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: NewCustomAppBar(
        showSearchIcon: false,
        useTitleText: true,
        titleText: 'Settings',
        onLeadingOverride: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (_) => MyHomePage(toggleTheme: widget.toggleTheme),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: Column(
        children: [
          ProfileListTile(
            title: S.of(context).editProfile,
            showTopDivider: true,
            isDarkTheme: isDarkTheme,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) => BlocProvider(
                    create: (_) =>
                        GetIt.I<AccountBloc>()..add(LoadAccountData()),
                    child: const Account(),
                  ),
                ),
              );
            },
          ),
          ProfileListTile(
            title: S.of(context).applicationLanguage,
            isDarkTheme: isDarkTheme,
            onTap: () async {
              final newLanguage = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) => LanguageSelectionScreen(
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
            trailing: Text(
              _selectedLanguage == 'ru' ? 'Русский' : 'English',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ProfileListTile(
            title: 'Number of items',
            isDarkTheme: isDarkTheme,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                builder: (_) => MaxItemsPickerSheet(
                  initialValue: selectedValue,
                  onSelected: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              );
            },
            trailing: Text(
              selectedValue.toString(),
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ProfileListTile(
            title: S.of(context).theme,
            isDarkTheme: isDarkTheme,
            onTap: () async {
              final selectedTheme = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeSelectionScreen(
                    selectedTheme: _selectedTheme,
                  ),
                ),
              );
              if (selectedTheme != null && selectedTheme != _selectedTheme) {
                _changeTheme(selectedTheme);
              }
            },
            trailing: Text(
              _selectedTheme == 'Dark' ? 'Dark' : 'Light',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
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
            title: S.of(context).aboutUs,
            isDarkTheme: isDarkTheme,
            onTap: () {},
          ),
          ProfileListTile(
            title: S.of(context).privacyPolicy,
            isDarkTheme: isDarkTheme,
            onTap: () {},
          ),
          ProfileListTile(
            title: S.of(context).termsOfUse,
            isDarkTheme: isDarkTheme,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
