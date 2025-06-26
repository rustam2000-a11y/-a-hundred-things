import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../things/new_things/create_new_thing_screen.dart';
import 'item_progress_bar_widget.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({
    Key? key,
    required this.isDarkMode,
    required this.types,
  }) : super(key: key);

  final bool isDarkMode;
  final List<String> types;

  Stream<int> _maxItemsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream<int>.value(100);

    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .snapshots()
        .map((doc) => (doc.data()?['maxItems'] ?? 100) as int);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _maxItemsStream(),
      builder: (context, maxItemsSnapshot) {
        final maxItems = maxItemsSnapshot.data ?? 100;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('item')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            int totalQuantity = 0;

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final docsWithTitle = snapshot.data!.docs.where((doc) {
                final title = doc['title'];
                return title != null && title.toString().trim().isNotEmpty;
              });

              totalQuantity = docsWithTitle.fold<int>(
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
                              builder: (context) => CreateNewThingScreen(
                                allTypes: types,
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add, size: 24, color: Colors.black),
                            SizedBox(width: 4),
                            Text(
                              'ADD THINGS',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$totalQuantity / $maxItems',
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
      },
    );
  }
}
