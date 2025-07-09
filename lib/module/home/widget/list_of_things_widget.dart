import 'package:flutter/material.dart';
import 'things_card_item.dart';

class ThingsTypeListWidget extends StatefulWidget {
  const ThingsTypeListWidget({
    super.key,
    required this.things,
    required this.selectedCategoryType,
    required this.selectedItemsNotifier,
    required this.onDeleteItem,
    required this.onStateUpdate,
    this.controller,
  });

  final List<dynamic> things;
  final String? selectedCategoryType;
  final ValueNotifier<List<String>> selectedItemsNotifier;
  final void Function(String uid) onDeleteItem;
  final VoidCallback onStateUpdate;
  final ScrollController? controller;


  @override
  State<ThingsTypeListWidget> createState() => _ThingsTypeListWidgetState();
}

class _ThingsTypeListWidgetState extends State<ThingsTypeListWidget> {
  @override
  void didUpdateWidget(covariant ThingsTypeListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.things != widget.things) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ListView.builder(
        controller: widget.controller,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.things.length,
        itemBuilder: (context, index) {
          final item = widget.things[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ThingsCardWidget(
              itemId: item.id,
              title: item.title,
              description: item.description,
              type: item.type,
              imageUrl: item.imageUrl,
              selectedCategoryType: widget.selectedCategoryType,
              onStateUpdate: widget.onStateUpdate,
              quantity: item.quantity,
              onDeleteItem: () => widget.onDeleteItem(item.id),
              selectedItemsNotifier: widget.selectedItemsNotifier,
              allTypes: [],
              importance: item.importance,
              favorites: item.favorites,
            ),
          );
        },
      )

    );
  }
}

