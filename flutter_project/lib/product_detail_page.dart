import 'package:flutter/material.dart';
import 'package:flutter_project/models/product.dart';
import 'package:flutter_project/services/favourite_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final String userEmail;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.userEmail,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _isFavourite = false;
  final FavouriteService _favouriteService = FavouriteService();

  @override
  void initState() {
    super.initState();
    _checkIfFavourite();
  }

  Future<void> _checkIfFavourite() async {
    final isFav = await _favouriteService.isFavourite(
      widget.userEmail,
      widget.product.id,
    );
    setState(() => _isFavourite = isFav);
  }

  Future<void> _toggleFavourite() async {
    try {
      if (_isFavourite) {
        await _favouriteService.removeFavourite(
          widget.userEmail,
          widget.product.id,
        );
      } else {
        await _favouriteService.addFavourite(
          widget.userEmail,
          widget.product.id,
        );
      }
      setState(() => _isFavourite = !_isFavourite);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavourite 
                ? 'Added to favourites' 
                : 'Removed from favourites'
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavourite ? Icons.favorite : Icons.favorite_border,
              color: _isFavourite ? Colors.red : Colors.black,
            ),
            onPressed: _toggleFavourite,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 300,
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.headphones,
                        size: 150,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand
                        Text(
                          widget.product.brand,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Product Name
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Rating
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.product.rating}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${widget.product.reviewCount} reviews)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          'Description',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Colors
                        if (widget.product.colors.isNotEmpty) ...[
                          const Text(
                            'Available Colors',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            children: widget.product.colors.map((color) {
                              return Chip(
                                label: Text(color),
                                backgroundColor: Colors.grey[200],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Stock Status
                        Row(
                          children: [
                            Icon(
                              widget.product.inStock 
                                  ? Icons.check_circle 
                                  : Icons.cancel,
                              color: widget.product.inStock 
                                  ? Colors.green 
                                  : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.product.inStock 
                                  ? 'In Stock (${widget.product.stockQuantity})' 
                                  : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.product.inStock 
                                    ? Colors.green 
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Quantity Controls
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() => _quantity--);
                          }
                        },
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (_quantity < widget.product.stockQuantity) {
                            setState(() => _quantity++);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Price and Add to Cart
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.product.inStock
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added $_quantity ${widget.product.name} to cart'
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}