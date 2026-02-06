import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_project/models/product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': product.id,
      'product_name': product.name,
      'product_price': product.price,
      'product_brand': product.brand,
      'product_image': product.images.isNotEmpty ? product.images[0] : '',
      'quantity': quantity,
    };
  }
}

class CartService {
  final _supabase = Supabase.instance.client;

  // Add item to cart
  Future<void> addToCart(String userEmail, Product product, int quantity) async {
    try {
      print('Adding to cart - Email: $userEmail, Product: ${product.name}, Qty: $quantity');
      
      // Check if item already exists
      final existingItems = await _supabase
          .from('cart')
          .select()
          .eq('user_email', userEmail)
          .eq('product_id', product.id);

      print('Existing cart items: $existingItems');

      if (existingItems.isNotEmpty) {
        // Update quantity
        final currentQuantity = existingItems[0]['quantity'] ?? 0;
        final newQuantity = currentQuantity + quantity;
        
        print('Updating quantity to: $newQuantity');
        
        final result = await _supabase
            .from('cart')
            .update({
              'quantity': newQuantity,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existingItems[0]['id'])
            .select();
        
        print('Cart updated: $result');
      } else {
        // Insert new item
        print('Inserting new cart item');
        
        final result = await _supabase.from('cart').insert({
          'user_email': userEmail,
          'product_id': product.id,
          'product_name': product.name,
          'product_price': product.price,
          'product_brand': product.brand,
          'product_image': product.images.isNotEmpty ? product.images[0] : '',
          'quantity': quantity,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }).select();
        
        print('Cart item added: $result');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      throw Exception('Failed to add to cart: $e');
    }
  }

  // Get cart items as stream with realtime updates
  Stream<List<CartItem>> getCartItems(String userEmail) {
    print('Getting cart items stream for: $userEmail');
    
    return _supabase
        .from('cart')
        .stream(primaryKey: ['id'])
        .eq('user_email', userEmail)
        .order('created_at', ascending: false)
        .map((data) {
          print('Cart stream data: ${data.length} items');
          
          return data.map((item) {
            final product = Product(
              id: item['product_id']?.toString() ?? '',
              name: item['product_name']?.toString() ?? 'Unknown Product',
              brand: item['product_brand']?.toString() ?? '',
              description: '',
              price: (item['product_price'] ?? 0).toDouble(),
              category: 'General',
              rating: 0.0,
              reviewCount: 0,
              images: item['product_image'] != null && item['product_image'].toString().isNotEmpty
                  ? [item['product_image'].toString()]
                  : [],
              colors: [],
              inStock: true,
              stockQuantity: 999,
              createdAt: DateTime.now(),
              discountPercentage: null,
            );

            return CartItem(
              id: item['id'].toString(),
              product: product,
              quantity: item['quantity'] ?? 1,
            );
          }).toList();
        });
  }

  // Get cart count as stream with realtime updates
  Stream<int> getCartCount(String userEmail) {
    return _supabase
        .from('cart')
        .stream(primaryKey: ['id'])
        .eq('user_email', userEmail)
        .map((data) {
          return data.fold<int>(0, (sum, item) {
            final quantity = item['quantity'];
            if (quantity is int) {
              return sum + quantity;
            } else if (quantity is double) {
              return sum + quantity.toInt();
            } else if (quantity is String) {
              return sum + (int.tryParse(quantity) ?? 0);
            }
            return sum;
          });
        });
  }

  // Remove item from cart
  Future<void> removeFromCart(String userEmail, String cartItemId) async {
    try {
      await _supabase
          .from('cart')
          .delete()
          .eq('id', cartItemId)
          .eq('user_email', userEmail);
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  // Update cart item quantity
  Future<void> updateQuantity(String userEmail, String cartItemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(userEmail, cartItemId);
      } else {
        await _supabase
            .from('cart')
            .update({
              'quantity': newQuantity,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', cartItemId)
            .eq('user_email', userEmail);
      }
    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }

  // Clear entire cart
  Future<void> clearCart(String userEmail) async {
    try {
      await _supabase
          .from('cart')
          .delete()
          .eq('user_email', userEmail);
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  // Calculate totals
  double calculateTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  double calculateTax(List<CartItem> items, {double taxRate = 0.15}) {
    return calculateTotal(items) * taxRate;
  }

  double calculateGrandTotal(List<CartItem> items, {double shipping = 20.0, double taxRate = 0.15}) {
    return calculateTotal(items) + shipping + calculateTax(items, taxRate: taxRate);
  }
}