import 'package:flutter/material.dart';

import '../../services/cart_service.dart';
import '../../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartService.items;
    final subtotal = _cartService.subtotal;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: Text(
          'Cart (${_cartService.itemCount})',
        ),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: 'Clear Cart',
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showClearCartDialog,
            ),
        ],
      ),
      body: items.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(items[index]);
                    },
                  ),
                ),
                _buildBottomSummary(subtotal),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'तुमचा Cart रिकामा आहे',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'तुमचे आवडते पदार्थ Cart मध्ये add करा.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Menu पाहा'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartModel cartItem) {
    final food = cartItem.food;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '🍽️',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${food.price}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          _cartService.decreaseQuantity(food.id);
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      _quantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          _cartService.increaseQuantity(food.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _cartService.removeFromCart(food.id);
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${cartItem.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomSummary(double subtotal) {
    const double deliveryCharge = 0;

    final double total = subtotal + deliveryCharge;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        16,
        20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _summaryRow(
              'Item Total',
              '₹${subtotal.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 8),
            _summaryRow(
              'Delivery Charge',
              deliveryCharge == 0
                  ? 'FREE'
                  : '₹${deliveryCharge.toStringAsFixed(0)}',
            ),
            const Divider(height: 20),
            _summaryRow(
              'Total',
              '₹${total.toStringAsFixed(0)}',
              isTotal: true,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Checkout लवकरच उपलब्ध होईल.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 19 : 15,
            fontWeight:
                isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.orange : Colors.black,
          ),
        ),
      ],
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cart Clear करायचा?'),
          content: const Text(
            'Cart मधील सर्व पदार्थ काढले जातील.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _cartService.clearCart();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
