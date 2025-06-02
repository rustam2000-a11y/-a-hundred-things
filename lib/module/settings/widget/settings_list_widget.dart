import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.title,
    required this.isDarkTheme,
    required this.onTap,
    this.trailing,
    this.showTopDivider = false,
  });

  final String title;
  final bool isDarkTheme;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showTopDivider;

  static const Color dividerColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTopDivider)
          const Divider(
            color: dividerColor,
            height: 1,
            thickness: 1,
          ),
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          trailing: trailing ??
              Icon(
                Icons.arrow_forward_ios,
                color: isDarkTheme ? Colors.white : Colors.black,
                size: 15,
              ),
          onTap: onTap,
        ),
        const Divider(
          color: dividerColor,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
