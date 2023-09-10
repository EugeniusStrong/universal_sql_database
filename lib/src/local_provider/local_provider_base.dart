import 'package:sqflite/sqflite.dart';
import 'package:universal_sql_database/src/models/entity/entity.dart';

abstract class LocalProviderBase<T extends Entity> {
  final Database db;
  final String tableName;

  LocalProviderBase(this.db, {required this.tableName});

  T fromMap(Map<String, dynamic> map);

  Future<List<T>> getAll() async {
    final result = await db.query(tableName);
    return result.isNotEmpty ? result.map(fromMap).toList() : [];
  }

  Future<T?> getByUid(String uid) async {
    final result =
        await db.query(tableName, where: 'uid = ?', whereArgs: [uid], limit: 1);
    return result.isNotEmpty ? fromMap(result.first) : null;
  }

  Future<T> save(T entity) async {
    await db.insert(tableName, entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return entity;
  }

  Future<void> deleteAll() async {
    await db.delete(tableName);
  }

  Future<void> deleteByUid(String uid) async {
    await db.delete(tableName, where: 'uid = ?', whereArgs: [uid]);
  }
}
