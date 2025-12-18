import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import to use Restaurant, CartItem, and RestaurantCard

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final List<Restaurant> restaurants;
  final void Function(CartItem item) addToCartCallback;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.restaurants,
    required this.addToCartCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Restaurants'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: restaurants.isEmpty
          ? Center(
        child: Text(
          'No restaurants found for $categoryName.',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          // Reuse the existing RestaurantCard
          return RestaurantCard(
            restaurant: restaurant,
            addToCartCallback: addToCartCallback,
          );
        },
      ),
    );
  }
}