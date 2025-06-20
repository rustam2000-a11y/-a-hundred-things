import 'package:equatable/equatable.dart';

class ThingsModel extends Equatable {
  const ThingsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.typDescription,
    required this.color,
    required this.colorText,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.location,
    required this.importance,
    required this.weight,
    this.favorites = false,
  });

  factory ThingsModel.fromJson(Map<String, dynamic> json) {
    return ThingsModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      typDescription: json['typDescription'] as String? ?? '',
      color: json['color'] as String? ?? '',
      colorText: json['colorText'] as String? ?? '',
      imageUrl: (json['imageUrl'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      quantity: json['quantity'] as int? ?? 0,
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      location: json['location'] as String? ?? '',
      importance: json['importance'] as int? ?? 0,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : 0.0,
      favorites: json['favorites'] as bool? ?? false,
    );
  }


  final String id;
  final String title;
  final String description;
  final String type;
  final String typDescription;
  final String color;
  final String colorText;
  final List<String>? imageUrl;
  final int quantity;
  final double price;
  final String location;
  final int importance;
  final double weight;
  final bool favorites;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    typDescription,
    color,
    colorText,
    imageUrl,
    quantity,
    price,
    location,
    importance,
    weight,
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
    int? importance,
    double? weight,
    bool? favorites
  }) {
    return ThingsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      typDescription: typDescription ?? this.typDescription,
      color: color ?? this.color,
      colorText: colorText ?? this.colorText,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      location: location ?? this.location,
      importance: importance ?? this.importance,
      weight: weight ?? this.weight,
      favorites: favorites ?? this.favorites,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'typDescription': typDescription,
      'color': color,
      'colorText': colorText,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
      'location': location,
      'importance': importance,
      'weight': weight,
      'favorites': favorites,
    };
  }
}
