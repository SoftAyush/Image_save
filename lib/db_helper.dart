import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._();

  DBHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'image_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS images (
        id INTEGER PRIMARY KEY,
        imageUrl TEXT,
        name TEXT
      )
    ''');
  }

  Future<int> insertImage(Map<String, dynamic> image) async {
    Database db = await instance.database;
    return await db.insert('images', image);
  }

  Future<List<Map<String, dynamic>>> getImages() async {
    Database db = await instance.database;
    return await db.query('images');
  }
}
