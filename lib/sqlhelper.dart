import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  title TEXT,
  description TEXT,
  createdAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  )
  """);
  }

//open database
  static Future<sql.Database> db() async {
    return sql.openDatabase('memmory.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

//read items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<int> createitem(String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {'title': title, 'description': description};
    final id = await db.insert('items', data);
    return id;
  }

  static Future<int> updateItem(
      String title, int id, String? description) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('items', data, where: "id=?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteitem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id=?", whereArgs: [id]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
