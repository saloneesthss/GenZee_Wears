import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          "GenZee Wears",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PRODUCT IMAGE
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/hoodie.png',
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// ROW - Favorite , Price , Buy
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// FAVORITE BUTTON
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xff3E1E74),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.favorite_border, color: Colors.white),
                  ),

                  /// PRICE AREA
                  Column(
                    children: [
                      const Text(
                        "\$18.00",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$30.00",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    ],
                  ),

                  /// BUY BUTTON
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: const Color(0xff7F39FB),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Buy",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// PRODUCT TITLE, RATING, LINK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Stylish Hoodie",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.purple, size: 22),
                      const SizedBox(width: 4),
                      const Text(
                        "4.5",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "[3]",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        "Show Reviews",
                        style: TextStyle(
                          color: Colors.purpleAccent.shade100,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// DESCRIPTION SECTION
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
                      color: Colors.grey.shade900.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "A trendy hoodie for everyday wear. This hoodie is made from high-quality materials to ensure comfort and durability.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
