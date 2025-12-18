import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final dbRef = FirebaseDatabase.instance.ref().child('orders').child(uid!);

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No order history found."));
          }
          Map<dynamic, dynamic> orders = snapshot.data!.snapshot.value as Map;
          return ListView(
            children: orders.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Order ID: ${entry.key.toString().substring(0, 8)}"),
                  subtitle: Text("Total: \$${entry.value['totalAmount']}"),
                  trailing: Text(entry.value['status'],
                      style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.pushNamed(context, '/order_detail', arguments: entry.value),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}