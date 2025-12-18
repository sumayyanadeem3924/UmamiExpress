class UserModel {
  final String uid;
  final String username;
  final String email;
  final String address;
  final String role;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.address,
    this.role = 'customer',
  });

  // Convert Object to JSON for saving to Firebase
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'address': address,
      'role': role,
    };
  }

  // Create Object from Firebase JSON
  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? 'customer',
    );
  }
}