class Product {
  final String id;
  final String name;
  final List<dynamic> imageUrl;
  final double price;
  final double discountPercentage;
  final String brand;
  final String description;
  final String category;
  final List<dynamic> reviews;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discountPercentage,
    required this.brand,
    required this.description,
    required this.category,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '', 
      name: json['title'] ?? '', 
      imageUrl: json['images'] ?? [], 
      price: json['price']?.toDouble() ?? 0.0, 
      discountPercentage: json['discountPercentage']?.toDouble() ?? 0.0,
      category: json['category'] ?? '', 
      brand: json['brand'] ?? '', 
      description: json['description'] ?? '', 
      reviews: json['reviews'] ?? [], 
    );
  }
}
