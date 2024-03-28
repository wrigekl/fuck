import 'package:sqflite/sqflite.dart';
import 'package:practice1/login.dart';
import 'package:practice1/main.dart';
import 'package:path/path.dart';

class n {
  Database? _database;
  Future<Database> get database async{
    if(_database != null) {
      return _database!;
    }
    _database = await init();
    return _database!;
  }
  Future<String> get fullpath async {
    final name = 'note.db';
    final path = await getDatabasesPath();
    return join(path , name);
  }

  Future<Database> init() async {
    final path = await fullpath;
    var db = await openDatabase(
        path,
        version: 1,
        onCreate: (db , context) async {
          db.execute('CREATE TABLE note('
              '_email TEXT,'
              '_id INTEGER PRIMARY KEY AUTOINCREMENT,'
              '_web TEXT NOT NULL,'
              '_password TEXT NOT NULL,'
              '_favorite INTEGER,'
              '_login INTEGER)');
        },
      singleInstance: true
        );
    return db;
  }
  // Future<void>Sign(String email) async {
  //   final db =await database;
  //   await db.insert('note', {'_login' : 0 , '_email' : email});
  // }
  Future<void> login(String email) async {
    final db =await database;
    await db.update('note', {'_login' : 1} ,where: '_email = ?' , whereArgs: [email]);
  }
  Future<void> insertNote(String web , String password) async {
    final db =await  database;
    final email = await l().readLoginemail();
    await db.insert('note', {'_web' : web , '_password':password , '_email' : email , '_login' : 1 , '_favorite' : 0});
  }
  Future<void>logout() async {
    final db =await database;
    await db.update('note', {'_login' : 0} ,where: '_login = ?' , whereArgs: [1]);
  }
  Future<void>deleteNote(int id ) async {
    final db =await database;
    await db.delete('note',whereArgs: [id],where: '_id = ?');
  }
  Future<void>Update(String web , String password , int id) async {
    final db =await database;
    await db.update('note', {'_web' : web , '_password' : password , '_id' :id});
  }
  Future<List<Map<String , dynamic>>> readAllLoginNote() async {
    final db =await database;
    return await db.query('note',where: '_login = ?' , whereArgs: [1]);
  }
  Future<List<Map<String , dynamic>>> readAllLoginFavo() async {
    final db =await database;
    return await db.query('note',where: '_login = ? AND _favorite = ?' , whereArgs: [1,1]);
  }
  Future<void> addFavorite(int id) async {
    final db= await database;
    db.update('note', {'_favorite' : 1 },whereArgs: [id],where: '_id = ?');
  }
  Future<void> removeFavo (int id ) async {
    final db =await database;
    db.update('note', {'_favorite' : 0} , where: '_id = ?' , whereArgs: [id]);
  }
  Future<void> EditEmail(String email) async{
    final db = await database;
    // final email = await l().readLoginemail(); 用這個會導致獨到錯的email
    await db.update('note', {'_email' : email},where: '_email = ?' , whereArgs: [email]);
  }
  Future<List<Map<String , dynamic>>> search(String search) async {
    final reg = RegExp(search, caseSensitive: false);
    List<Map<String , dynamic>> matched = [];
    final datas = await readAllLoginNote();
    for(var e in datas as List<Map<String , dynamic>>){
      bool a = reg.hasMatch(e['_email']) || reg.hasMatch(e['_password']);
      a == true ? matched.add(e) : a = false;
    }
    return matched;
  }
}