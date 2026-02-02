import 'package:flutter/material.dart';
import 'main_home_page.dart';

class FavouritePage extends StatefulWidget {
  final String userEmail;

  const FavouritePage({super.key, required this.userEmail});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  // Sample favorite products
  final List<Map<String, dynamic>> _favorites = [
    {
      "title": "Noise Cancelling Headphones",
      "price": "\$249.95",
      "color": Colors.grey[300],
      "isHot": true,
      "rating": 4.5,
      "reviews": 120
    },
    {
      "title": "Premium Headphones",
      "price": "\$199.95",
      "color": Colors.pink[50],
      "isHot": false,
      "rating": 4.2,
      "reviews": 95
    },
    {
      "title": "Wireless Speakers",
      "price": "\$159.95",
      "color": Colors.grey[300],
      "isHot": false,
      "rating": 4.0,
      "reviews": 80
    },
    {
      "title": "Classic All-Day Headphones",
      "price": "\$289.95",
      "color": Colors.pink[50],
      "isHot": true,
      "rating": 4.8,
      "reviews": 150
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainHomePage(
                  userEmail: widget.userEmail, 
                ),
              ),
            );
          },
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _favorites.length,
          itemBuilder: (context, index) {
            final item = _favorites[index];
            return Dismissible(
              key: Key(item["title"]),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                setState(() {
                  _favorites.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${item["title"]} removed from favorites"),
                  ),
                );
              },
              child: _buildFavoriteCard(
                title: item["title"],
                price: item["price"],
                imageColor: item["color"],
                isHot: item["isHot"],
                rating: item["rating"],
                reviews: item["reviews"],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteCard({
    required String title,
    required String price,
    required Color imageColor,
    bool isHot = false,
    double rating = 0.0,
    int reviews = 0,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image + HOT badge
            Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: imageColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.headphones, size: 40, color: Colors.grey),
                  ),
                ),
                if (isHot)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'HOT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[600], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "$rating ($reviews reviews)",
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite / Remove Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  // TODO: remove from favorites
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
