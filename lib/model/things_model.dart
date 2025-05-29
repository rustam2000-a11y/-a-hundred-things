import 'package:equatable/equatable.dart';

class ThingsModel extends Equatable{
  const ThingsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.typDescription,
    required this.color,
    required this.imageUrl,
    required this.quantity,
  });

  factory ThingsModel.fromJson(Map<String, dynamic> json) {
    return ThingsModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      color: json['color'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0, typDescription: json['typDescription'] as String? ?? ''
    );
  }

  final String id;
  final String title;
  final String description;
  final String type;
  final String color;
  final String? imageUrl;
  final int quantity;
  final String typDescription;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    color,
    imageUrl,
    quantity,
    typDescription
  ];



  ThingsModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? color,
    String? imageUrl,
    int? quantity,
    String? typDescription,
  }) {
    return ThingsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      typDescription: typDescription ?? this.typDescription,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'color': color,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'typDescription': typDescription,
    };
  }
}