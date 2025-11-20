import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sumio_calc/models/data.dart';

class StorageService {}

class IsarService {
  static Isar? _isar;

  static Future<Isar> init() async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [ExcelRowSchema],
      directory: dir.path,
      inspector: true, // optional, open Isar Inspector
    );

    return _isar!;
  }

  static Isar get db => _isar!;
}
