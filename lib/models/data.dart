import 'package:isar/isar.dart';

part 'data.g.dart';

@collection
class ExcelRow {
  Id id = Isar.autoIncrement; // Local Isar ID

  late int serverId; // ID from server (Excel ID)
  late String name;
  late String father;
  late String address;
  late String aadhar;
  late int amount;
  String? bank;
  int? receivedAmount;
  late int fileId;

  @Index()
  bool isSynced = false;

  DateTime updatedAt = DateTime.now();
}
