import 'package:flutter/material.dart';
// Import necessary files
import 'home_screen.dart'; // To access the CartItem model

class FoodDetailScreen extends StatelessWidget {
  final String foodName;
  final double defaultPrice;
  final String description; // NEW
  final String imageUrl;    // NEW
  final void Function(CartItem item) addToCartCallback;

  const FoodDetailScreen({
    super.key,
    required this.foodName,
    required this.defaultPrice,
    required this.description,
    required this.imageUrl,
    required this.addToCartCallback,
  });

  @override
  Widget build(BuildContext context) {
    const int currentQuantity = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(foodName),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ⭐️ Image Display ⭐️
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(
                        '$foodName Image',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                foodName,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${defaultPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.green),
                  ),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {}),
                      Text('$currentQuantity', style: const TextStyle(fontSize: 18)),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40), // Added space before button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                  onPressed: () {
                    final newItem = CartItem(
                      name: foodName,
                      price: defaultPrice,
                      quantity: currentQuantity,
                    );
                    addToCartCallback(newItem);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}