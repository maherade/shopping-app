import 'package:shopping_app_task/features/products_home/data/models/product_model.dart';
import 'package:shopping_app_task/features/products_home/data/models/category_model.dart';
import 'package:shopping_app_task/features/cart/data/models/cart_item_model.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/category_entity.dart';
import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';

abstract interface class LocalStore {
  /// Reads cached products
  Future<List<Product>> products();

  /// Caches products by ID
  Future<void> cacheProducts(List<Product> products);

  /// Reads cached categories
  Future<List<Category>> categories();

  /// Replaces cached categories
  Future<void> cacheCategories(List<Category> categories);

  /// Reads the user's saved cart
  Future<List<CartItem>> cart(int userId);

  /// Saves the user's cart
  Future<void> saveCart(int userId, List<CartItem> items);
}

class SqliteStore implements LocalStore {
  SqliteStore(this.database);
  final Database database;

  /// Opens the local shopping database
  static Future<SqliteStore> open() async {
    final directory = await getDatabasesPath();
    return SqliteStore(
      await openDatabase(
        '$directory/dummy_shop.db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE products (id INTEGER PRIMARY KEY, json TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE categories (slug TEXT PRIMARY KEY, json TEXT NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE cart (user_id INTEGER NOT NULL, product_id INTEGER NOT NULL, json TEXT NOT NULL, PRIMARY KEY(user_id, product_id))',
          );
        },
      ),
    );
  }

  /// Reads cached products
  @override
  Future<List<Product>> products() async =>
      (await database.query('products', orderBy: 'id'))
          .map(
            (row) => ProductModel.fromJson(
              jsonDecode(row['json'] as String) as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();

  /// Caches products by ID
  @override
  Future<void> cacheProducts(List<Product> products) =>
      database.transaction((txn) async {
        for (final p in products) {
          await txn.insert('products', {
            'id': p.id,
            'json': jsonEncode(ProductModel.fromEntity(p).toJson()),
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });

  /// Reads cached categories
  @override
  Future<List<Category>> categories() async =>
      (await database.query('categories', orderBy: 'slug'))
          .map(
            (row) => CategoryModel.fromJson(
              jsonDecode(row['json'] as String),
            ).toEntity(),
          )
          .toList();

  /// Replaces cached categories
  @override
  Future<void> cacheCategories(List<Category> categories) =>
      database.transaction((txn) async {
        await txn.delete('categories');
        for (final category in categories) {
          await txn.insert('categories', {
            'slug': category.slug,
            'json': jsonEncode(CategoryModel.fromEntity(category).toJson()),
          });
        }
      });

  /// Reads the user's saved cart
  @override
  Future<List<CartItem>> cart(int userId) async =>
      (await database.query(
            'cart',
            where: 'user_id = ?',
            whereArgs: [userId],
            orderBy: 'product_id',
          ))
          .map(
            (row) => CartItemModel.fromJson(
              jsonDecode(row['json'] as String) as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();

  /// Saves the user's cart
  @override
  Future<void> saveCart(int userId, List<CartItem> items) =>
      database.transaction((txn) async {
        await txn.delete('cart', where: 'user_id = ?', whereArgs: [userId]);
        for (final item in items) {
          await txn.insert('cart', {
            'user_id': userId,
            'product_id': item.product.id,
            'json': jsonEncode(CartItemModel.fromEntity(item).toJson()),
          });
        }
      });
}
