import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../widget/settings_list_widget.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({
    Key? key,
    required this.selectedTheme,
  }) : super(key: key);
  final String selectedTheme;

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  late String _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.selectedTheme;
  }

  Future<void> _onThemeSelected(String theme) async {
    final appState = context.findAncestorStateOfType<MyAppState>();
    if (theme == 'Dark') {
      appState?.themeMode = ThemeMode.dark;
    } else {
      appState?.themeMode = ThemeMode.light;
    }
    await appState?.saveThemePreference();
    appState?.setState(() {});
    Navigator.pop(context, theme);
  }

  Widget _buildThemeTile(String theme, bool isDark) {
    final bool selected = _currentTheme == theme;
    return Container(
      color: selected ? Colors.black : Colors.transparent,
      child: ProfileListTile(
        title: theme,
        isDarkTheme: isDark || selected,
        onTap: () => _onThemeSelected(theme),
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
          const Divider(color: Colors.black, height: 1, thickness: 1),
          SizedBox(
            height: kToolbarHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: Text(
                    'Select Theme',
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
          _buildThemeTile('Light', isDark),
          _buildThemeTile('Dark', isDark),
        ],
      ),
    );
  }
}
