import 'package:isar/isar.dart';

class ExcelRow {
  final int id;
  final String name;
  final String father;
  final String address;
  final String aadhar;
  final double amount;
  final String bank;
  final double? receivedAmount;
  final int fileId;
  final DateTime updatedAt;
  final bool isSynced;

  ExcelRow({
    required this.id,
    required this.name,
    required this.father,
    required this.address,
    required this.aadhar,
    required this.amount,
    required this.bank,
    this.receivedAmount,
    required this.fileId,
    required this.updatedAt,
    required this.isSynced,
  });

  ExcelRow copyWith({
    String? name,
    String? father,
    String? address,
    String? aadhar,
    double? amount,
    String? bank,
    double? receivedAmount,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return ExcelRow(
      id: id,
      name: name ?? this.name,
      father: father ?? this.father,
      address: address ?? this.address,
      aadhar: aadhar ?? this.aadhar,
      amount: amount ?? this.amount,
      bank: bank ?? this.bank,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      fileId: fileId,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "father": father,
        "address": address,
        "aadhar": aadhar,
        "amount": amount,
        "bank": bank,
        "received_amount": receivedAmount,
        "file_id": fileId,
        "updatedAt": updatedAt.toIso8601String(),
        "isSynced": isSynced,
      };
}
