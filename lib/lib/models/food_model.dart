class FoodModel {
  final String id;
  final String restaurantId;
  final String name;
  final int price;
  final String category;
  final bool isAvailable;

  FoodModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    required this.category,
    required this.isAvailable,
  });

  factory FoodModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return FoodModel(
      id: id,
      restaurantId: (data['restaurantId'] ?? '').toString(),
      name: (data['name'] ?? 'Food Item').toString(),
      price: (data['price'] ?? 0) is int
          ? data['price'] as int
          : int.tryParse(data['price'].toString()) ?? 0,
      category: (data['category'] ?? 'Other').toString(),
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
    };
  }
}
