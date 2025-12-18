import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddMenuItemScreen extends StatefulWidget {
  const AddMenuItemScreen({super.key});

  @override
  State<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL("https://umami-express-default-rtdb.firebaseio.com");

  Future<void> _addItem() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() => _isLoading = true);

    try {
      await _dbRef.child('restaurants').child(uid).child('menu').push().set({
        'name': _nameController.text,
        'description': _descController.text,
        'price': double.parse(_priceController.text),
        'imageUrl': 'assets/food_placeholder.jpg'
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Dish")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Dish Name")),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: "Description")),
            TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price (\$")),
            const SizedBox(height: 30),
            _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _addItem, child: const Text("Add to Menu"))
          ],
        ),
      ),
    );
  }
}