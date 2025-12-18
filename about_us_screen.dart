import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.indigo),
            SizedBox(height: 20),
            Text("Umami Express", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "Version 1.0.0\n\nWe are dedicated to bringing the finest local cuisines right to your doorstep with speed and care.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}