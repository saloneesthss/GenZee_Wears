import 'package:genzee_wears/pages/dashboard_view.dart';
import 'package:genzee_wears/auth/login_page.dart';
import 'package:genzee_wears/pages/my_profile.dart';
import 'package:genzee_wears/pages/cart_page.dart';
import 'package:genzee_wears/auth/signup_page.dart';
import 'package:genzee_wears/pages/splash_screen.dart';

class AppRoute {
  AppRoute._();

  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String myProfile = '/myProfile';
  static const String cart = '/cart';

  static getAppRoutes() => {
    splash: (context) => const SplashScreen(),
    dashboard: (context) => const DashboardView(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    myProfile: (context) => const MyProfile(),
    cart: (context) => const CartPage(),
  };
}