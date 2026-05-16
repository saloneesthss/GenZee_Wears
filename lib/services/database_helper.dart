import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:genzee_wears/models/product_model.dart';
import 'package:genzee_wears/models/user_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'genzee_wears.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS cart_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          quantity INTEGER NOT NULL DEFAULT 1,
          UNIQUE(user_id, product_id)
        )
      ''');
    }

    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE products ADD COLUMN oldprice REAL');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE products ADD COLUMN reviews INTEGER');
      } catch (_) {}
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        price REAL NOT NULL,
        oldprice REAL,
        rating REAL NOT NULL,
        description TEXT NOT NULL,
        featured INTEGER NOT NULL,
        popular INTEGER NOT NULL,
        reviews INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        UNIQUE(user_id, product_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        UNIQUE(user_id, product_id)
      )
    ''');
  }

  Future<void> initDatabase() async {
    final db = await database;
    await _insertInitialProducts(db);
  }

  Future<void> _insertInitialProducts(Database db) async {
    final batch = db.batch();
    for (final product in Product.demoProducts) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<User?> login(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isEmpty) return null;
    return User.fromMap(result.first);
  }

  Future<List<Product>> getProducts({bool featured = false, bool popular = false}) async {
    final db = await database;
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (featured) {
      whereClauses.add('featured = 1');
    }
    if (popular) {
      whereClauses.add('popular = 1');
    }

    final whereString = whereClauses.isEmpty ? null : whereClauses.join(' AND ');
    final result = await db.query('products', where: whereString, whereArgs: whereArgs);
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query('products');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Product.fromMap(result.first);
  }

  Future<bool> isFavorite(int productId, int userId) async {
    if (userId == 0) return false;
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
    return result.isNotEmpty;
  }

  Future<bool> toggleFavorite(int productId, int userId) async {
    if (userId == 0) return false;
    final db = await database;
    final isFav = await isFavorite(productId, userId);
    if (isFav) {
      await db.delete(
        'favorites',
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, productId],
      );
      return false;
    }

    final id = await db.insert('favorites', {
      'user_id': userId,
      'product_id': productId,
    });
    return id > 0;
  }

  Future<List<Product>> getWishlistProducts(int userId) async {
    if (userId == 0) return [];
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.* FROM products p
      INNER JOIN favorites f ON f.product_id = p.id
      WHERE f.user_id = ?
    ''', [userId]);
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    if (userId == 0) return [];
    final db = await database;
    return await db.query(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> addCartItem(int userId, int productId, int quantity) async {
    if (userId == 0) return 0;
    final db = await database;
    return await db.insert(
      'cart_items',
      {
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCartItemQuantity(int userId, int productId, int quantity) async {
    if (userId == 0) return 0;
    final db = await database;
    return await db.update(
      'cart_items',
      {'quantity': quantity},
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<int> removeCartItem(int userId, int productId) async {
    if (userId == 0) return 0;
    final db = await database;
    return await db.delete(
      'cart_items',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<void> clearCart(int userId) async {
    if (userId == 0) return;
    final db = await database;
    await db.delete('cart_items', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Product>> getCartProducts(int userId) async {
    if (userId == 0) return [];
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.*, c.quantity FROM products p
      INNER JOIN cart_items c ON c.product_id = p.id
      WHERE c.user_id = ?
    ''', [userId]);
    return result.map((map) => Product.fromMap(map)).toList();
  }
}
