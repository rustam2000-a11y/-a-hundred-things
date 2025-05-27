import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../login/widget/custom_text.dart';
import 'item_progress_bar_widget.dart';
import 'show_add_item_bottom_sheet.dart';


class NavigationBarWidget extends StatelessWidget {

  const NavigationBarWidget({Key? key, required this.isDarkMode}) : super(key: key);
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('item')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        int totalQuantity = 0;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          totalQuantity = snapshot.data!.docs.fold<int>(
            0,
                (accumulator, doc) {
              final quantity = doc['quantity'] as int? ?? 1;
              return accumulator + quantity;
            },
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => AddItemPage(type: 'ExampleType'),
                        ),
                      );


                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 24, color: Colors.black),
                        SizedBox(width: 4),
                        CustomText5(
                          text: 'ADD THINGS',
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),


                  Text(
                    '$totalQuantity / 100',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const ItemProgressBar(),
            ],
          ),

        );
      },
    );
  }
}


