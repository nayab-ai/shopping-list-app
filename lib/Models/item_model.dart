// lib/models/item_model.dart
class ItemModel {
  String name;
  int quantity;
  String id;

  ItemModel({
    required this.name,
    required this.quantity,
    required this.id,
  });

  // Convert ItemModel to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'id': id,
    };
  }

  // Create ItemModel from Map
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }
}