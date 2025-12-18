// auth/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStateAndOnboarding();
  }

  void _checkAuthStateAndOnboarding() async {
    // Simulate a network/loading delay for a better user experience
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // A simple flag to determine if Onboarding should be shown.
    // In a real app, this would be read from SharedPreferences/Hive
    const bool shouldShowOnboarding = true; // Set to false after first launch

    if (shouldShowOnboarding) {
      // Navigate to Onboarding, then Onboarding will handle the next step
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      // Check Firebase Auth state
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Not logged in, go to Login
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        // Logged in, go to Home
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for your App Logo
            Icon(Icons.restaurant_menu, size: 80, color: Colors.indigo),
            SizedBox(height: 20),
            Text(
              'UMAMI EXPRESS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}