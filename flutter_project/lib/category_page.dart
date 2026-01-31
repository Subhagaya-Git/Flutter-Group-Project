import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<Map<String, dynamic>> _categories = [
    {
      "id": 1,
      "name": "iPhones",
      "icon": "📱",
      "description": "Latest Smartphones",
      "productCount": 24,
      "color": const Color(0xFF007AFF),
      "bgColor": const Color(0xFFE8F4FF),
      "products": [
        {
          "title": "iPhone 15 Pro Max",
          "price": "\$1199.99",
          "image": "📱",
          "rating": 4.9,
          "reviews": 450
        },
        {
          "title": "iPhone 15 Pro",
          "price": "\$999.99",
          "image": "📱",
          "rating": 4.8,
          "reviews": 320
        },
        {
          "title": "iPhone 15",
          "price": "\$799.99",
          "image": "📱",
          "rating": 4.7,
          "reviews": 280
        },
        {
          "title": "iPhone 14",
          "price": "\$699.99",
          "image": "📱",
          "rating": 4.6,
          "reviews": 210
        },
      ],
    },
    {
      "id": 2,
      "name": "MacBooks",
      "icon": "💻",
      "description": "Powerful Laptops",
      "productCount": 12,
      "color": const Color(0xFF555555),
      "bgColor": const Color(0xFFF5F5F5),
      "products": [
        {
          "title": "MacBook Pro 16\"",
          "price": "\$2499.99",
          "image": "💻",
          "rating": 4.9,
          "reviews": 380
        },
        {
          "title": "MacBook Pro 14\"",
          "price": "\$1999.99",
          "image": "💻",
          "rating": 4.8,
          "reviews": 320
        },
        {
          "title": "MacBook Air M2",
          "price": "\$1299.99",
          "image": "💻",
          "rating": 4.7,
          "reviews": 290
        },
        {
          "title": "MacBook Air M1",
          "price": "\$999.99",
          "image": "💻",
          "rating": 4.6,
          "reviews": 250
        },
      ],
    },
    {
      "id": 3,
      "name": "iPads",
      "icon": "📱",
      "description": "Premium Tablets",
      "productCount": 18,
      "color": const Color(0xFFFF9500),
      "bgColor": const Color(0xFFFFF3E0),
      "products": [
        {
          "title": "iPad Pro 12.9\"",
          "price": "\$1099.99",
          "image": "📱",
          "rating": 4.9,
          "reviews": 400
        },
        {
          "title": "iPad Pro 11\"",
          "price": "\$899.99",
          "image": "📱",
          "rating": 4.8,
          "reviews": 350
        },
        {
          "title": "iPad Air",
          "price": "\$599.99",
          "image": "📱",
          "rating": 4.7,
          "reviews": 300
        },
        {
          "title": "iPad Mini",
          "price": "\$499.99",
          "image": "📱",
          "rating": 4.6,
          "reviews": 270
        },
      ],
    },
    {
      "id": 4,
      "name": "Accessories",
      "icon": "🎧",
      "description": "Premium Add-ons",
      "productCount": 42,
      "color": const Color(0xFFAF52DE),
      "bgColor": const Color(0xFFF3E5F5),
      "products": [
        {
          "title": "AirPods Pro",
          "price": "\$249.99",
          "image": "🎧",
          "rating": 4.8,
          "reviews": 320
        },
        {
          "title": "AirPods Max",
          "price": "\$549.99",
          "image": "🎧",
          "rating": 4.9,
          "reviews": 280
        },
        {
          "title": "Apple Watch Series 9",
          "price": "\$399.99",
          "image": "⌚",
          "rating": 4.7,
          "reviews": 290
        },
        {
          "title": "Magic Keyboard",
          "price": "\$199.99",
          "image": "⌨️",
          "rating": 4.6,
          "reviews": 180
        },
      ],
    },
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore all of our collections!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Material(
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.black.withOpacity(0.4),
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Categories List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildCategoryCard(_categories[index]),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Material(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          _showCategoryProducts(category);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                (category["bgColor"] as Color),
                (category["bgColor"] as Color).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Background Decorative Elements
              Positioned(
                right: -30,
                top: -30,
                child: Opacity(
                  opacity: 0.1,
                  child: Text(
                    category["icon"],
                    style: const TextStyle(fontSize: 120),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category Name and Icon
                    Row(
                      children: [
                        Text(
                          category["icon"],
                          style: const TextStyle(fontSize: 36),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category["name"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              category["description"],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Bottom Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${category["productCount"]} products',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: (category["color"] as Color),
                            letterSpacing: 0.2,
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: (category["color"] as Color),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.white,
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
    );
  }

  void _showCategoryProducts(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildProductsSheet(category);
      },
    );
  }

  Widget _buildProductsSheet(Map<String, dynamic> category) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (category["bgColor"] as Color),
                  (category["bgColor"] as Color).withOpacity(0.5),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category["icon"],
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          category["name"],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category["description"],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Products List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: category["products"].length,
              itemBuilder: (context, index) {
                final product = category["products"][index];
                return _buildProductItem(product, category["color"]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product, Color categoryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Material(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${product["title"]} added to cart!',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        categoryColor.withOpacity(0.15),
                        categoryColor.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product["image"],
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product["title"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.amber[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${product["rating"]}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(${product["reviews"]})",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Price and Action
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product["price"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
