class BusinessModel {
  final String uid;
  final String restaurantName;
  final String ownerEmail;
  final bool isVerified;

  BusinessModel({
    required this.uid,
    required this.restaurantName,
    required this.ownerEmail,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'restaurantName': restaurantName,
      'ownerEmail': ownerEmail,
      'isVerified': isVerified,
      'role': 'business',
    };
  }

  factory BusinessModel.fromJson(Map<dynamic, dynamic> json) {
    return BusinessModel(
      uid: json['uid'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }
}