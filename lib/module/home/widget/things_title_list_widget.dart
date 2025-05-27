import 'package:flutter/material.dart';

class NewListOfTitles extends StatelessWidget {
  const NewListOfTitles({
    super.key,
    required this.title,
  });

  final List<String> title;

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
        itemCount: title.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title[index],
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
          );
        },
      ),
    );
  }
}
