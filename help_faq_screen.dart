import 'package:flutter/material.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & FAQ")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text("How do I track my order?"),
            children: [Padding(padding: EdgeInsets.all(8), child: Text("Go to Order History and click on any active order."))],
          ),
          ExpansionTile(
            title: Text("How to become a partner?"),
            children: [Padding(padding: EdgeInsets.all(8), child: Text("Log out and choose 'Sell Food' during onboarding."))],
          ),
        ],
      ),
    );
  }
}