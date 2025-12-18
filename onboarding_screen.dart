// lib/screens/auth/onboarding_screen.dart

import 'package:flutter/material.dart';
import '../../services/local_storage.dart'; // Import the service

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final LocalStorage _storage = LocalStorage(); // Initialize storage
  bool isLastPage = false;

  // Helper function to handle role selection and state saving
  void _finishOnboarding(String route) async {
    // 1. Mark onboarding as complete in local storage
    await _storage.setFirstTime(false);

    // 2. Navigate to the selected signup screen
    if (mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            _buildPage(
              icon: Icons.delivery_dining,
              title: 'Fast Delivery',
              subtitle: 'Your favorite meals delivered fresh to your doorstep.',
            ),
            _buildPage(
              icon: Icons.restaurant,
              title: 'Top Quality',
              subtitle: 'The best local restaurants at your fingertips.',
            ),
            _buildPage(
              icon: Icons.people_alt,
              title: 'Join Umami Express',
              subtitle: 'Choose how you want to get started with us.',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 180,
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => _finishOnboarding('/signup'),
              child: const Text('I want to Order Food'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Colors.indigo),
              ),
              onPressed: () => _finishOnboarding('/business_signup'),
              child: const Text('I want to Sell Food (Business)'),
            ),
          ],
        ),
      )
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => _controller.jumpToPage(2),
              child: const Text('SKIP'),
            ),
            TextButton(
              onPressed: () => _controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
              child: const Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required IconData icon, required String title, required String subtitle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 100, color: Colors.indigo),
        const SizedBox(height: 40),
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo)),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ),
      ],
    );
  }
}