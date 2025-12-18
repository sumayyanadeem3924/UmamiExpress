import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_screen.dart'; // To access the CartItem model

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final DatabaseReference cartRef = FirebaseDatabase.instance
        .refFromURL("https://umami-express-default-rtdb.firebaseio.com")
        .child('users/$uid/cart');

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: StreamBuilder<DatabaseEvent>(
        stream: cartRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("Your cart is empty."));
          }

          Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<CartItem> cartList = [];
          double totalAmount = 0;

          data.forEach((key, value) {
            final item = CartItem.fromMap(value, key.toString());
            cartList.add(item);
            totalAmount += (item.price * item.quantity);
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    final item = cartList[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text("\$${item.price} x ${item.quantity}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => cartRef.child(item.id).remove(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("\$${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        // Logic for Checkout will go here
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Processing Order...")));
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}