// lib/screens/orders/rate_review_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RateReviewScreen extends StatefulWidget {
  const RateReviewScreen({super.key});

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> {
  final _commentController = TextEditingController();
  double _rating = 5.0; // Default rating
  bool _isSubmitting = false;

  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL("https://umami-express-default-rtdb.firebaseio.com");

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview(Map<dynamic, dynamic> orderData) async {
    setState(() => _isSubmitting = true);

    try {
      // 1. Save the review to the restaurant's reviews node
      // Note: orderData should contain the 'restaurantId'
      final String restaurantId = orderData['restaurantId'] ?? 'unknown_restaurant';

      await _dbRef.child('restaurants').child(restaurantId).child('reviews').push().set({
        'rating': _rating,
        'comment': _commentController.text.trim(),
        'orderId': orderData['orderId'],
        'timestamp': ServerValue.timestamp,
      });

      // 2. Update the order status to 'Reviewed'
      // You would typically use the user's UID and the order unique key here

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for your feedback!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Receiving order details passed during navigation
    final orderData = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'How was your meal?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Simple Star Rating UI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () => setState(() => _rating = index + 1.0),
                );
              }),
            ),
            Text('Rating: $_rating / 5.0', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 30),

            // Review Text Field
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tell us more about the food and service...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 30),

            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () => _submitReview(orderData),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}