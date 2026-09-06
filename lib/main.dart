import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_page.dart';
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
                      'Address feature coming soon.',
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
                      'Help & Support coming soon.',
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

// ================= LOGIN =================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController =
      TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void continueLogin() {
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'कृपया 10 अंकी Mobile Number टाका.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'OTP login Firebase Authentication मध्ये पुढील step मध्ये जोडू.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant,
              size: 80,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),

            const Text(
              'Newasa Food Hub',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: continueLogin,
                child: const Text(
                  'Continue with OTP',
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
                  '$title feature coming soon.',
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
  final itemName = TextEditingController();
  final price = TextEditingController();

  String category = 'Veg';

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

  void addMenuItem() {
    if (itemName.text.trim().isEmpty ||
        int.tryParse(price.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Item name आणि योग्य price भरा.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${itemName.text.trim()} menu मध्ये जोडले.',
        ),
      ),
    );

    itemName.clear();
    price.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Item'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: itemName,
            decoration: const InputDecoration(
              labelText: 'Food Item Name',
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
              return DropdownMenuItem(
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

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: addMenuItem,
              child: const Text(
                'Add Menu Item',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
