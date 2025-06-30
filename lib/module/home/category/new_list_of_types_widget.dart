import 'package:flutter/material.dart';

class NewListOfTypes extends StatelessWidget {
  const NewListOfTypes({
    super.key,
    required this.types,
    required this.onTypeTap,
  });

  final List<String> types;
  final void Function(String type) onTypeTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Divider(height: 1, color: Colors.black);
        }

        final type = types[index - 1];
        return Column(
          children: [
            GestureDetector(
              onTap: () => onTypeTap(type),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        type,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 12),
                        Icon(Icons.close, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.black),
          ],
        );
      },
    );
  }
}
