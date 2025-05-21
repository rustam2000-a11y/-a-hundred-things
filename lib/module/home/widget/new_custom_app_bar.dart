import 'package:flutter/material.dart';

class NewCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewCustomAppBar({
    Key? key,
    this.showBackButton = true,
    this.showSearchIcon = true,
  }) : super(key: key);

  final bool showBackButton;
  final bool showSearchIcon;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

      leading: showBackButton
          ? IconButton(
        icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
        onPressed: () => Navigator.of(context).pop(),
      )
          : null,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/house2.png',
              width: screenWidth * 0.09,
              height: screenWidth * 0.09,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/inscription2.png',
              width: screenWidth * 0.22,
              height: screenWidth * 0.04,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      actions: [
        if (showSearchIcon)
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () {},
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: theme.dividerColor,
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
