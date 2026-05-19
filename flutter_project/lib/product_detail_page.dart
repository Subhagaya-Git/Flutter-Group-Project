import 'package:flutter/material.dart';
import 'package:flutter_project/cart_page.dart';
import 'package:flutter_project/models/product.dart';
import 'package:flutter_project/services/favourite_service.dart';
import 'package:flutter_project/services/cart_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_project/services/currency_service.dart';

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
  int _currentImageIndex = 0;
  bool _isAddingToCart = false;
  final FavouriteService _favouriteService = FavouriteService();
  final CartService _cartService = CartService();

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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFavourite
                ? 'Added to favourites'
                : 'Removed from favourites'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart) return;

    setState(() => _isAddingToCart = true);

    try {
      await _cartService.addToCart(
        widget.userEmail,
        widget.product,
        _quantity,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item added to the cart'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          StreamBuilder<int>(
            stream: _cartService.getCartCount(widget.userEmail),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart,
                          color: colorScheme.onSurface),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CartPage(userEmail: widget.userEmail),
                          ),
                        );
                      },
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ).animate().scale(),
                ],
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isFavourite ? Icons.favorite : Icons.favorite_border,
                color: _isFavourite ? colorScheme.error : colorScheme.onSurface,
              ),
              onPressed: _toggleFavourite,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Image Carousel
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surface : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: widget.product.images.isEmpty
                ? Center(
                    child: Icon(Icons.image,
                        size: 100, color: colorScheme.onSurface.withOpacity(0.2)),
                  )
                : Stack(
                    children: [
                      PageView.builder(
                        itemCount: widget.product.images.length,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return Hero(
                            tag: 'product-${widget.product.id}',
                            child: CachedNetworkImage(
                              imageUrl: widget.product.images[index],
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: colorScheme.onSurface.withOpacity(0.2)),
                            ),
                          ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9));
                        },
                      ),
                      if (widget.product.images.length > 1)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.product.images.asMap().entries.map((entry) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentImageIndex == entry.key
                                      ? colorScheme.primary
                                      : colorScheme.primary.withOpacity(0.2),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
          ),

          // Product Info
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.brand.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: colorScheme.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.product.rating}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.name,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
                    const SizedBox(height: 8),
                    Text(
                      '(${widget.product.reviewCount} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onBackground.withOpacity(0.5),
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onBackground.withOpacity(0.7),
                        height: 1.6,
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 24),
                    if (widget.product.colors.isNotEmpty) ...[
                      const Text(
                        'Available Colors',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(delay: 700.ms),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: widget.product.colors.map((color) {
                          return Chip(
                            label: Text(color),
                            backgroundColor: colorScheme.surface,
                            side: BorderSide(
                                color: colorScheme.outline.withOpacity(0.2)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        }).toList(),
                      ).animate().fadeIn(delay: 800.ms),
                      const SizedBox(height: 24),
                    ],
                    Row(
                      children: [
                        Icon(
                          widget.product.inStock
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: widget.product.inStock
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.product.inStock
                              ? 'Highly In Stock'
                              : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.product.inStock
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 900.ms),
                    const SizedBox(height: 80), // Padding for bottom bar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Integrated Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
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
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      (widget.product.inStock && !_isAddingToCart)
                          ? _addToCart
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    elevation: 4,
                    shadowColor: colorScheme.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: _isAddingToCart
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Add to Cart • ${CurrencyService.formatPrice(context, widget.product.price * _quantity)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5),
    );
  }
}
