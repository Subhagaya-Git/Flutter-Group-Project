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
  final DateTime createdAt;

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
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [],
      rating: json['rating'] != null 
          ? (json['rating'] as num).toDouble() 
          : 0.0,
      reviewCount: json['review_count'] ?? 0,
      colors: json['colors'] != null 
          ? List<String>.from(json['colors']) 
          : [],
      inStock: json['in_stock'] ?? true,
      stockQuantity: json['stock_quantity'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'brand': brand,
      'images': images,
      'rating': rating,
      'review_count': reviewCount,
      'colors': colors,
      'in_stock': inStock,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toIso8601String(),
    };
  }
}