import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../widget/settings_list_widget.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key, required this.selectedLanguage});
  final String selectedLanguage;

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.selectedLanguage;
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);

    setState(() {
      _currentLanguage = languageCode;
    });

    await S.load(Locale(languageCode));
    final appState = context.findAncestorStateOfType<MyAppState>();
    appState?.setState(() {});

    Navigator.pop(context, languageCode);
  }

  Widget _buildLanguageTile(String code, String label, bool isDarkTheme) {
    final bool selected = _currentLanguage == code;
    return Container(
      color: selected ? Colors.black : Colors.transparent,
      child: ProfileListTile(
        title: label,

        isDarkTheme: isDarkTheme || selected,
        onTap: () => _changeLanguage(code),

        trailing: const SizedBox(),
        showTopDivider: true,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const NewCustomAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: isDark ? Colors.white : Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: Text(
                    S.of(context).applicationLanguage,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),


          _buildLanguageTile('en', 'English', isDark),
          _buildLanguageTile('ru', 'Русский', isDark),
        ],
      ),
    );
  }
}
