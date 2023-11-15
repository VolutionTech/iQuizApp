import 'package:imm_quiz_flutter/DBhandler/DBKeys.dart';
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
    await db.execute('CREATE TABLE ${DBKeys.TABLE_SESSION} (${DBKeys.KEY_QUESTION_ID} TEXT, ${DBKeys.KEY_SELECTED_OPTION} TEXT, ${DBKeys.KEY_QUIZ_ID})');

  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Add your database operations here
  Future<List<Map<String, dynamic>>> getItemAgainstQuizID(String quizId) async {
   final Database db = await database;
    return await db.query(DBKeys.TABLE_SESSION, where: '${DBKeys.KEY_QUIZ_ID} = ?', whereArgs: [quizId]);
  }
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final Database db = await database;
    return await db.query(DBKeys.TABLE_SESSION);
  }

  Future<List<Map<String, dynamic>>> getItem(String questionId, String quizId) async {
    print(questionId);
    print(quizId);
    final Database db = await database;
    return await db.query(DBKeys.TABLE_SESSION, where: '${DBKeys.KEY_QUIZ_ID} = ? and ${DBKeys.KEY_QUESTION_ID} = ?', whereArgs: [quizId, questionId]);
  }

  Future<void> updateItem(item, String questionId, String quizId,) async {
    final Database db = await database;
    await db.update(
      DBKeys.TABLE_SESSION,
      item,
      where: '${DBKeys.KEY_QUIZ_ID} = ? and ${DBKeys.KEY_QUESTION_ID} = ?',
      whereArgs: [quizId, questionId],
    );
  }
  delete(String category) async {
    final Database db = await database;
     await db.delete(DBKeys.TABLE_SESSION, where: '${DBKeys.KEY_QUIZ_ID} = ?', whereArgs: [category]);
  }
  Future<void> insertItem(Map<String, dynamic> item) async {
    final Database db = await database;
    await db.insert(DBKeys.TABLE_SESSION, item);
  }
  deleteAll() async {
    final Database db = await database;
    await db.delete(DBKeys.TABLE_SESSION);
  }



}
