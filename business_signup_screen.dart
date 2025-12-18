import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BusinessSignupScreen extends StatefulWidget {
  const BusinessSignupScreen({super.key});

  @override
  State<BusinessSignupScreen> createState() => _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends State<BusinessSignupScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL("https://umami-express-default-rtdb.firebaseio.com");

  Future<void> _registerBusiness() async {
    setState(() => _isLoading = true);
    try {
      // 1. Create Auth Account
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 2. Save Business Details to 'restaurants' node
      await _dbRef.child('restaurants').child(uid).set({
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'cuisine': _cuisineController.text.trim(),
        'rating': 5.0, // Default rating for new business
        'imageUrl': 'assets/placeholder_restaurant.jpg',
        'ownerUid': uid,
        'isVerified': false,
      });

      if (mounted) Navigator.pushReplacementNamed(context, '/business_verification');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Your Business")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Restaurant Name")),
            TextField(controller: _cuisineController, decoration: const InputDecoration(labelText: "Cuisine Type (e.g. Italian)")),
            TextField(controller: _addressController, decoration: const InputDecoration(labelText: "Business Address")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Business Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _registerBusiness, child: const Text("Create Business Account"))
          ],
        ),
      ),
    );
  }
}