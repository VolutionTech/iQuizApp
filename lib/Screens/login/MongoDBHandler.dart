import 'package:mongo_dart/mongo_dart.dart';

import '../../Models/LoginResponseModel.dart';

class MongoDbHelper {
  static final String _dbName = 'test';
  static final String _collectionName = 'users';
  static final String _uri =
      "mongodb+srv://amurad:Germany1@cluster0.uyhcp.mongodb.net/$_dbName?retryWrites=true&w=majority";

  static Future<Db> getDb() async {
    var db = await Db.create(_uri);
    print('Connecting to database');
    await db.open();
    print('Connected to database');
    return db;
  }

  static Future<List<User>> findUser() async {
    final db = await getDb();

    final result = await db
        .collection(_collectionName) //.match('category', category)
        .find()
        .toList();
    await db.close();
    List<User> users = [];
    for (var item in result) {
      users.add(User.fromJson(item));
    }
    return users;
  }
}
