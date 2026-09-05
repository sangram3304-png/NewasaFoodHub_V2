import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> restaurantsStream() {
    return _db
        .collection('restaurants')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> menuStream(
    String restaurantId,
  ) {
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .where('isAvailable', isEqualTo: true)
        .snapshots();
  }

  Future<void> addRestaurant({
    required String name,
    required String location,
    required String phone,
  }) async {
    await _db.collection('restaurants').add({
      'name': name,
      'location': location,
      'phone': phone,
      'rating': 0.0,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addMenuItem({
    required String restaurantId,
    required String name,
    required int price,
    required String category,
  }) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .add({
      'name': name,
      'price': price,
      'category': category,
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
