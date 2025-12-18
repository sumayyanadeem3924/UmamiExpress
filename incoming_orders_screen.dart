import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class IncomingOrdersScreen extends StatelessWidget {
  const IncomingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final DatabaseReference _orderRef = FirebaseDatabase.instance
        .refFromURL("https://umami-express-default-rtdb.firebaseio.com")
        .child('orders'); // In a real app, filter orders where restaurantId == uid

    return Scaffold(
      appBar: AppBar(title: const Text("Live Orders")),
      body: StreamBuilder(
        stream: _orderRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No orders yet."));
          }

          Map<dynamic, dynamic> orders = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<dynamic> orderList = orders.values.toList();

          return ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final order = orderList[index];
              return ListTile(
                title: Text("Order Total: \$${order['totalAmount']}"),
                subtitle: Text("Delivery to: ${order['deliveryAddress']}"),
                trailing: const Icon(Icons.chevron_right),
              );
            },
          );
        },
      ),
    );
  }
}