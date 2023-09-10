import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorage {
  final int version;
  final OnDatabaseCreateFn? onCreate;
  final OnDatabaseVersionChangeFn? onUpgrade;
  final OnDatabaseVersionChangeFn? onDowngrade;
  final OnDatabaseOpenFn? onOpen;

  LocalStorage._(
      {required this.version,
      this.onCreate,
      this.onUpgrade,
      this.onDowngrade,
      this.onOpen});

  static LocalStorage? _instance;
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  factory LocalStorage(
    int version, {
    OnDatabaseCreateFn? onCreate,
    OnDatabaseVersionChangeFn? onUpgrade,
    OnDatabaseVersionChangeFn? onDowngrade,
    OnDatabaseOpenFn? onOpen,
  }) {
    return _instance ??= LocalStorage._(version: version);
  }

  Future<Database> _initDB() async {
    final dir = await _getDatabaseDir();
    final path = dir.path;
    return openDatabase(path,
        version: version,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
        onDowngrade: onDowngrade,
        onOpen: onOpen);
  }

  Future<Directory> _getDatabaseDir() {
    return getApplicationDocumentsDirectory();
  }
}
