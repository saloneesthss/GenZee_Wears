import 'package:flutter/material.dart';
import 'package:genzee_wears/models/product_model.dart';
import 'package:genzee_wears/services/auth_service.dart';
import 'package:genzee_wears/services/database_helper.dart';
import 'package:genzee_wears/services/favorites_service.dart';
import 'package:genzee_wears/constants/app_routes.dart';
import 'package:genzee_wears/pages/product_description.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Product> wishlistItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final userId = AuthService.instance.currentUser?.id ?? 0;
    final items = await DatabaseHelper.instance.getWishlistProducts(userId);
    if (!mounted) return;
    setState(() {
      wishlistItems = items;
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite(Product item) async {
    final userId = AuthService.instance.currentUser?.id ?? 0;
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to manage wishlist')),
      );
      Navigator.pushNamed(context, AppRoute.login);
      return;
    }
    await FavoritesService.instance.toggleFavorite(item.id, userId);
    await _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFF2A2A2D)),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: const Text(
            'My Wishlist',
            style: TextStyle(
              color: Color(0xFFF0F0F2),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFFF0F0F2),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xff7C53FB)),
              )
            : wishlistItems.isEmpty
                ? const Center(
                    child: Text(
                      'No favorites yet',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                    children: wishlistItems
                        .map((item) => ProductCard(
                              item: item,
                              onFavoriteTap: () => _toggleFavorite(item),
                            ))
                        .toList(),
                  ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product item;
  final VoidCallback onFavoriteTap;

  const ProductCard({
    super.key,
    required this.item,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDescription(item: item)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.asset(
                      item.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    color: Colors.deepPurple,
                  ),
                  child: Center(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onFavoriteTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.favorite_sharp,
                    color: Colors.deepPurpleAccent,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}