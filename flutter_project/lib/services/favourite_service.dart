import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_project/models/product.dart';

class FavouriteService {
  final _supabase = Supabase.instance.client;

  // Add product to favourites
  Future<void> addFavourite(String userEmail, String productId) async {
    try {
      // Check if already exists
      final existing = await _supabase
          .from('favourites')
          .select()
          .eq('user_email', userEmail)
          .eq('product_id', productId);

      if (existing.isEmpty) {
        await _supabase.from('favourites').insert({
          'user_email': userEmail,
          'product_id': productId,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw Exception('Failed to add favourite: $e');
    }
  }

  // Remove product from favourites
  Future<void> removeFavourite(String userEmail, String productId) async {
    try {
      await _supabase
          .from('favourites')
          .delete()
          .eq('user_email', userEmail)
          .eq('product_id', productId);
    } catch (e) {
      throw Exception('Failed to remove favourite: $e');
    }
  }

  // Check if product is in favourites
  Future<bool> isFavourite(String userEmail, String productId) async {
    try {
      final result = await _supabase
          .from('favourites')
          .select()
          .eq('user_email', userEmail)
          .eq('product_id', productId);

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get all favourite products with full details as stream
  Stream<List<Product>> getFavouriteProducts(String userEmail) {
    return _supabase
        .from('favourites')
        .stream(primaryKey: ['id'])
        .eq('user_email', userEmail)
        .order('created_at', ascending: false)
        .asyncMap((favourites) async {
          if (favourites.isEmpty) return <Product>[];

          // Get product IDs
          final productIds = favourites
              .map((fav) => fav['product_id']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList();

          if (productIds.isEmpty) return <Product>[];

          // Fetch full product details
          final products = await _supabase
              .from('products')
              .select()
              .inFilter('id', productIds);

          return products.map((data) {
            return Product(
              id: data['id']?.toString() ?? '',
              name: data['name']?.toString() ?? 'Unknown Product',
              brand: data['brand']?.toString() ?? '',
              description: data['description']?.toString() ?? '',
              price: (data['price'] ?? 0).toDouble(),
              category: data['category']?.toString() ?? 'General',
              rating: (data['rating'] ?? 0).toDouble(),
              reviewCount: data['review_count'] ?? 0,
              images: data['images'] is List
                  ? List<String>.from(data['images'])
                  : [],
              colors: data['colors'] is List
                  ? List<String>.from(data['colors'])
                  : [],
              inStock: data['in_stock'] ?? true,
              stockQuantity: data['stock_quantity'] ?? 0,
              createdAt: data['created_at'] != null
                  ? DateTime.parse(data['created_at'])
                  : DateTime.now(),
              discountPercentage: data['discount_percentage']?.toDouble(),
            );
          }).toList();
        });
  }

  // Get favourite count
  Stream<int> getFavouriteCount(String userEmail) {
    return _supabase
        .from('favourites')
        .stream(primaryKey: ['id'])
        .eq('user_email', userEmail)
        .map((data) => data.length);
  }

  // Clear all favourites
  Future<void> clearAllFavourites(String userEmail) async {
    try {
      await _supabase
          .from('favourites')
          .delete()
          .eq('user_email', userEmail);
    } catch (e) {
      throw Exception('Failed to clear favourites: $e');
    }
  }
}