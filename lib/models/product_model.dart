class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final double? oldprice;
  final double rating;
  final String description;
  final bool featured;
  final bool popular;
  final int? reviews;

  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.oldprice,
    required this.rating,
    required this.description,
    required this.featured,
    required this.popular,
    this.reviews,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: (map['id'] as num).toInt(),
      name: map['name'] as String,
      image: map['image'] as String,
      price: (map['price'] as num).toDouble(),
      oldprice: map.containsKey('oldprice') && map['oldprice'] != null
          ? (map['oldprice'] as num).toDouble()
          : null,
      rating: (map['rating'] as num).toDouble(),
      description: map['description'] as String,
      featured: map['featured'] == 1 || map['featured'] == true,
      popular: map['popular'] == 1 || map['popular'] == true,
      reviews: map.containsKey('reviews') && map['reviews'] != null
          ? (map['reviews'] as num).toInt()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'oldprice': oldprice,
      'rating': rating,
      'description': description,
      'featured': featured ? 1 : 0,
      'popular': popular ? 1 : 0,
      'reviews': reviews,
    };
  }

  static const List<Product> demoProducts = [
    Product(
      id: 1,
      name: 'Stylish Hoodie',
      image: 'assets/images/hoodie.png',
      price: 49.99,
      oldprice: 63.99,
      rating: 4.5,
      description:
          'A trendy hoodie for everyday wear. This hoodie is made from high-quality materials to ensure comfort and durability.',
      featured: true,
      popular: false,
      reviews: 24,
    ),
    Product(
      id: 2,
      name: 'Casual Sweater',
      image: 'assets/images/sweater.jpg',
      price: 39.99,
      oldprice: 49.99,
      rating: 4.0,
      description:
          'A comfortable sweater with a sleek design for cooler evenings and casual styling.',
      featured: true,
      popular: true,
      reviews: 12,
    ),
    Product(
      id: 3,
      name: 'Denim Jeans',
      image: 'assets/images/denim-jeans.jpg',
      price: 59.99,
      oldprice: 71.49,
      rating: 3.5,
      description:
          'Durable denim jeans with a modern fit. Perfect for daily wear and multiple seasons.',
      featured: true,
      popular: true,
      reviews: 8,
    ),
    Product(
      id: 4,
      name: 'Graphic T-Shirt',
      image: 'assets/images/graphic-tee.jpg',
      price: 19.99,
      oldprice: 25.99,
      rating: 3.0,
      description:
          'A laid-back graphic tee made from soft cotton with a bold print to complete your streetwear look.',
      featured: true,
      popular: false,
      reviews: 3,
    ),
    Product(
      id: 5,
      name: 'Streetwear Jacket',
      image: 'assets/images/sweater1.jpg',
      price: 69.99,
      oldprice: 77.09,
      rating: 4.3,
      description:
          'A lightweight streetwear jacket with clean lines and a subtle finish for everyday wear.',
      featured: false,
      popular: true,
      reviews: 19,
    ),
    Product(
      id: 6,
      name: 'Cargo Pants',
      image: 'assets/images/cargo-pants.jpg',
      price: 54.99,
      oldprice: 64.49,
      rating: 4.1,
      description:
          'Comfortable cargo pants with extra storage pockets—practical and stylish for everyday wear.',
      featured: false,
      popular: true,
      reviews: 6,
    ),
  ];
}
