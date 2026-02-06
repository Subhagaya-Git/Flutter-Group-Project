import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_project/models/product.dart';

class FavouriteService {
  final _supabase = Supabase.instance.client;

  // Add product to favourites
  Future<void> addFavourite(String userEmail, String productId) async {
    try {
      print('Adding to favourites - Email: $userEmail, ProductID: $productId');
      
      // Check if already exists
      final existing = await _supabase
          .from('favourites')
          .select()
          .eq('user_email', userEmail)
          .eq('product_id', productId);

      print('Existing favourites: $existing');

      if (existing.isEmpty) {
        final result = await _supabase.from('favourites').insert({
          'user_email': userEmail,
          'product_id': productId,
          'created_at': DateTime.now().toIso8601String(),
        }).select();
        
        print('Favourite added successfully: $result');
      } else {
        print('Product already in favourites');
      }
    } catch (e) {
      print('Error adding favourite: $e');
      throw Exception('Failed to add favourite: $e');
    }
  }

  // Remove product from favourites
  Future<void> removeFavourite(String userEmail, String productId) async {
    try {
      print('Removing from favourites - Email: $userEmail, ProductID: $productId');
      
      await _supabase
          .from('favourites')
          .delete()
          .eq('user_email', userEmail)
          .eq('product_id', productId);
      
      print('Favourite removed successfully');
    } catch (e) {
      print('Error removing favourite: $e');
      throw Exception('Failed to remove favourite: $e');
    }
  }

  // Check if product is in favourites
  Future<bool> isFavourite(String userEmail, String productId) async {
    try {
      print('Checking favourite - Email: $userEmail, ProductID: $productId');
      
      final result = await _supabase
          .from('favourites')
          .select()
          .eq('user_email', userEmail)
          .eq('product_id', productId);

      print('Is favourite result: ${result.isNotEmpty}');
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking favourite: $e');
      return false;
    }
  }

  // Get all favourite products with full details as stream
  Stream<List<Product>> getFavouriteProducts(String userEmail) {
    print('Getting favourite products stream for: $userEmail');
    
    return _supabase
        .from('favourites')
        .stream(primaryKey: ['id'])
        .eq('user_email', userEmail)
        .order('created_at', ascending: false)
        .asyncMap((favourites) async {
          print('Favourites stream data: ${favourites.length} items');
          
          if (favourites.isEmpty) return <Product>[];

          // Get product IDs
          final productIds = favourites
              .map((fav) => fav['product_id']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList();

          print('Product IDs: $productIds');

          if (productIds.isEmpty) return <Product>[];

          // Fetch full product details
          final products = await _supabase
              .from('products')
              .select()
              .inFilter('id', productIds);

          print('Products fetched: ${products.length}');

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