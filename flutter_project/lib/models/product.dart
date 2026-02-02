class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String brand;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final List<String> colors;
  final bool inStock;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.colors,
    required this.inStock,
    required this.stockQuantity,
  });

  // Convert JSON from Supabase to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      colors: json['colors'] != null 
          ? List<String>.from(json['colors']) 
          : [],
      inStock: json['in_stock'] ?? true,
      stockQuantity: json['stock_quantity'] ?? 0,
    );
  }
}