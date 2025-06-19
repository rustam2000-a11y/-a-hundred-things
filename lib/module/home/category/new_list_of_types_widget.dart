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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: types.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTypeTap(types[index]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      types[index],
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
          );
        },
      ),
    );
  }
}

