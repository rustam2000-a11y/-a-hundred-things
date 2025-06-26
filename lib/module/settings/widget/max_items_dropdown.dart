import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MaxItemsDropdown extends StatelessWidget {

  const MaxItemsDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    required this.isDarkTheme,
  }) : super(key: key);
  final int selectedValue;
  final ValueChanged<int> onChanged;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(2),
      ),
      child: DropdownButton<int>(
        value: selectedValue,
        dropdownColor: isDarkTheme ? Colors.black : Colors.white,
        style: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        underline: const SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        items: List.generate(
          51,
              (index) {
            final value = 100 - index;
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          },
        ),
        onChanged: (value) async {
          if (value != null) {
            onChanged(value);

            final userId = FirebaseAuth.instance.currentUser?.uid;
            if (userId != null) {
              await FirebaseFirestore.instance
                  .collection('user')
                  .doc(userId)
                  .set({'maxItems': value}, SetOptions(merge: true));
            }
          }
        },
      ),
    );
  }
}
