import 'package:flutter/material.dart';

import '../../../model/things_model.dart';
import '../../things/new_things/create_new_thing_screen.dart';

class NewListOfTitles extends StatelessWidget {
  const NewListOfTitles({
    super.key,
    required this.things,
    required this.allTypes,
  });

  final List<ThingsModel> things;
  final List<String> allTypes;

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
        itemCount: things.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          final item = things[index];

          return InkWell(
            onTap: () {
              print('🧪 item.imageUrl: ${item.imageUrl}');
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CreateNewThingScreen(
                    allTypes: allTypes,
                    isReadOnly: true,
                    existingThing: {
                      'id': item.id,
                      'title': item.title,
                      'description': item.description,
                      'type': item.type,
                      'imageUrls': item.imageUrl ?? [],
                      'quantity': item.quantity,
                      'importance': item.importance,
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
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
