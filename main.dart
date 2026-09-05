import 'package:flutter/material.dart';

void main() => runApp(const NewasaFoodHub());

class NewasaFoodHub extends StatelessWidget {
  const NewasaFoodHub({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Newasa Food Hub',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
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
  @override State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final phone = TextEditingController();
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🍔', style: TextStyle(fontSize: 64)),
        const Text('Newasa Food Hub', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const Text('Newasa ची चव, आता घरपोच!'),
        const SizedBox(height: 30),
        TextField(controller: phone, keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder())),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())),
          child: const Text('Continue with OTP'),
        )),
        const SizedBox(height: 10),
        const Text('Demo login: OTP verification पुढील Firebase आवृत्तीत जोडता येईल.')
      ]),
    )),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int tab = 0;
  final cart = <Food>[];

  void add(Food f) {
    setState(() => cart.add(f));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${f.name} cart मध्ये जोडले')));
  }

  @override Widget build(BuildContext context) {
    final pages = [_home(), _orders(), _cart(), _profile()];
    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (i)=>setState(()=>tab=i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ]),
    );
  }

  Widget _home() => SafeArea(child: CustomScrollView(slivers: [
    SliverPadding(padding: const EdgeInsets.all(18), sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('📍 Newasa', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      const Text('Newasa Food Hub', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
      const SizedBox(height: 14),
      TextField(decoration: InputDecoration(hintText:'Food किंवा Hotel शोधा', prefixIcon: const Icon(Icons.search), filled:true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none))),
      const SizedBox(height: 18),
      Container(width:double.infinity, padding:const EdgeInsets.all(20),
        decoration:BoxDecoration(borderRadius:BorderRadius.circular(20), gradient:const LinearGradient(colors:[Colors.deepOrange,Colors.orange])),
        child:const Text('🎉 पहिल्या ऑर्डरवर खास ऑफर', style:TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.bold))),
      const SizedBox(height:20),
      const Text('Restaurants & Food', style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    ]))),
    SliverPadding(padding:const EdgeInsets.symmetric(horizontal:18), sliver:SliverList.builder(
      itemCount:foods.length, itemBuilder:(c,i){ final f=foods[i]; return Card(
        child:ListTile(contentPadding:const EdgeInsets.all(10),
          leading:Container(width:58,height:58,decoration:BoxDecoration(color:Colors.orange.shade100,borderRadius:BorderRadius.circular(14)),
            child:Center(child:Text(f.category=='Pizza'?'🍕':f.category=='Burger'?'🍔':f.category=='Biryani'?'🍚':'🍽️',style:const TextStyle(fontSize:28)))),
          title:Text(f.name,style:const TextStyle(fontWeight:FontWeight.bold)),
          subtitle:Text('${f.restaurant}\n₹${f.price}'),
          trailing:FilledButton(onPressed:()=>add(f),child:const Text('Add'))),
      );},
    ))
  ]));

  Widget _orders() => const SafeArea(child: Padding(padding:EdgeInsets.all(20), child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text('My Orders',style:TextStyle(fontSize:28,fontWeight:FontWeight.w800)),
    SizedBox(height:25),
    Card(child:ListTile(leading:Icon(Icons.delivery_dining),title:Text('Order Tracking'),subtitle:Text('Pending → Preparing → Out for Delivery → Delivered'))),
  ])));

  Widget _cart() {
    final total=cart.fold<int>(0,(s,f)=>s+f.price);
    return SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('Cart',style:TextStyle(fontSize:28,fontWeight:FontWeight.w800)),
      const SizedBox(height:15),
      Expanded(child:cart.isEmpty?const Center(child:Text('Cart रिकामी आहे')):ListView(children:cart.map((f)=>ListTile(title:Text(f.name),subtitle:Text(f.restaurant),trailing:Text('₹${f.price}'))).toList())),
      if(cart.isNotEmpty) ...[
        Text('Total: ₹$total',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
        const SizedBox(height:10),
        SizedBox(width:double.infinity,child:FilledButton(onPressed:()=>_checkout(total),child:const Text('Checkout')))
      ]
    ])));
  }

  void _checkout(int total) {
    showModalBottomSheet(context:context,builder:(c)=>Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('Checkout',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold)),
      Text('Total: ₹$total'),
      const SizedBox(height:12),
      const Text('Payment Method',style:TextStyle(fontWeight:FontWeight.bold)),
      ListTile(leading:const Icon(Icons.money),title:const Text('Cash on Delivery'),onTap:()=>_confirmOrder(c)),
      ListTile(leading:const Icon(Icons.account_balance_wallet),title:const Text('UPI / Online Payment'),subtitle:const Text('Payment gateway पुढील आवृत्तीत जोडता येईल.'),onTap:()=>_confirmOrder(c)),
    ])));
  }

  void _confirmOrder(BuildContext sheet) {
    Navigator.pop(sheet);
    setState(()=>cart.clear());
    showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Order Confirmed 🎉'),
      content:const Text('तुमची ऑर्डर नोंदवली आहे. Status: Pending'),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('OK'))]));
  }

  Widget _profile()=>const SafeArea(child:Padding(padding:EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text('Profile',style:TextStyle(fontSize:28,fontWeight:FontWeight.w800)),
    SizedBox(height:20),
    ListTile(leading:Icon(Icons.person),title:Text('Customer Account'),subtitle:Text('Mobile login')),
    ListTile(leading:Icon(Icons.location_on),title:Text('Delivery Address'),subtitle:Text('Newasa')),
    ListTile(leading:Icon(Icons.support_agent),title:Text('Help & Support')),
  ])));
}
