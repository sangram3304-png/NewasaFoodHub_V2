import 'package:flutter/material.dart';

void main() => runApp(const NewasaFoodHub());

class NewasaFoodHub extends StatelessWidget {
  const NewasaFoodHub({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Newasa Food Hub',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepOrange,
        ),
        home: const LoginPage(),
      );
}

class Food {
  final String name, restaurant, category;
  final int price;

  Food(this.name, this.restaurant, this.category, this.price);
}

final foods = [
  Food('Veg Thali', 'Newasa Family Restaurant', 'Thali', 140),
  Food('Masala Dosa', 'Shree South Indian', 'South Indian', 90),
  Food('Veg Pizza', 'Food Corner', 'Pizza', 180),
  Food('Chicken Biryani', 'Royal Biryani', 'Biryani', 190),
  Food('Veg Burger', 'Cafe Newasa', 'Burger', 110),
  Food('Misal Pav', 'Maharashtra Snacks', 'Snacks', 80),
];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phone = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🍔', style: TextStyle(fontSize: 64)),
                const Text(
                  'Newasa Food Hub',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Newasa ची चव, आता घरपोच!'),
                const SizedBox(height: 30),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    ),
                    child: const Text('Continue with OTP'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Demo login: OTP verification पुढील Firebase आवृत्तीत जोडता येईल.',
                ),
              ],
            ),
          ),
        ),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  final cart = <Food>[];

  void add(Food f) {
    setState(() => cart.add(f));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${f.name} cart मध्ये जोडले'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _orders(),
      _cart(),
      _profile(),
    ];

    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home
