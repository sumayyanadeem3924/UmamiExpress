import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve order data passed via Navigator
    final Map<dynamic, dynamic> orderData = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${orderData['status']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const Divider(),
            const Text("Items:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Logic to list items from the orderData map...
            const Spacer(),
            Text("Total Paid: \$${orderData['totalAmount']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}