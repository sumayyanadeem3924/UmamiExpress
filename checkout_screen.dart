// lib/screens/customer/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL("https://umami-express-default-rtdb.firebaseio.com");
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  double deliveryFee = 5.00;
  bool _isPlacingOrder = false;

  // Logic to save the order and clear the cart
  Future<void> _placeOrder(Map<dynamic, dynamic> cartItems, double total, String address) async {
    if (_uid == null) return;

    setState(() => _isPlacingOrder = true);

    try {
      // 1. Create the Order object
      final orderData = {
        'items': cartItems,
        'totalAmount': total,
        'deliveryAddress': address,
        'status': 'Pending',
        'orderTime': ServerValue.timestamp,
      };

      // 2. Push to 'orders' node
      await _dbRef.child('orders').child(_uid!).push().set(orderData);

      // 3. Clear the user's cart
      await _dbRef.child('users').child(_uid!).child('cart').remove();

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text('Your delicious meal is on the way.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) return const Scaffold(body: Center(child: Text("Please login")));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _dbRef.child('users/$_uid').onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No user data found."));
          }

          final userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final String address = userData['address'] ?? "No address provided";
          final Map<dynamic, dynamic> cartItems = userData['cart'] ?? {};

          double subtotal = 0;
          cartItems.forEach((key, value) {
            subtotal += (value['price'] * value['quantity']);
          });
          double total = subtotal + deliveryFee;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Delivery Address Section ---
                      const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.indigo),
                          title: Text(address),
                          subtitle: const Text("Tap to change in Profile"),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Order Summary Section ---
                      const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...cartItems.entries.map((entry) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${entry.value['name']} x${entry.value['quantity']}"),
                          trailing: Text("\$${(entry.value['price'] * entry.value['quantity']).toStringAsFixed(2)}"),
                        );
                      }).toList(),

                      const Divider(height: 30),

                      // --- Final Totals ---
                      _buildPriceRow("Subtotal", subtotal),
                      _buildPriceRow("Delivery Fee", deliveryFee),
                      const Divider(),
                      _buildPriceRow("Total", total, isBold: true),
                    ],
                  ),
                ),
              ),

              // --- Checkout Button ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isPlacingOrder || cartItems.isEmpty
                      ? null
                      : () => _placeOrder(cartItems, total, address),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isPlacingOrder
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Confirm Order • \$${total.toStringAsFixed(2)}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("\$${amount.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}