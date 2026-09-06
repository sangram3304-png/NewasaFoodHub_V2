import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  String searchText = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Veg',
    'Non-Veg',
    'Biryani',
    'Thali',
    'Fast Food',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          'Newasa Food Hub',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(),
            _buildOfferBanner(),
            _buildCategories(),
            _buildNearbyHotels(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchText = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'हॉटेल किंवा पदार्थ शोधा...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'आजची Special Offer 🔥',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'चविष्ट जेवण • जवळचे हॉटेल • सोपी ऑर्डर',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Colors.orange,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyHotels() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nearby Hotels',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestoreService.restaurantsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Hotels load करताना error आला.\n${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'सध्या कोणतेही हॉटेल उपलब्ध नाही.',
                      ),
                    ),
                  ),
                );
              }

              final hotels = snapshot.data!.docs.where((doc) {
                final data = doc.data();

                final name =
                    (data['name'] ?? '').toString().toLowerCase();

                final location =
                    (data['location'] ?? '').toString().toLowerCase();

                final matchesSearch =
                    searchText.isEmpty ||
                    name.contains(searchText) ||
                    location.contains(searchText);

                return matchesSearch;
              }).toList();

              if (hotels.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'शोधानुसार हॉटेल सापडले नाही.',
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: hotels.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  final data = hotel.data();

                  final itemName =
                      (data['name'] ?? 'Hotel').toString();

                  final location =
                      (data['location'] ?? 'Newasa').toString();

                  final phone =
                      (data['phone'] ?? '').toString();

                  final rating =
                      (data['rating'] ?? 0).toString();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            '🍛',
                            style: TextStyle(fontSize: 27),
                          ),
                        ),
                      ),
                      title: Text(
                        itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(location),
                            if (phone.isNotEmpty)
                              Text(
                                phone,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            const SizedBox(height: 3),
                            Text(
                              '⭐ $rating',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.orange,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelMenuPage(
                              restaurantId: hotel.id,
                              restaurantName: itemName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class HotelMenuPage extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  const HotelMenuPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: service.menuStream(restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Menu load करताना error आला.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'या हॉटेलचा Menu अजून उपलब्ध नाही.',
              ),
            );
          }

          final menuItems = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index].data();

              final name =
                  (item['name'] ?? 'Food Item').toString();

              final category =
                  (item['category'] ?? '').toString();

              final price =
                  (item['price'] ?? 0).toString();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        '🍽️',
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(category),
                  trailing: Text(
                    '₹$price',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
