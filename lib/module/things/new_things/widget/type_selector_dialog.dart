import 'package:flutter/material.dart';
import '../../../home/widget/appBar/dropdown_title_widget.dart';

class TypeSelectorDialog extends StatelessWidget {

  const TypeSelectorDialog({super.key, required this.types});
  final List<String> types;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: WidgetDrawer(
              types: types,
              onTypeSelected: (selected) {
                Navigator.of(context).pop(selected);
              },
            ),
          ),
        ),
      ),
    );
  }
}
