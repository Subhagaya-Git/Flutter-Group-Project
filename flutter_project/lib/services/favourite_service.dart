import 'package:supabase_flutter/supabase_flutter.dart';

class FavouriteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addFavourite(String userEmail, String productId) async {
    await _supabase.from('favourites').insert({
      'user_email': userEmail,
      'product_id': productId,
    });
  }

  Future<void> removeFavourite(String userEmail, String productId) async {
    await _supabase
        .from('favourites')
        .delete()
        .eq('user_email', userEmail)
        .eq('product_id', productId);
  }

  Future<bool> isFavourite(String userEmail, String productId) async {
    final response = await _supabase
        .from('favourites')
        .select()
        .eq('user_email', userEmail)
        .eq('product_id', productId)
        .maybeSingle();
    
    return response != null;
  }

  Future<List<String>> getFavouriteIds(String userEmail) async {
    final response = await _supabase
        .from('favourites')
        .select('product_id')
        .eq('user_email', userEmail);
    
    return (response as List)
        .map((item) => item['product_id'] as String)
        .toList();
  }
}