import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CounterControls extends StatelessWidget {
  const CounterControls({
    Key? key,
    required this.itemId,
    required this.itemType,
    required this.onStateUpdate,
    this.selectedCategoryType,
  }) : super(key: key);

  final String itemId;
  final String itemType;
  final VoidCallback onStateUpdate;
  final String? selectedCategoryType;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('item').doc(itemId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final quantity = data['quantity'] ?? 1;

        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () => _updateQuantity(itemId, itemType, -1, onStateUpdate, selectedCategoryType),
            ),
            Text(
              '$quantity',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _updateQuantity(itemId, itemType, 1, onStateUpdate, selectedCategoryType),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateQuantity(String itemId, String itemType, int change, VoidCallback onStateUpdate, String? selectedCategoryType) async {
    if (selectedCategoryType == null || selectedCategoryType == itemType) {
      final itemRef = FirebaseFirestore.instance.collection('item').doc(itemId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(itemRef);
        if (snapshot.exists) {
          final currentQuantity = snapshot.data()?['quantity'] ?? 1;
          final newQuantity = currentQuantity + change;
          if (newQuantity > 0) {
            transaction.update(itemRef, {'quantity': newQuantity});
          } else {
            transaction.delete(itemRef);
          }
        }
      });
      onStateUpdate();
    }
  }
}
