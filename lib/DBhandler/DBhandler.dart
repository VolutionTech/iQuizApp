import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler._internal();
  static Database? _database;

  factory DatabaseHandler() {

    return _instance;
  }

  DatabaseHandler._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    // Create tables and perform any initial setup here
    await db.execute('CREATE TABLE session (question_id TEXT, selected_option TEXT, quiz_id)');

  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Add your database operations here
  Future<List<Map<String, dynamic>>> getAllItems(String quizId) async {
   final Database db = await database;
    return await db.query('session', where: 'quiz_id = ?', whereArgs: [quizId]);
  }

  delete(String category) async {
    final Database db = await database;
     await db.delete('session', where: 'quiz_id = ?', whereArgs: [category]);
  }


  Future<Map<String, dynamic>?> getRowWithMaxIndForCategory(String category) async {
    Database db = await DatabaseHandler().database;

    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM session WHERE ind = (SELECT MAX(ind) FROM session WHERE category = ?)',
      [category],
    );

    return result.isNotEmpty ? result[0] : null;
  }


  Future<void> insertItem(Map<String, dynamic> item) async {
    final Database db = await database;
    await db.insert('session', item);
  }
  Future<void> updateItem(Map<String, dynamic> item) async {
    final Database db = await database;
    await db.update(
      'session',
      item,
      where: 'ind = ? AND category = ?',
      whereArgs: [item['ind'], item['category']],
    );
  }
  Future<Map<String, dynamic>?> getItem(int ind, String category) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'session',
      where: 'ind = ? AND category = ?',
      whereArgs: [ind, category],
    );

    return result.isNotEmpty ? result[0] : null;
  }
}
