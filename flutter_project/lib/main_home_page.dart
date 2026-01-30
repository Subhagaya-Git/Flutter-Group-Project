import 'package:flutter/material.dart';
import 'favourite_page.dart'; // Import your favorites page

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;

  // List of pages for BottomNavigationBar
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(), // Home Page
      _buildShopPage(), // Shop Page Placeholder
      const FavouritePage(), // Favorites Page
      _buildProfilePage(), // Profile Page Placeholder
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ============================
  // Home Page Content
  // ============================
  Widget _buildHomeContent() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'AppleMart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('Search here',
                      style: TextStyle(color: Colors.grey)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_none, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Choose brand section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose brand',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Brand Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBrandIcon('Beats', Icons.headphones),
                _buildBrandIcon('Sennheiser', Icons.headset),
                _buildBrandIcon('JBL', Icons.speaker),
                _buildBrandIcon('Sony', Icons.speaker_group),
              ],
            ),
            const SizedBox(height: 20),

            // Category Tabs
            Row(
              children: [
                _buildCategoryTab('Popular', true),
                const SizedBox(width: 12),
                _buildCategoryTab('Discount', false),
                const SizedBox(width: 12),
                _buildCategoryTab('Exclusive', false),
              ],
            ),
            const SizedBox(height: 20),

            // Product Cards - Row 1
            Row(
              children: [
                Expanded(
                  child: _buildProductCard(
                    'Noise Cancelling Headphones',
                    '\$249.95',
                    Colors.grey[300]!,
                    true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProductCard(
                    'Classic All-Day Headphones',
                    '\$289.95',
                    Colors.pink[50]!,
                    false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product Cards - Row 2
            Row(
              children: [
                Expanded(
                  child: _buildProductCard(
                    'Premium Headphones',
                    '\$199.95',
                    Colors.pink[50]!,
                    false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProductCard(
                    'Wireless Speakers',
                    '\$159.95',
                    Colors.grey[300]!,
                    true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // Shop Page Placeholder
  // ============================
  Widget _buildShopPage() {
    return const Center(
      child: Text('Shop Page Coming Soon'),
    );
  }

  // ============================
  // Profile Page Placeholder
  // ============================
  Widget _buildProfilePage() {
    return const Center(
      child: Text('Profile Page Coming Soon'),
    );
  }

  // ============================
  // Reusable Widgets
  // ============================
  Widget _buildBrandIcon(String name, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProductCard(
      String title, String price, Color bgColor, bool showBadge) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(Icons.headphones,
                          size: 80, color: Colors.grey[600]),
                    ),
                  ),
                  if (showBadge)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
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
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(price,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
