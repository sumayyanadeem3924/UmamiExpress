import 'package:flutter/material.dart';

class BusinessChoiceScreen extends StatelessWidget {
  const BusinessChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.indigo),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.business_center, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text("Grow your business with\nUMAMI EXPRESS", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.indigo, minimumSize: const Size(250, 50)),
                onPressed: () => Navigator.pushNamed(context, '/business_signup'),
                child: const Text("Register My Restaurant")
            ),
            const SizedBox(height: 15),
            OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white), foregroundColor: Colors.white, minimumSize: const Size(250, 50)),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text("Partner Login")
            ),
          ],
        ),
      ),
    );
  }
}