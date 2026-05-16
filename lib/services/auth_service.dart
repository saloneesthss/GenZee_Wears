import 'package:genzee_wears/models/user_model.dart';
import 'package:genzee_wears/services/database_helper.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  User? currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<bool> login(String email, String password) async {
    final user = await DatabaseHelper.instance.login(email, password);
    if (user != null) {
      currentUser = user;
      return true;
    }
    return false;
  }

  Future<String?> signup(String name, String email, String password) async {
    final exists = await DatabaseHelper.instance.emailExists(email);
    if (exists) {
      return 'This email is already registered.';
    }

    final id = await DatabaseHelper.instance.insertUser(
      User(name: name, email: email, password: password),
    );

    if (id > 0) {
      return null;
    }

    return 'Unable to create account. Please try again.';
  }

  void logout() {
    currentUser = null;
  }
}
