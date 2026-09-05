import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
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
        fontFamily: 'Arial',
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
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    OrdersPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.deepOrange.shade200,
            ),
            const SizedBox(height: 15),
            const Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Your orders will appear here.'),
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
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.deepOrange.shade200,
            ),
            const SizedBox(height: 15),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Add delicious food to your cart.'),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.deepOrange,
                  Colors.orange,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 38,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Login / Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          _profileButton(
            context,
            Icons.login,
            'Login / Register',
            'Customer account',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),

          _profileButton(
            context,
            Icons.storefront,
            'Hotel Partner',
            'Register and manage your hotel',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PartnerDashboard(),
                ),
              );
            },
          ),

          _profileButton(
            context,
            Icons.location_on_outlined,
            'Delivery Address',
            'Manage your delivery address',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address feature coming soon.'),
                ),
              );
            },
          ),

          _profileButton(
            context,
            Icons.help_outline,
            'Help & Support',
            'Get help with your orders',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & Support coming soon.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _profileButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange.shade50,
          child: Icon(
            icon,
            color: Colors.deepOrange,
          ),
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
        onTap: onTap,
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
  final mobileController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  void continueLogin() {
    final mobile = mobileController.text.trim();

    if (mobile.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid mobile number.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Login system will be connected with Firebase.',
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
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.restaurant,
              size: 70,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Newasa Food Hub',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: continueLogin,
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 17),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.deepOrange,
                  Colors.orange,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.storefront,
                  color: Colors.white,
                  size: 42,
                ),
                SizedBox(height: 10),
                Text(
                  'Partner Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Manage your hotel, menu and orders',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _partnerTile(
            context,
            Icons.add_business,
            'Add Hotel',
            'Register your hotel on Newasa Food Hub',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddHotelPage(),
                ),
              );
            },
          ),

          _partnerTile(
            context,
            Icons.restaurant_menu,
            'Add Menu',
            'Add food items, prices and categories',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddMenuPage(),
                ),
              );
            },
          ),

          _partnerTile(
            context,
            Icons.menu_book,
            'My Menu',
            'View and manage your menu',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('My Menu coming soon.'),
                ),
              );
            },
          ),

          _partnerTile(
            context,
            Icons.receipt_long,
            'New Orders',
            'Manage customer orders',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Orders system coming soon.'),
                ),
              );
            },
          ),

          _partnerTile(
            context,
            Icons.history,
            'Order History',
            'View completed orders',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order history coming soon.'),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
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
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: Colors.deepOrange.shade50,
          child: Icon(
            icon,
            color: Colors.deepOrange,
            size: 27,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 17,
        ),
        onTap: onTap,
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

  @override
  void dispose() {
    hotelName.dispose();
    location.dispose();
    phone.dispose();
    super.dispose();
  }

  void saveHotel() {
    if (hotelName.text.trim().isEmpty ||
        location.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter hotel name and location.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Hotel saved. Firebase database will be connected next.',
        ),
      ),
    );
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
          const Text(
            'Hotel Information',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          _field(
            hotelName,
            'Hotel Name',
            Icons.storefront,
          ),

          const SizedBox(height: 14),

          _field(
            location,
            'Hotel Location',
            Icons.location_on,
          ),

          const SizedBox(height: 14),

          _field(
            phone,
            'Contact Number',
            Icons.phone,
            keyboard: TextInputType.phone,
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: saveHotel,
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Hotel',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
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
  final description = TextEditingController();

  String category = 'Veg';

  final List<String> categories = [
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
    description.dispose();
    super.dispose();
  }

  void addMenuItem() {
    if (itemName.text.trim().isEmpty ||
        price.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter food name and price.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${itemName.text.trim()} added to menu.',
        ),
      ),
    );

    itemName.clear();
    price.clear();
    description.clear();

    setState(() {
      category = 'Veg';
    });
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
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo,
                  size: 42,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                height: 52,
            child: ElevatedButton.icon(
              onPressed: addMenuItem,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Menu Item',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
                
