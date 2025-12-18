class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final String cuisine;
  final String imageUrl;
  final double rating;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.cuisine,
    required this.imageUrl,
    this.rating = 5.0,
  });

  factory RestaurantModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return RestaurantModel(
      id: id,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      cuisine: json['cuisine'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
    );
  }
}