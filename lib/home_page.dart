import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> hotels = const [
    {
      'name': 'Hotel Rajmudra',
      'location': 'Nevasa Phata',
      'rating': '4.5',
      'time': '25-35 min',
      'image': '🍗',
      'tag': 'Popular',
    },
    {
      'name': 'Newasa Family Restaurant',
      'location': 'Newasa',
      'rating': '4.3',
      'time': '30-40 min',
      'image': '🍛',
      'tag': 'Recommended',
    },
    {
      'name': 'Royal Biryani',
      'location': 'Newasa',
      'rating': '4.4',
      'time': '25-35 min',
      'image': '🍚',
      'tag': 'Biryani',
    },
    {
      'name': 'Food Corner',
      'location': 'Newasa',
      'rating': '4.2',
      'time': '30-40 min',
      'image': '🍔',
      'tag': 'Fast Food',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header(context)),
            SliverToBoxAdapter(child: _searchBox()),
            SliverToBoxAdapter(child: _offerBanner()),
            SliverToBoxAdapter(child: _categories()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nearby Hotels',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllHotelsPage(),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _hotelCard(context, hotels[index]);
                  },
                  childCount: hotels.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.deepOrange,
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DELIVER TO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 17,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 3),
                    Text(
                      'Newasa',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search food or hotels...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.tune),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _offerBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Colors.deepOrange,
              Colors.orange,
            ],
          ),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SPECIAL OFFER',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Delicious food\nat your doorstep!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '🍗',
              style: TextStyle(fontSize: 65),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories() {
    final categories = [
      'All',
      'Biryani',
      'Chicken',
      'Veg',
      'Thali',
      'Fast Food',
    ];

    return SizedBox(
      height: 105,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            width: 82,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: index == 0 ? Colors.deepOrange : Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: index == 0
                    ? Colors.deepOrange
                    : Colors.grey.shade200,
              ),
            ),
            child: Center(
              child: Text(
                categories[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: index == 0 ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hotelCard(
    BuildContext context,
    Map<String, dynamic> hotel,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Center(
                child: Text(
                  hotel['image'],
                  style: const TextStyle(fontSize: 75),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hotel['name'],
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Text(
                  hotel['location'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 3),
                Text(
                  hotel['rating'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelMenuPage(
                        hotelName: hotel['name'],
                        location: hotel['location'],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.restaurant_menu),
                label: const Text(
                  'View Menu',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ALL HOTELS =================

class AllHotelsPage extends StatelessWidget {
  const AllHotelsPage({super.key});

  final List<String> names = const [
    'Hotel Rajmudra',
    'Newasa Family Restaurant',
    'Royal Biryani',
    'Food Corner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Hotels',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepOrange.shade50,
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.deepOrange,
                ),
              ),
              title: Text(
                names[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('Newasa • 25-35 min'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HotelMenuPage(
                      hotelName: names[index],
                      location: 'Newasa',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ================= HOTEL MENU =================

class HotelMenuPage extends StatelessWidget {
  final String hotelName;
  final String location;

  const HotelMenuPage({
    super.key,
    required this.hotelName,
    required this.location,
  });

  final List<Map<String, dynamic>> menu = const [
    {
      'name': 'Chicken Biryani',
      'price': 180,
      'category': 'Biryani',
      'emoji': '🍗',
    },
    {
      'name': 'Chicken Masala',
      'price': 150,
      'category': 'Chicken',
      'emoji': '🍛',
    },
    {
      'name': 'Paneer Masala',
      'price': 150,
      'category': 'Veg',
      'emoji': '🥘',
    },
    {
      'name': 'Veg Thali',
      'price': 120,
      'category': 'Thali',
      'emoji': '🍱',
    },
    {
      'name': 'Chicken Thali',
      'price': 200,
      'category': 'Thali',
      'emoji': '🍗',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hotelName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            hotelName,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            location,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 22),
          const Text(
            'Menu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...menu.map(
            (item) => Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      item['emoji'],
                      style: const TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                title: Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '₹${item['price']} • ${item['category']}',
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item['name']} added to cart',
                        ),
                      ),
                    );
                  },
                  child: const Text('ADD'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
