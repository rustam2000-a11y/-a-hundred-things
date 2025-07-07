import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ThingsModel extends Equatable {
  const ThingsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.typDescription,
    required this.color,
    required this.imageUrl,
    required this.quantity,
    required this.importance,
    this.favorites = false,
    this.timestamp,
    this.userId,
  });

  factory ThingsModel.fromJson(Map<String, dynamic> json) {
    return ThingsModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      typDescription: json['typDescription'] as String? ?? '',
      color: json['color'] as String? ?? '',
      imageUrl: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      quantity: json['quantity'] as int? ?? 0,
      importance: json['importance'] as String? ?? 'Medium',
      favorites: json['favorites'] as bool? ?? false,
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : null,
      userId: json['userId'] as String?,
    );
  }

  final String id;
  final String title;
  final String description;
  final String type;
  final String typDescription;
  final String color;
  final List<String>? imageUrl;
  final int quantity;
  final String importance;
  final DateTime? timestamp;
  final bool favorites;
  final String? userId;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        typDescription,
        color,
        timestamp,
        imageUrl,
        quantity,
        importance,
      ];

  ThingsModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? typDescription,
    String? color,
    String? colorText,
    List<String>? imageUrl,
    int? quantity,
    double? price,
    String? location,
    String? importance,
    double? weight,
    bool? favorites,
    String? userId,
  }) {
    return ThingsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      typDescription: typDescription ?? this.typDescription,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      importance: importance ?? this.importance,
      favorites: favorites ?? this.favorites,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = {
      'title': title,
      'description': description,
      'type': type,
      'typDescription': typDescription,
      'color': color,
      'imageUrls': imageUrl,
      'quantity': quantity,
      'importance': importance,
      'favorites': favorites,
      'timestamp': timestamp ?? DateTime.now(),
      'userId': userId,
    };

    if (includeId && id.isNotEmpty) {
      data['id'] = id;
    }

    return data;
  }
}
