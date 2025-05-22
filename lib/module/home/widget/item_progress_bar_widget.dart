
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../presentation/colors.dart';


class ItemProgressBar extends StatelessWidget {
  const ItemProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

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

        final progress = (totalQuantity / 100).clamp(0.0, 1.0);
        final progressWidth = MediaQuery.of(context).size.width * 0.85;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkTheme ? AppColors.blueSand : Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              left: progress * progressWidth - 3,
              top: -6,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkTheme ? AppColors.blueSand : AppColors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),


                  ),
                  Container(
                    width: 24,
                    height: 23,
                    decoration: BoxDecoration(
                      color: isDarkTheme ? AppColors.blueSand : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
