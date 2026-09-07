import 'food_model.dart';

class CartModel {
  final FoodModel food;
  int quantity;

  CartModel({
    required this.food,
    this.quantity = 1,
  });

  double get totalPrice => food.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'foodId': food.id,
      'restaurantId': food.restaurantId,
      'name': food.name,
      'price': food.price,
      'category': food.category,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
