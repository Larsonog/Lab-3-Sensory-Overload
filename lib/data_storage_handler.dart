import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:overexpose_journal/journal_entry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DataHandler {

  // used a combination of 
  //    https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
  // and
  //    https://docs.flutter.dev/cookbook/persistence/sqlite#example
  // to design class
  
  static const _databaseName = "journal.db";
  static const _databaseVersion = 1;
  static const _uuid = Uuid();

  DataHandler._privateConstructor();
  static final DataHandler instance = DataHandler._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE journal_entries (
            date TEXT PRIMARY KEY,
            path TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL
          )
          ''');
  }

  Future<void> insertEntry(JournalEntry entry) async {
    Database db = await instance.database;
    await db.insert('journal_entries',
     entry.toMap(),
     conflictAlgorithm: ConflictAlgorithm.replace
     );
  }

  Future<List<JournalEntry>> getAllEntries() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> entrymap = await db.query('journal_entries');
    return List.generate(entrymap.length, (i) {
      return JournalEntry(
      path: entrymap[i]['path'],
      date: DateTime.parse(entrymap[i]['date']),
      title: entrymap[i]['title'],
      description: entrymap[i]['description']
      );
    });
  }

  Future<String> saveImage(FileImage image) async {
    final Directory appdocdir = await getApplicationDocumentsDirectory();
    final String imagePath = '${appdocdir.path}${_uuid.v4}.png';

    await image.file.copy(imagePath);

    return imagePath;
  }

  Future<FileImage> getImage(String path) async {
    return FileImage(File(path));
  }
}