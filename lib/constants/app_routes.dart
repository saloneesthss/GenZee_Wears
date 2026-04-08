import 'package:genzee_wears/dashboard_view.dart';
import 'package:genzee_wears/login_page.dart';
import 'package:genzee_wears/my_profile.dart';
import 'package:genzee_wears/product_description.dart';
import 'package:genzee_wears/shopping_cart.dart';
import 'package:genzee_wears/signup_page.dart';

class AppRoute {
  AppRoute._();

  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String myProfile = '/myProfile';
  static const String cart = '/cart';
  static const String productDescription = '/productDescription';

  static getAppRoutes() => {
    dashboard: (context) => const DashboardView(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    myProfile: (context) => const MyProfile(),
    cart: (context) => const ShoppingCart(),
    productDescription: (context) => const ProductDescription(),
  };
}