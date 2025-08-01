import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContainerWithFilters extends StatelessWidget {

  const ContainerWithFilters({
    super.key,
    required this.onClose,
    required this.selectedType,
    required this.onTypeSelected,
    required this.selectedFilters,
  });
  final VoidCallback onClose;
  final String? selectedType;
  final void Function(String field, String value) onTypeSelected;
  final Map<String, String> selectedFilters;


  @override
  Widget build(BuildContext context) {
    final filterOptions = [
      'Sorting',
      'Tags',
      'Importance',

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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Filters'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Price from high'),
                    ],
                  ),
                ],
              ),
            ),

            if (selectedFilters.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedFilters.entries.map((entry) {
                      return InputChip(
                        backgroundColor: Colors.white,
                        label: Text(
                          entry.value,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onDeleted: () {
                          onTypeSelected(entry.key, '');
                        },
                        deleteIcon: const Icon(Icons.close, color: Colors.black),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          side: BorderSide(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
             const SizedBox(height: 18,),


            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: filterOptions.map((title) {
                    return Column(
                      children: [
                        const Divider(height: 1),
                        FilterOption(
                          title: title,
                          selectedFilters: selectedFilters,
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
    required this.selectedFilters,
    this.onTypeSelected,
  });

  final String title;
  final Map<String, String> selectedFilters;
  final void Function(String field, String value)? onTypeSelected;

  Future<List<String>> _loadValuesFromFirestore(String field) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('item')
          .where('userId', isEqualTo: user.uid)
          .get();

      final values = <String>{};

      for (var doc in snapshot.docs) {
        final data = doc.data()[field];

        if (data is List) {
          values.addAll(data.map((e) => e.toString().trim()));
        } else if (data != null &&
            data.toString().trim().isNotEmpty &&
            data is! Map) {
          values.add(data.toString().trim());
        }
      }

      return values.toList();
    } catch (e) {
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
          final isSelected = option == selectedFilters['sort'];
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
      'Tags': 'hashtags',
      'Importance': 'importance',
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
              final isSelected = value == selectedFilters[field];
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


