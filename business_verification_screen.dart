import 'package:flutter/material.dart';

class BusinessVerificationScreen extends StatelessWidget {
  const BusinessVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user, size: 100, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text("Verification Pending", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Our team is reviewing your business details. You will gain access to your dashboard shortly.", textAlign: TextAlign.center),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/business_dashboard'),
                  child: const Text("Check Status / Go to Dashboard")
              )
            ],
          ),
        ),
      ),
    );
  }
}