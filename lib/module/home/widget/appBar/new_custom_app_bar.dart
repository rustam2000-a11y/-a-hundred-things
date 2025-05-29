import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../repository/things_repository.dart';
import '../show_search_bottom_sheet.dart';

class NewCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NewCustomAppBar({
    Key? key,
    this.showBackButton = true,
    this.showSearchIcon = true,
    this.logo,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  final bool showBackButton;
  final bool showSearchIcon;
  final Widget? logo;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<NewCustomAppBar> createState() => _NewCustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NewCustomAppBarState extends State<NewCustomAppBar> {
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateIcon);
    widget.focusNode?.addListener(_updateIcon);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateIcon);
    widget.focusNode?.removeListener(_updateIcon);
    super.dispose();
  }

  void _updateIcon() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    final hasFocus = widget.focusNode?.hasFocus ?? false;
    setState(() {
      _showClearIcon = hasText || hasFocus;
    });
  }

  void _onLeadingPressed() {
    if (_showClearIcon) {
      widget.controller?.clear();
      widget.focusNode?.unfocus();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final repository = GetIt.instance<ThingsRepositoryI>();

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: widget.showBackButton
          ? IconButton(
        icon: Icon(
          _showClearIcon ? Icons.close : Icons.arrow_back,
          color: theme.iconTheme.color,
        ),
        onPressed: _onLeadingPressed,
      )
          : null,
      centerTitle: true,
      title: widget.logo ??
          Row(
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
        if (widget.showSearchIcon)
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) =>
                      SearchPage(repository: repository),
                ),
              );
            },
          ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1, color: Colors.black),
      ),
    );
  }
}
