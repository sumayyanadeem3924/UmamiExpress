import 'package:flutter/material.dart';

// Import necessary files
import 'food_detail_screen.dart';
import 'home_screen.dart'; // To access the FoodItem and CartItem models

class MenuScreen extends StatelessWidget {
  final String restaurantName;
  final List<FoodItem> menu; // NEW: Specific menu for this restaurant
  final void Function(CartItem item) addToCartCallback;

  const MenuScreen({
    super.key,
    required this.restaurantName,
    required this.menu,
    required this.addToCartCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName), // Display specific restaurant name
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final item = menu[index];
          // Pass the specific FoodItem data
          return _buildMenuItem(context, item, addToCartCallback);
        },
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      FoodItem item,
      void Function(CartItem) addToCartCallback,
      ) {
    return ListTile(
      leading: SizedBox(
        width: 60,
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            item.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.indigo),
          ),
        ),
      ),
      title: Text(item.name),
      subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
          '\$${item.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold)
      ),
      onTap: () {
        // Navigate to the FoodDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(
              foodName: item.name,
              defaultPrice: item.price,
              description: item.description, // Pass description
              imageUrl: item.imageUrl,       // Pass image URL
              addToCartCallback: addToCartCallback,
            ),
          ),
        );
      },
    );
  }
}