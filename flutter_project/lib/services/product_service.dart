import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .order('created_at', ascending: false);

      print('All Products Response: $response'); // Debug print

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching all products: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      if (query.isEmpty) return getAllProducts();

      final response = await _supabase
          .from('products')
          .select()
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);

      print('Search Results: $response'); // Debug print

      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error searching products: $e');
      throw Exception('Failed to search products: $e');
    }
  }

  Future<List<Product>> getNewArrivals() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .order('created_at', ascending: false)
          .limit(20);

      if (response == null || response.isEmpty) {
        print('No new arrivals found');
        return [];
      }

      print('New arrivals raw count: ${(response as List).length}');

      final products =
          (response as List).map((item) => Product.fromJson(item)).toList();

      // Remove duplicates
      final uniqueProducts = <Product>[];
      final seenIds = <String>{};
      final seenNames = <String>{};

      for (var product in products) {
        if (!seenIds.contains(product.id) &&
            !seenNames.contains(product.name)) {
          seenIds.add(product.id);
          seenNames.add(product.name);
          uniqueProducts.add(product);
        }
      }

      print('New arrivals unique count: ${uniqueProducts.length}');

      return uniqueProducts.take(10).toList();
    } catch (e) {
      print('Error fetching new arrivals: $e');
      return [];
    }
  }

  Future<List<Product>> getPopularProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .order('rating', ascending: false)
          .order('review_count', ascending: false)
          .limit(20); // Get more to filter

      if (response == null || response.isEmpty) {
        print('No popular products found');
        return [];
      }

      print('Popular products raw count: ${(response as List).length}');

      // Convert to Product list
      final products =
          (response as List).map((item) => Product.fromJson(item)).toList();

      // Remove duplicates by ID and name
      final uniqueProducts = <Product>[];
      final seenIds = <String>{};
      final seenNames = <String>{};

      for (var product in products) {
        final key = '${product.id}_${product.name}';
        if (!seenIds.contains(product.id) &&
            !seenNames.contains(product.name)) {
          seenIds.add(product.id);
          seenNames.add(product.name);
          uniqueProducts.add(product);
        }
      }

      print('Popular products unique count: ${uniqueProducts.length}');

      // Return only top 10 unique
      return uniqueProducts.take(10).toList();
    } catch (e) {
      print('Error fetching popular products: $e');
      return [];
    }
  }

  Future<List<Product>> getDiscountProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .not('discount_percentage', 'is', null)
          .gt('discount_percentage', 0)
          .order('discount_percentage', ascending: false)
          .limit(20);

      if (response == null || response.isEmpty) {
        print('No discount products found');
        return [];
      }

      print('Discount products raw count: ${(response as List).length}');

      final products =
          (response as List).map((item) => Product.fromJson(item)).toList();

      // Remove duplicates
      final uniqueProducts = <Product>[];
      final seenIds = <String>{};
      final seenNames = <String>{};

      for (var product in products) {
        if (!seenIds.contains(product.id) &&
            !seenNames.contains(product.name)) {
          seenIds.add(product.id);
          seenNames.add(product.name);
          uniqueProducts.add(product);
        }
      }

      print('Discount products unique count: ${uniqueProducts.length}');

      return uniqueProducts.take(10).toList();
    } catch (e) {
      print('Error fetching discount products: $e');
      return [];
    }
  }

  // Get products by category (returns raw Map for compatibility)
  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category) async {
    try {
      print('Fetching products for category: $category');

      final response = await _supabase
          .from('products')
          .select()
          .eq('category', category)
          .order('name');

      print(
          'Products by category response count: ${(response as List).length}');

      // Remove duplicates based on product id
      final uniqueProducts = <String, Map<String, dynamic>>{};
      for (var product in response as List) {
        final productId = product['id']?.toString();
        if (productId != null && !uniqueProducts.containsKey(productId)) {
          uniqueProducts[productId] = Map<String, dynamic>.from(product);
        }
      }

      final result = uniqueProducts.values.toList();
      print('Unique products count: ${result.length}');

      return result;
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get product by ID (returns raw Map for compatibility)
  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      final response =
          await _supabase.from('products').select().eq('id', id).single();

      return response;
    } catch (e) {
      print('Error fetching product by id: $e');
      return null;
    }
  }

  // Get all unique categories from products table
  Future<List<String>> getCategories() async {
    try {
      print('Fetching categories from Supabase...');

      final response =
          await _supabase.from('products').select('category').order('category');

      print('Categories Response: $response'); // Debug print

      if (response.isEmpty) {
        print('No categories found in database');
        return [];
      }

      // Extract unique categories
      final Set<String> categoriesSet = {};
      for (var item in response as List) {
        if (item['category'] != null &&
            item['category'].toString().isNotEmpty) {
          categoriesSet.add(item['category'].toString());
        }
      }

      final categories = categoriesSet.toList()..sort();
      print('Found ${categories.length} unique categories: $categories');

      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
