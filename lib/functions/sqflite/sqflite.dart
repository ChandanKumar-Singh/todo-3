import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_3/Models/NoteModel.dart';
import 'package:todo_3/functions/FireBase/firebaseDB.dart';

import '../function.dart';

class DatabaseHelper {
  static Future<sql.Database> db() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String dbName = 'todo_3.db';
    String path = join(databasesPath, dbName);
    return sql.openDatabase(
      path,
      version: 2,
      onCreate: (sql.Database database, int version) async {
        await createTodosTables(database);
      },
      // onUpgrade: _onUpgrade,
    );
  }

  // UPGRADE DATABASE TABLES
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("ALTER TABLE description ADD COLUMN uploaded BOOLEAN;");
    }
  }

  static Future<void> createTodosTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE todos1(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        user_id TEXT,
        description TEXT,
        uploaded INTEGER,
        reference TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)""");
  }

  //create new item
  static Future<int> createItem(String? title, String? description) async {
    final db = await DatabaseHelper.db();
    var dt = DateTime.now().toString();
    final note = NoteModel(
      userId: uid,
      title: title,
      description: description,
      reference: notesReference.path,
      uploaded: isOnline ? 1 : 0,
      createdAt: dt,
      updatedAt: DateTime.now().toString(),
    );
    final id = await db.insert('todos1', note.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    if (id != 0) {
      if (isOnline) {
        await FirebaseDb()
            .addNoteToFDB(NoteModel(
              id: id,
              userId: uid,
              title: title,
              description: description,
              reference: notesReference.path,
              uploaded: isOnline ? 1 : 0,
              createdAt: dt,
              updatedAt: DateTime.now().toString(),
            ))
            .then((value) => Fluttertoast.showToast(msg: 'Note added'));
      }
    } else {
      Fluttertoast.showToast(msg: 'Note not added');
    }
    return id;
  }

  //read all todos1
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('todos1', orderBy: "id");
  }

  //Get a single item by id
  //we don't use this method, it is for you if you want it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return await db.query('todos1', where: "id=?", whereArgs: [id], limit: 1);
  }

  //update a single item by id
  static Future<int> updateItem(NoteModel note) async {
    final db = await DatabaseHelper.db();

    final result = await db
        .update('todos1', note.toJson(), where: "id= ?", whereArgs: [note.id!]);
    if (result == 1) {
      if (isOnline) {
        await FirebaseDb().addNoteToFDB(note);
      }
    } else {
      Fluttertoast.showToast(msg: 'Note not added');
    }
    return result;
  }

  //Delete
  static Future<void> deleteItem(NoteModel note) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete('todos1', where: "id = ?", whereArgs: [note.id]);
      if (noteDeleteFromFbAlso) {
        debugPrint('Also delete from fb $noteDeleteFromFbAlso');
        await FirebaseDb().deleteNoteFromFDB(note);
      }
    } catch (e) {
      debugPrint('Something went wrong when deleting an item: $e');
    }
  }
}
