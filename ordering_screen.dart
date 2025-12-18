import 'package:flutter/material.dart';

class OrderingScreen extends StatelessWidget {
  const OrderingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appUEScreen/customer/ordering_screen.dart`pBar: AppBar(
    title: const Text('Order Status'),
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    ),
    body: Center(
    child: Padding(
    padding: const EdgeInsets.all(30.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    const Text(
    'Your Order is Being Prepared!',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
    ),
    const SizedBox(height: 40),
    const LinearProgressIndicator(
    value: 0.6, // 60% complete
    minHeight: 10,
    color: Colors.green,
    backgroundColor: Colors.grey,
    ),
    const SizedBox(height: 20),
    const Text(
    'Estimated delivery in 25 minutes.',
    style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
    const SizedBox(height: 60),
    const Icon(Icons.motorcycle, size: 80, color: Colors.green),
    const SizedBox(height: 10),
    const Text('Driver is on the way!', style: TextStyle(fontSize: 18)),
    ],
    ),
    ),
    ),
    );
  }
}