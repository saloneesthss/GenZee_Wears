import 'package:flutter/material.dart';
import 'package:genzee_wears/constants/app_text_styles.dart';
import 'package:genzee_wears/models/product_model.dart';
import 'package:genzee_wears/services/auth_service.dart';
import 'package:genzee_wears/constants/app_routes.dart';
import 'package:genzee_wears/services/favorites_service.dart';
import 'package:genzee_wears/services/cart_service.dart';

class ProductDescription extends StatefulWidget {
  final Product item;
  const ProductDescription({super.key, required this.item});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  Future<void> _loadFavoriteState() async {
    final userId = AuthService.instance.currentUser?.id ?? 0;
    final fav = await FavoritesService.instance.isFavorited(widget.item.id, userId);
    if (!mounted) return;
    setState(() {
      isFavorited = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    final userId = AuthService.instance.currentUser?.id ?? 0;
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to favorite items')),
      );
      Navigator.pushNamed(context, AppRoute.login);
      return;
    }
    final newState = await FavoritesService.instance.toggleFavorite(widget.item.id, userId);
    if (!mounted) return;
    setState(() {
      isFavorited = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191c19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141415),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "GenZee Wears",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  widget.item.image,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C53FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '\$${widget.item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${widget.item.oldprice}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.cart);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C53FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.purpleAccent, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        widget.item.rating.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '[${widget.item.reviews.toString()}]',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Show Reviews - coming soon!",
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: Color(0xFF232325),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          "Show Reviews",
                          style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.item.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C53FB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity,54),
                ),
                onPressed: () async {
                  final userId = AuthService.instance.currentUser?.id ?? 0;
                  if (userId == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in to add items to cart')),
                    );
                    Navigator.pushNamed(context, AppRoute.login);
                    return;
                  }
                  
                  try {
                    await CartService.instance.addToCart(
                      userId,
                      widget.item.id,
                      1,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.item.name} added to cart'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    print('Error adding to cart: $e');
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error adding to cart: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Add to Cart',
                  style: AppTextStyle.poppinsMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
