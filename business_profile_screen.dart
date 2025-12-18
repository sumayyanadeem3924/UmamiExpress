import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BusinessProfileScreen extends StatelessWidget {
  const BusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final DatabaseReference _ref = FirebaseDatabase.instance
        .refFromURL("https://umami-express-default-rtdb.firebaseio.com")
        .child('restaurants').child(uid);

    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Profile")),
      body: FutureBuilder(
        future: _ref.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.value as Map<dynamic, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, child: Icon(Icons.store, size: 50)),
                const SizedBox(height: 20),
                Text(data['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(data['cuisine'], style: const TextStyle(color: Colors.grey)),
                const Divider(height: 40),
                ListTile(leading: const Icon(Icons.location_on), title: Text(data['address'])),
                ListTile(leading: const Icon(Icons.star), title: Text("Rating: ${data['rating']}")),
                const Spacer(),
                ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: const Text("Logout"))
              ],
            ),
          );
        },
      ),
    );
  }
}