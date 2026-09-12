import 'package:sqflite/sqflite.dart';

import 'package:skinprint/core/database/app_database.dart';
import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'package:skinprint/features/my_products/models/product_reaction.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';

class SavedProductRepository {
  final AppDatabase _appDatabase;

  SavedProductRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<List<SavedProduct>> getAllProducts() async {
    final db = await _appDatabase.database;

    final results = await db.query('saved_products', orderBy: 'saved_at DESC');

    return results.map(SavedProduct.fromMap).toList();
  }

  Future<SavedProduct?> getProductByCode(String code) async {
    final db = await _appDatabase.database;

    final results = await db.query(
      'saved_products',
      where: 'code = ?',
      whereArgs: [code],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return SavedProduct.fromMap(results.first);
  }

  Future<SavedProduct> saveProduct({
    required BeautyProduct product,
    required ProductReaction reaction,
  }) async {
    final db = await _appDatabase.database;

    final savedProduct = SavedProduct.fromBeautyProduct(
      product: product,
      reaction: reaction,
    );

    final map = savedProduct.toMap();

    map.remove('id');

    final id = await db.insert(
      'saved_products',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return savedProduct.copyWith(id: id);
  }

  Future<SavedProduct> updateReaction({
    required SavedProduct product,
    required ProductReaction reaction,
  }) async {
    final db = await _appDatabase.database;

    await db.update(
      'saved_products',
      {'reaction': reaction.name},
      where: 'code = ?',
      whereArgs: [product.code],
    );

    return product.copyWith(reaction: reaction);
  }

  Future<void> deleteProduct(String code) async {
    final db = await _appDatabase.database;

    await db.delete('saved_products', where: 'code = ?', whereArgs: [code]);
  }
}
