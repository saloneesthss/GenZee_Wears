import 'package:flutter/material.dart';
import 'package:genzee_wears/constants/app_routes.dart';
import 'package:genzee_wears/constants/app_text_styles.dart';
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final searchController = TextEditingController();

  List<String> categories = [
    'Accessories',
    'Hoodies',
    'Sweaters',
    'Pants',
    'Jeans',
    'T-Shirts',
    'Jackets',
    'Shoes',
  ];

  List<Map<String, dynamic>> featuredItems = [
    {
      'name': 'Stylish Hoodie',
      'image': 'assets/images/hoodie.png',
      'price': 49.99,
      'rating': 4.5,
    },
    {
      'name': 'Casual Sweater',
      'image': 'assets/images/sweater.jpg',
      'price': 39.99,
      'rating': 4.0,
    },
    {
      'name': 'Denim Jeans',
      'image': 'assets/images/denim-jeans.jpg',
      'price': 59.99,
      'rating': 3.5,
    },
    {
      'name': 'Graphic T-Shirt',
      'image': 'assets/images/graphic-tee.jpg',
      'price': 19.99,
      'rating': 3.0,
    },
  ];

  List<Map<String, dynamic>> popularItems = [
    {
      'name': 'Stylish Hoodie',
      'image': 'assets/images/hoodie.png',
      'price': 49.99,
      'rating': 4.5,
      'description':
      'A trendy hoodie for everyday wear. This hoodie is made from high-quality materials to ensure comfort and durability.',
    },
    {
      'name': 'Casual Sweater',
      'image': 'assets/images/sweater1.jpg',
      'price': 39.99,
      'rating': 4.0,
      'description':
      'A trendy hoodie for everyday wear. This hoodie is made from high-quality materials to ensure comfort and durability.',
    },
    {
      'name': 'Denim Jeans',
      'image': 'assets/images/denim-jeans.jpg',
      'price': 59.99,
      'rating': 3.5,
      'description':
      'A trendy hoodie for everyday wear. This hoodie is made from high-quality materials to ensure comfort and durability.',
    },
    {
      'name': 'Graphic T-Shirt',
      'image': 'assets/images/graphic-tee.jpg',
      'price': 19.99,
      'rating': 3.0,
      'description':
      'A trendy hoodie for everyday wear. This hoodie is made from high-quality materials to ensure comfort and durability.',
    },
  ];

  Widget buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, size: 16, color: Color(0xff7C53FB));
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(
            Icons.star_half,
            size: 16,
            color: Color(0xff7C53FB),
          );
        } else {
          return const Icon(
            Icons.star_border,
            size: 16,
            color: Color(0xff7C53FB),
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B211A),
      appBar: AppBar(
        backgroundColor: Color(0xff1B211A),
        surfaceTintColor: Color(0xff1B211A),
        toolbarHeight: 50,
        title: Text(
          'GenZee Wears',
          style: AppTextStyle.poppinsMedium.copyWith(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                style: AppTextStyle.poppinsRegular.copyWith(fontSize: 16),
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Enter search items',
                  hintStyle: AppTextStyle.poppinsRegular.copyWith(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  fillColor: Color(0xff353537),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 4,
                  ),

                  prefixIcon: Icon(Icons.search, size: 22, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xff7C53FB),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: AppTextStyle.poppinsRegular.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 12);
                  },
                  itemCount: categories.length,
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/blackFriday.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Items',
                    style: AppTextStyle.poppinsMedium.copyWith(
                      color: Color(0xff7C53FB),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'See All',
                    style: AppTextStyle.poppinsRegular.copyWith(
                      fontSize: 18,
                      color: Color(0xff7C53FB),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff7C53FB),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 215,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = featuredItems[index];
                    return Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: Color(0xff353537),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoute.productDescription);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(item['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.all(6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff7C53FB),

                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    '\$${item['price'].toString()}',
                                    style: AppTextStyle.poppinsRegular.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              item['name'],
                              style: AppTextStyle.poppinsRegular.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 2),
                            buildRatingStars(item['rating']),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 12);
                  },
                  itemCount: featuredItems.length,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Items',
                    style: AppTextStyle.poppinsMedium.copyWith(
                      color: Color(0xff7C53FB),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'See All',
                    style: AppTextStyle.poppinsRegular.copyWith(
                      fontSize: 18,
                      color: Color(0xff7C53FB),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff7C53FB),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.productDescription);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff353537),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              image: DecorationImage(
                                image: AssetImage(popularItems[index]['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  popularItems[index]['name'],
                                  style: AppTextStyle.poppinsMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 2),
                                buildRatingStars(popularItems[index]['rating']),
                                SizedBox(height: 6),
                                Text(
                                  popularItems[index]['description'],
                                  style: AppTextStyle.poppinsRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '\$${popularItems[index]['price'].toString()}',
                                  style: AppTextStyle.poppinsBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 12);
                },
                itemCount: popularItems.length,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
