// lib/screens/auth/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL("https://umami-express-default-rtdb.firebaseio.com");

  @override
  void dispose() {
    _usernameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Basic validation
    if (_usernameController.text.trim().isEmpty || _addressController.text.trim().isEmpty) {
      setState(() => _errorMessage = "Username and Address are required.");
      return;
    }

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() => _errorMessage = "Passwords do not match.");
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      // 1. Create Auth User
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Save Profile Data to Database
      await _dbRef.child('users').child(userCredential.user!.uid).set({
        'username': _usernameController.text.trim(),
        'address': _addressController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': ServerValue.timestamp,
      });

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = "An unexpected error occurred.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Text('Join UMAMI EXPRESS', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 30),

            // Username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.person)),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Address
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Delivery Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.home)),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.lock)),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.lock_reset)),
            ),
            const SizedBox(height: 24),

            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}