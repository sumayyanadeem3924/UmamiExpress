class FoodItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  FoodItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory FoodItemModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return FoodItemModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}