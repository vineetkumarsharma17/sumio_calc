import 'package:path_provider/path_provider.dart';
import 'package:sumio_calc/models/data_model.dart';
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
          CREATE TABLE data_models (
            id INTEGER,
            registration TEXT,
            name TEXT,
            father TEXT,
            address TEXT,
            aadhar TEXT,
            amount INTEGER,
            bank TEXT,
            received_amount INTEGER,
            file_name TEXT,
            is_synced INTEGER,
            updated_at TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveAll(List<DataModel> models) async {
    final batch = _db!.batch();
    for (var model in models) {
      batch.insert('data_models', model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> save(DataModel model) async {
    await _db!.insert('data_models', model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DataModel>> getAll() async {
    final result = await _db!.query('data_models');
    return result.map((e) => DataModel.fromJson(e)).toList();
  }

  Future<List<DataModel>> search({
    int? id,
    String? name,
    String? registration,
    String? father,
    String? address,
    String? aadhar,
    int? amount,
    String? bank,
    int? receivedAmount,
    String? fileName,
    bool? isSynced,
    DateTime? updatedAfter,
    DateTime? updatedBefore,
  }) async {
    final where = <String>[];
    final args = <dynamic>[];
    if (id != null) {
      where.add('id = ?');
      args.add(id);
    }
    if (name != null) {
      where.add('LOWER(name) LIKE ?');
      args.add('%${name.toLowerCase()}%');
    }
    if (registration != null) {
      where.add('LOWER(registration) LIKE ?');
      args.add('%${registration.toLowerCase()}%');
    }
    if (father != null) {
      where.add('LOWER(father) LIKE ?');
      args.add('%${father.toLowerCase()}%');
    }
    if (address != null) {
      where.add('LOWER(address) LIKE ?');
      args.add('%${address.toLowerCase()}%');
    }
    if (aadhar != null) {
      where.add('LOWER(aadhar) LIKE ?');
      args.add('%${aadhar.toLowerCase()}%');
    }
    if (amount != null) {
      where.add('amount = ?');
      args.add(amount);
    }
    if (bank != null) {
      where.add('LOWER(bank) LIKE ?');
      args.add('%${bank.toLowerCase()}%');
    }
    if (receivedAmount != null) {
      where.add('received_amount = ?');
      args.add(receivedAmount);
    }
    if (fileName != null) {
      where.add('LOWER(file_name) LIKE ?');
      args.add('%${fileName.toLowerCase()}%');
    }
    if (isSynced != null) {
      where.add('is_synced = ?');
      args.add(isSynced ? 1 : 0);
    }
    if (updatedAfter != null) {
      where.add('updated_at > ?');
      args.add(updatedAfter.toIso8601String());
    }
    if (updatedBefore != null) {
      where.add('updated_at < ?');
      args.add(updatedBefore.toIso8601String());
    }
    final result = await _db!.query(
      'data_models',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args,
    );
    return result.map((e) => DataModel.fromJson(e)).toList();
  }
}
