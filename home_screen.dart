// lib/screens/customer/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cart_screen.dart';
import 'menu_screen.dart';
import 'category_detail_screen.dart';

// --- DATA MODELS ---

class FoodItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  FoodItem({required this.name, required this.description, required this.price, required this.imageUrl});

  factory FoodItem.fromMap(Map<dynamic, dynamic> map) {
    return FoodItem(
      name: map['name'] ?? 'Dish',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? 'assets/food_placeholder.jpg',
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final String imageUrl;
  final List<FoodItem> menu;

  Restaurant({required this.id, required this.name, required this.cuisine, required this.rating, required this.imageUrl, required this.menu});

  factory Restaurant.fromMap(String id, Map<dynamic, dynamic> map) {
    var menuList = <FoodItem>[];
    if (map['menu'] != null) {
      Map<dynamic, dynamic> menuData = map['menu'];
      menuData.forEach((key, value) {
        menuList.add(FoodItem.fromMap(value));
      });
    }
    return Restaurant(
      id: id,
      name: map['name'] ?? 'Restaurant',
      cuisine: map['cuisine'] ?? 'Cuisine',
      rating: (map['rating'] ?? 5.0).toDouble(),
      imageUrl: map['imageUrl'] ?? 'assets/placeholder_restaurant.jpg',
      menu: menuList,
    );
  }
}

class Category {
  final String name;
  final IconData icon;
  Category(this.name, this.icon);
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({this.id = '', required this.name, required this.price, this.quantity = 1});

  // ⭐️ FIXED: Added back for CartScreen compatibility
  factory CartItem.fromMap(Map<dynamic, dynamic> map, String id) {
    return CartItem(
      id: id,
      name: map['name'] ?? 'Unknown Item',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 1).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'quantity': quantity};
  }
}

// --- Home Screen ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Category> _categories = [
    Category('Pizza', Icons.local_pizza),
    Category('Burgers', Icons.lunch_dining),
    Category('Sushi', Icons.rice_bowl),
    Category('Desserts', Icons.cake),
    Category('Drinks', Icons.local_cafe),
    Category('Indian', Icons.ramen_dining),
  ];

  final DatabaseReference _dbRef = FirebaseDatabase.instance.refFromURL("https://umami-express-default-rtdb.firebaseio.com");
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  void addToCart(CartItem item) async {
    if (_uid == null) return;
    final cartPath = 'users/$_uid/cart';
    try {
      final snapshot = await _dbRef.child(cartPath).orderByChild('name').equalTo(item.name).limitToFirst(1).get();
      if (snapshot.exists && snapshot.children.isNotEmpty) {
        final existingItemSnapshot = snapshot.children.first;
        final existingItemMap = existingItemSnapshot.value as Map<dynamic, dynamic>;
        int currentQuantity = (existingItemMap['quantity'] as num).toInt();
        await existingItemSnapshot.ref.update({'quantity': currentQuantity + 1});
      } else {
        await _dbRef.child(cartPath).push().set(item.toMap());
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${item.name} added to cart!'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.indigo,
        ));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference cartRef = _dbRef.child('users/$_uid/cart');
    final DatabaseReference userRef = _dbRef.child('users/$_uid');
    final DatabaseReference restaurantsRef = _dbRef.child('restaurants');

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DatabaseEvent>(
          stream: userRef.child('address').onValue,
          builder: (context, snapshot) {
            String address = "Detecting location...";
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              address = snapshot.data!.snapshot.value.toString();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Deliver to:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text(address, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
              ],
            );
          },
        ),
        actions: [
          StreamBuilder<DatabaseEvent>(
            stream: cartRef.onValue,
            builder: (context, snapshot) {
              int totalItemCount = 0;
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                final Map<dynamic, dynamic> items = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                items.forEach((key, value) => totalItemCount += (value['quantity'] as num? ?? 0).toInt());
              }
              return IconButton(
                icon: Badge(
                    label: Text('$totalItemCount'),
                    isLabelVisible: totalItemCount > 0,
                    child: const Icon(Icons.shopping_bag_outlined)
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen())),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants or food...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: StreamBuilder<DatabaseEvent>(
                  stream: userRef.child('username').onValue,
                  builder: (context, snapshot) {
                    String name = "Guest";
                    if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                      name = snapshot.data!.snapshot.value.toString();
                    }
                    return Text(
                      'Hey $name, hungry?',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
                child: Text('Top Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) => CategoryCard(category: _categories[index], onTap: () {}),
                ),
              ),
              const Divider(height: 30, thickness: 1),
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                child: Text('All Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              // ⭐️ LIVE FIREBASE RESTAURANT STREAM
              StreamBuilder<DatabaseEvent>(
                stream: restaurantsRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                  }

                  if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                    return const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: Text("No restaurants found in your area.")),
                    );
                  }

                  Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<Restaurant> restaurantList = [];

                  data.forEach((key, value) {
                    restaurantList.add(Restaurant.fromMap(key, value));
                  });

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: restaurantList.length,
                    itemBuilder: (context, index) => RestaurantCard(
                        restaurant: restaurantList[index],
                        addToCartCallback: addToCart
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SUPPORTING WIDGETS ---

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(15)), child: Icon(category.icon, size: 30, color: Colors.indigo)),
            const SizedBox(height: 5),
            Text(category.name, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final void Function(CartItem item) addToCartCallback;
  const RestaurantCard({super.key, required this.restaurant, required this.addToCartCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen(restaurantName: restaurant.name, menu: restaurant.menu, addToCartCallback: addToCartCallback))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: restaurant.imageUrl.startsWith('assets/')
                    ? Image.asset(restaurant.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.store, size: 50))
                    : Image.network(restaurant.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.store, size: 50)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(restaurant.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('${restaurant.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(restaurant.cuisine, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}