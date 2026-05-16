import 'package:genzee_wears/services/database_helper.dart';

class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  Future<List<int>> getFavoriteIds(int userId) async {
    if (userId == 0) return [];
    final db = DatabaseHelper.instance;
    final favorites = await db.database.then((database) {
      return database.query(
        'favorites',
        columns: ['product_id'],
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    });
    return favorites.map((row) => row['product_id'] as int).toList();
  }

  Future<bool> isFavorited(int productId, int userId) async {
    return await DatabaseHelper.instance.isFavorite(productId, userId);
  }

  Future<bool> toggleFavorite(int productId, int userId) async {
    return await DatabaseHelper.instance.toggleFavorite(productId, userId);
  }
}
