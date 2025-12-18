import 'package:flutter/material.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Business Dashboard"), actions: [
        IconButton(icon: const Icon(Icons.person), onPressed: () => Navigator.pushNamed(context, '/business_profile')),
      ]),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        children: [
          _buildStatCard(context, "Incoming Orders", Icons.receipt_long, '/incoming_orders', Colors.orange),
          _buildStatCard(context, "Manage Menu", Icons.restaurant_menu, '/add_menu_item', Colors.green),
          _buildStatCard(context, "Earnings", Icons.attach_money, null, Colors.blue),
          _buildStatCard(context, "Reviews", Icons.star, null, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, IconData icon, String? route, Color color) {
    return Card(
      child: InkWell(
        onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}