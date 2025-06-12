import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  const ItemImage({
    Key? key,
    required this.imageUrl,
    required this.itemId,
    required this.isSelected,
  }) : super(key: key);

  final List <String>? imageUrl;
  final String itemId;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('item').doc(itemId).snapshots(),
          builder: (context, snapshot) {
            String? firstImageUrl;

            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null && data['imageUrls'] is List<dynamic>) {
                final imageUrls = data['imageUrls'] as List<dynamic>;
                if (imageUrls.isNotEmpty) {
                  firstImageUrl = imageUrls.first as String?;
                }
              }
            }

            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: firstImageUrl == null ? Colors.grey[300] : null,
                image: firstImageUrl != null
                    ? DecorationImage(
                  image: NetworkImage(firstImageUrl),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: firstImageUrl == null
                  ? Center(
                child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
              )
                  : null,
            );
          },
        ),
        if (isSelected)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
}
