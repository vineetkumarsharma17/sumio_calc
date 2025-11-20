import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StorageService {
  Database? _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'local_data.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE excel_rows (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_name TEXT,
            data TEXT,
            sync_status TEXT,
            updated_at TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertRow(String fileName, Map<String, dynamic> data,
      {String syncStatus = 'pending'}) async {
    await _db!.insert('excel_rows', {
      'file_name': fileName,
      'data': jsonEncode(data),
      'sync_status': syncStatus,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateRow(int id, Map<String, dynamic> data,
      {String? syncStatus}) async {
    await _db!.update(
      'excel_rows',
      {
        'data': jsonEncode(data),
        if (syncStatus != null) 'sync_status': syncStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getRows(
      {String? fileName, String? syncStatus}) async {
    final where = <String>[];
    final args = <dynamic>[];
    if (fileName != null) {
      where.add('file_name = ?');
      args.add(fileName);
    }
    if (syncStatus != null) {
      where.add('sync_status = ?');
      args.add(syncStatus);
    }
    final result = await _db!.query(
      'excel_rows',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args,
    );
    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return {
        'id': row['id'],
        'file_name': row['file_name'],
        'data': data,
        'sync_status': row['sync_status'],
        'updated_at': row['updated_at'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> searchRows(
      Map<String, dynamic> conditions) async {
    final where = <String>[];
    final args = <dynamic>[];
    conditions.forEach((key, value) {
      where.add("data LIKE ?");
      args.add('%"$key":"$value"%');
    });
    final result = await _db!.query(
      'excel_rows',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args,
    );
    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return {
        'id': row['id'],
        'file_name': row['file_name'],
        'data': data,
        'sync_status': row['sync_status'],
        'updated_at': row['updated_at'],
      };
    }).toList();
  }

  Future<void> updateSyncStatus(int id, String status) async {
    await _db!.update(
      'excel_rows',
      {
        'sync_status': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
