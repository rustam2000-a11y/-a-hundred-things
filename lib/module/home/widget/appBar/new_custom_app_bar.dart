import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../repository/things_repository.dart';

class NewCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NewCustomAppBar({
    Key? key,
    this.showBackButton = true,
    this.showSearchIcon = true,
    this.logo,
    this.controller,
    this.focusNode,
    this.actionIcon,
    this.useTitleText = false,
    this.titleText,
    this.onLeadingOverride,
  }) : super(key: key);

  final bool showBackButton;
  final bool showSearchIcon;
  final Widget? logo;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? actionIcon;
  final bool useTitleText;
  final String? titleText;
  final VoidCallback? onLeadingOverride;

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
    if (widget.onLeadingOverride != null) {
      widget.onLeadingOverride!();
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
      backgroundColor: Colors.white,
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
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
              if (widget.useTitleText)
                Text(
                  widget.titleText ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              else
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
        if (widget.actionIcon != null)
          widget.actionIcon!
        else if (widget.showSearchIcon)
          IconButton(
            icon: ImageIcon(
              const AssetImage('assets/images/iconamoon_search.png'),
              size: 22,
              color: theme.iconTheme.color,
            ),
            onPressed: () {},
          ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1, color: Colors.black),
      ),
    );
  }
}
