import 'package:sqflite/sqflite.dart';
import '../Model/DataModel.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  Database? database;

  factory DatabaseHelper() {
    return instance;
  }

  Future<Database> get db async {
    if (database != null) return database!;

    database = await initDatabase();
    return database!;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = '$databasesPath/quotes.db';

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favourites(id INTEGER PRIMARY KEY AUTOINCREMENT, quote TEXT, author TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertQuote(Quote quote) async {
    final db = await this.db;
    await db.insert(
      'favourites',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Quote>> retrieveQuotes() async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query('favourites');
    return List.generate(maps.length, (i) {
      return Quote.fromMap(data: maps[i]);
    });
  }

  Future<void> deleteQuote(int id) async {
    final db = await this.db;
    await db.delete(
      'favourites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
