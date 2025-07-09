import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../login/widget/button_basic.dart';

class MaxItemsPickerSheet extends StatelessWidget {
  const MaxItemsPickerSheet({
    super.key,
    required this.initialValue,
    required this.onSelected,
  });

  final int initialValue;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final values = List.generate(81, (index) => 100 - index);
    int tempValue = initialValue;
    final initialIndex = values.indexOf(initialValue);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: CupertinoPicker(
          scrollController:
              FixedExtentScrollController(initialItem: initialIndex),
          itemExtent: 40,
          magnification: 1.2,
          squeeze: 1.1,
          useMagnifier: true,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (index) {
            tempValue = values[index];
          },
          selectionOverlay: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.transparent,
            ),
          ),
          children: values
              .map((value) => Center(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ))
              .toList(),
        )),
        SizedBox(
          width: 150,
          child: CustomMainButton(
            text: 'Select',
            onPressed: () async {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(userId)
                    .set({'maxItems': tempValue}, SetOptions(merge: true));
              }

              onSelected(tempValue);
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
