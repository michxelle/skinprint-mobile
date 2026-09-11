import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance =
      AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();

    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath =
        await getDatabasesPath();

    final path = join(
      databasePath,
      'skinprint.db',
    );

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
    await db.execute(
      '''
      CREATE TABLE saved_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        ingredients_text TEXT NOT NULL,
        image_url TEXT NOT NULL,
        reaction TEXT NOT NULL,
        saved_at TEXT NOT NULL
      )
      ''',
    );
  }
}