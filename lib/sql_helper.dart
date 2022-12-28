import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_application_1/models/biodata.dart';

// data
// table name = biodata
// id = integer, primary key, auto increment
// nim = integer
// name = text
// address = text
// gender = radio button ( text )

// define SQLHelper class
// this will create the table
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE biodata(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nim INTEGER,
        nama text,
        address TEXT,
        gender TEXT, 
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  // create database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'biodata.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // create new data ( insert ) ( bio )
  static Future<int> createItem(Biodata biodata) async {
    final db = await SQLHelper.db();

    final data = {
      'nim': biodata.nim,
      'nama': biodata.nama,
      'address': biodata.address,
      'gender': biodata.gender
    };

    final id = await db.insert('biodata', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // read data ( select ) ( bio )
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('biodata', orderBy: "id");
  }

  // read single data ( IMPORTANTE )
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('biodata', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // update data ( update ) ( bio )
  static Future<int> updateItem(
      int id, int nim, String nama, String address, String gender) async {
    final db = await SQLHelper.db();

    final data = {
      'nim': nim,
      'nama': nama,
      'address': address,
      'gender': gender
    };

    final result =
        await db.update('biodata', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // delete data ( delete ) ( bio )
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("biodata", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Cannot delete bio: $err");
    }
  }
}
