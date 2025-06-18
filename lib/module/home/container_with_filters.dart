import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContainerWithFilters extends StatelessWidget {

  const ContainerWithFilters({
    super.key,
    required this.onClose,
    required this.selectedType,
    required this.onTypeSelected,
  });
  final VoidCallback onClose;
  final String? selectedType;
  final void Function(String field, String value) onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final filterOptions = [
      'Sorting',
      'Tags',
      'Price',
      'Importance',
      'Weight',
      'Color',
      'Location',
    ];

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: 0,
      top: 0,
      bottom: 0,
      width: 350,
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: const Text('Filters'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: filterOptions.map((title) {
                    return Column(
                      children: [
                        const Divider(height: 1),
                        FilterOption(
                          title: title,
                          selectedType: selectedType,
                          onTypeSelected: onTypeSelected,
                        ),
                        const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  const FilterOption({
    super.key,
    required this.title,
    this.selectedType,
    this.onTypeSelected,
  });

  final String title;
  final String? selectedType;
  final void Function(String field, String value)? onTypeSelected;

  Future<List<String>> _loadValuesFromFirestore(String field) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('item')
          .where('userId', isEqualTo: user.uid)
          .get();

      final values = snapshot.docs
          .map((doc) => doc.data()[field])
          .where((value) =>
      value != null &&
          value.toString().trim().isNotEmpty &&
          value is! List &&
          value is! Map)
          .map((value) => value.toString().trim())
          .toSet()
          .toList();

      return values;
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (title == 'Sorting') {
      final sortingOptions = [
        'PRICE from High to Low',
        'PRICE from Low to High',
        'Date of creation',
        'WEIGHT from Large to Small',
        'WEIGHT from Small to Large',
      ];

      return ExpansionTile(
        title: Text(title),
        children: sortingOptions.map((option) {
          final isSelected = option == selectedType;
          return ListTile(
            title: Center(
              child: Text(
                option,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            onTap: () {
              onTypeSelected?.call('sort', option);
            },
          );
        }).toList(),
      );
    }

    const firestoreFields = {
      'Tags': 'type',
      'Price': 'price',
      'Importance': 'importance',
      'Weight': 'weight',
      'Location': 'location',
      'Color': 'colorText',
    };

    if (firestoreFields.containsKey(title)) {
      final field = firestoreFields[title]!;

      return FutureBuilder<List<String>>(
        future: _loadValuesFromFirestore(field),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ExpansionTile(
              title: Text(title),
              children: const [ListTile(title: Text('Loading...'))],
            );
          }

          if (snapshot.hasError) {
            return ExpansionTile(
              title: Text(title),
              children: [
                ListTile(title: Text('Error: ${snapshot.error}')),
              ],
            );
          }

          final values = snapshot.data ?? [];

          return ExpansionTile(
            title: Text(title),
            children: values.isEmpty
                ? [const ListTile(title: Text('No data found'))]
                : values.map((value) {
              final isSelected = value == selectedType;
              return ListTile(
                title: Text(
                  value,
                  style: TextStyle(
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  onTypeSelected?.call(field, value);
                },
              );
            }).toList(),
          );
        },
      );
    }


    return ExpansionTile(
      title: Text(title),
      children: const [
        ListTile(title: Text('Option 1')),
        ListTile(title: Text('Option 2')),
      ],
    );
  }
}

