import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'services/firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const NewasaFoodHub());
}

class NewasaFoodHub extends StatelessWidget {
  const NewasaFoodHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newasa Food Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
      ),
      home: const MainScreen(),
    );
  }
}

// ================= MAIN SCREEN =================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    OrdersPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ================= ORDERS =================

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 70,
              color: Colors.deepOrange,
            ),
            SizedBox(height: 15),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your orders will appear here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CART =================

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 70,
              color: Colors.deepOrange,
            ),
            SizedBox(height: 15),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add delicious food to your cart.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PROFILE =================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 15),

          const Center(
            child: Text(
              'Newasa Food Hub',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 25),

          Card(
            child: ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login / Register'),
              subtitle: const Text('Customer account'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Hotel Partner'),
              subtitle: const Text('Manage your restaurant'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PartnerDashboard(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Delivery Address'),
              subtitle: const Text(
                'Add your delivery address',
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Address feature पुढील step मध्ये जोडू.',
                    ),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Help & Support'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Help & Support पुढील step मध्ये जोडू.',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PARTNER DASHBOARD =================

class PartnerDashboard extends StatelessWidget {
  const PartnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hotel Partner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _partnerTile(
            context,
            Icons.add_business,
            'Add Hotel',
            'Register your hotel',
            const AddHotelPage(),
          ),

          _partnerTile(
            context,
            Icons.restaurant_menu,
            'Add Menu',
            'Add food items',
            const AddMenuPage(),
          ),

          _partnerTile(
            context,
            Icons.menu_book,
            'My Menu',
            'Manage menu items',
            null,
          ),

          _partnerTile(
            context,
            Icons.shopping_bag,
            'New Orders',
            'View customer orders',
            null,
          ),

          _partnerTile(
            context,
            Icons.history,
            'Order History',
            'Previous orders',
            null,
          ),
        ],
      ),
    );
  }

  Widget _partnerTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget? page,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.deepOrange,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => page,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$title feature पुढील step मध्ये जोडू.',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// ================= ADD HOTEL =================

class AddHotelPage extends StatefulWidget {
  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {
  final hotelName = TextEditingController();
  final location = TextEditingController();
  final phone = TextEditingController();

  bool isSaving = false;

  @override
  void dispose() {
    hotelName.dispose();
    location.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<void> saveHotel() async {
    if (hotelName.text.trim().isEmpty ||
        location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hotel name आणि location भरा.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirestoreService().addRestaurant(
        name: hotelName.text.trim(),
        location: location.text.trim(),
        phone: phone.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hotel Firebase मध्ये Save झाला. ✅',
          ),
        ),
      );

      hotelName.clear();
      location.clear();
      phone.clear();

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Save failed: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hotel'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: hotelName,
            decoration: const InputDecoration(
              labelText: 'Hotel Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: location,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isSaving ? null : saveHotel,
              child: isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    )
                  : const Text(
                      'Save Hotel',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= ADD MENU =================

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final FirestoreService _service = FirestoreService();

  final itemName = TextEditingController();
  final price = TextEditingController();

  String category = 'Veg';
  String? selectedRestaurantId;

  bool isSaving = false;

  final categories = const [
    'Veg',
    'Non-Veg',
    'Biryani',
    'Chicken',
    'Mutton',
    'Thali',
    'Fast Food',
    'Drinks',
  ];

  @override
  void dispose() {
    itemName.dispose();
    price.dispose();
    super.dispose();
  }

  Future<void> addMenuItem() async {
    final name = itemName.text.trim();
    final itemPrice = int.tryParse(price.text.trim());

    if (selectedRestaurantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'कृपया Hotel निवडा.',
          ),
        ),
      );
      return;
    }

    if (name.isEmpty ||
        itemPrice == null ||
        itemPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Item name आणि योग्य price भरा.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _service.addMenuItem(
        restaurantId: selectedRestaurantId!,
        name: name,
        price: itemPrice,
        category: category,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Menu Firebase मध्ये Save झाला. ✅',
          ),
        ),
      );

      itemName.clear();
      price.clear();

      setState(() {
        category = 'Veg';
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Menu Save failed: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Item'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _service.restaurantsStream(),
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
                  'Hotels load करताना error आला.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }

          final hotels = snapshot.data?.docs ?? [];

          if (hotels.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'पहिले एक Hotel Add करा.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }

          if (selectedRestaurantId == null ||
              !hotels.any(
                (hotel) =>
                    hotel.id == selectedRestaurantId,
              )) {
            selectedRestaurantId = hotels.first.id;
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Hotel निवडा',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: selectedRestaurantId,
                decoration: const InputDecoration(
                  labelText: 'Select Hotel',
                  border: OutlineInputBorder(),
                ),
                items: hotels.map((hotel) {
                  final data = hotel.data();

                  return DropdownMenuItem<String>(
                    value: hotel.id,
                    child: Text(
                      (data['name'] ?? 'Hotel').toString(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRestaurantId = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextField(
                controller: itemName,
                decoration: const InputDecoration(
                  labelText: 'Food Item Name',
                  hintText: 'उदा. Chicken Biryani',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      isSaving ? null : addMenuItem,
                  child: isSaving
                      ? const SizedBox(
      
