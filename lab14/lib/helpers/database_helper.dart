import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'places.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE places(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        image TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT
      )
    ''');
  }

  Future<int> insertPlace(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('places', row);
  }

  Future<List<Map<String, dynamic>>> getPlaces() async {
    Database db = await database;
    return await db.query('places');
  }

  Future<Map<String, dynamic>?> getPlace(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'places',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> deletePlace(int id) async {
    Database db = await database;
    return await db.delete(
      'places',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 