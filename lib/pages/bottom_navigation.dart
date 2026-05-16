import 'package:flutter/material.dart';
import 'package:genzee_wears/pages/dashboard_view.dart';
import 'package:genzee_wears/pages/my_profile.dart';
import 'package:genzee_wears/pages/cart_page.dart';
import 'package:genzee_wears/pages/wishlist_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int index = 0;
  final screens = [DashboardView(), CartPage(), WishlistPage(), MyProfile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(primaryColor: Color(0xffe4ad46), canvasColor: Color(0xffe4ad46)),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(
            color: Colors.deepPurple,
          ),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
