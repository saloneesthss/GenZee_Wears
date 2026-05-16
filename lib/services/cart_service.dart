import 'package:genzee_wears/services/database_helper.dart';

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    if (userId == 0) return [];
    try {
      return await DatabaseHelper.instance.getCartItems(userId);
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }

  Future<void> addToCart(int userId, int productId, int quantity) async {
    if (userId == 0) return;
    try {
      await DatabaseHelper.instance.addCartItem(userId, productId, quantity);
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> updateQuantity(int userId, int productId, int quantity) async {
    if (userId == 0) return;
    try {
      if (quantity <= 0) {
        await removeFromCart(userId, productId);
      } else {
        await DatabaseHelper.instance.updateCartItemQuantity(userId, productId, quantity);
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> removeFromCart(int userId, int productId) async {
    if (userId == 0) return;
    try {
      await DatabaseHelper.instance.removeCartItem(userId, productId);
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> clearCart(int userId) async {
    if (userId == 0) return;
    try {
      await DatabaseHelper.instance.clearCart(userId);
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCartItemsWithProducts(int userId) async {
    if (userId == 0) return [];
    try {
      final cartItems = await getCartItems(userId);
      if (cartItems.isEmpty) return [];
      
      final itemsWithProducts = <Map<String, dynamic>>[];
      
      for (final item in cartItems) {
        try {
          final productId = item['product_id'] as int;
          final product = await DatabaseHelper.instance.getProductById(productId);
          if (product != null) {
            itemsWithProducts.add({
              ...item,
              'product': product,
            });
          }
        } catch (e) {
          print('Error fetching product $e');
          continue;
        }
      }
      
      return itemsWithProducts;
    } catch (e) {
      print('Error in getCartItemsWithProducts: $e');
      return [];
    }
  }

  Future<int> getTotalItems(int userId) async {
    if (userId == 0) return 0;
    try {
      final items = await getCartItems(userId);
      return items.fold<int>(0, (sum, item) => sum + ((item['quantity'] as int?) ?? 0));
    } catch (e) {
      print('Error getting total items: $e');
      return 0;
    }
  }
}
