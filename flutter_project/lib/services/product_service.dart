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
      
      return (response as List)
          .map((json) => Product.fromJson(json))
          .toList();
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
      
      return (response as List)
          .map((json) => Product.fromJson(json))
          .toList();
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
          .limit(10);
      
      print('New Arrivals Response: $response'); // Debug print
      
      return (response as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching new arrivals: $e');
      throw Exception('Failed to load new arrivals: $e');
    }
  }

  Future<List<Product>> getPopularProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .gte('rating', 4.5)
          .order('review_count', ascending: false)
          .limit(10);
      
      print('Popular Products Response: $response'); // Debug print
      
      return (response as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching popular products: $e');
      throw Exception('Failed to load popular products: $e');
    }
  }

  Future<List<Product>> getDiscountProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .not('discount_percentage', 'is', null)
          .order('discount_percentage', ascending: false)
          .limit(10);
      
      print('Discount Products Response: $response'); 
      
      return (response as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching discount products: $e');
      throw Exception('Failed to load discount products: $e');
    }
  }
}