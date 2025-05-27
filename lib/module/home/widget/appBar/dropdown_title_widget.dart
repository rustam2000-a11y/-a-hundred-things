import 'package:flutter/material.dart';

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({super.key, required this.types});

  final List<String> types;

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: types.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  types[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
