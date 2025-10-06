import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    debugPrint('📁 Database path: $path');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT,
        telefone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT,
        clienteId INTEGER,
        prazo TEXT,
        status TEXT,
        FOREIGN KEY (clienteId) REFERENCES clientes (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE senhas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER,
        descricao TEXT,
        valor TEXT NOT NULL,
        sistema TEXT,
        FOREIGN KEY (clienteId) REFERENCES clientes (id)
      )
    ''');
  }
}
