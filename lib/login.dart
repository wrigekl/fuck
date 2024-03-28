import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:practice1/note.dart';
import 'package:practice1/main.dart';

class l {
  Database? _database;

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    _database = await init();
    return _database!;
  }
  Future<String> get fullpath async {
    final name = 'login.db';
    final path = await getDatabasesPath();
    return join(path , name);
  }

  Future<Database> init() async {
    final path = await fullpath;
    var db = await openDatabase(
    path,
    version: 1,
    onCreate: (db , context) async {
      await db.execute('CREATE TABLE login('
          '_email TEXT PRIMARY KEY,'
          '_password TEXT,'
          '_login INTEGER)');
      },
      singleInstance: true
    );
    return db;
  }
  Future<bool>onlyEmail(String email) async{
    final db =await database;
    final res = await db.query('login',whereArgs: [email],where: '_email = ?');
    return res.any((element) => element['_email'] == email);
  }
  Future<void> login(String email) async {
    final db = await database;
    db.update('login', {'_login' : 1} , whereArgs: [email] , where: '_email = ?');
  }
  Future<void> logout() async {
    final db = await database;
    db.update('login', {'_login' : 0} , where: '_login = ?' , whereArgs: [1]);
  }
  Future<String> readLoginemail () async {
    final db = await database;
    final result = await db.query('login',columns: ['_email'],whereArgs: [1],where: '_login = ?');
    return result.first['_email'].toString();
  }
  Future<void> delete() async {
    final db = await database;
    db.delete('login',where: '_login = ?' , whereArgs: [1]);
  }
  Future<void>Sign(String email , String password) async {
    final db =await database;
    db.insert('login', {'_email':email,'_password':password,'_login':0});
  }
  Future<void>Update(String email , String password) async {
    final db = await database;
    db.update('login', {'_email' : email , '_password' : password},whereArgs: [1],where: '_login = ?');
  }
  Future<bool>isMatched(String email , String password) async {
    final db =await database;
    List<Map<String , dynamic>> res = await db.query('login',columns: ['_email' , '_password']);
    return res.any((element) => element['_email'] == email && element['_password'] == password);
  }
  Future<bool>isLogin()async {
    final db =await database;
    final res = await db.query('login',whereArgs: [1],where: '_login = ?');
    return res.isNotEmpty;
  }
  Future<bool> matchEmail(String email , String password) async{
    final db  =await database;
    final res = await db.query('login',columns: ['_email' , '_password']);
    return res.any((element) => element['_email']  == email && element['_password'] == password);
  }
}