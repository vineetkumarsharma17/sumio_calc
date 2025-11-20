class DataModel {
  final int? id;
  final String? name;
  final String? registration;
  final String? father;
  final String? address;
  final String? aadhar;
  final int? amount;
  final String? bank;
  final int? receivedAmount;
  final String? fileName;
  bool isSynced;
  DateTime updatedAt;

  DataModel({
    this.id,
    this.registration,
    this.name,
    this.father,
    this.address,
    this.aadhar,
    this.amount,
    this.bank,
    this.receivedAmount,
    this.fileName,
    this.isSynced = false,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      name: json['name'],
      father: json['father'],
      registration: json['registration'],
      address: json['address'],
      aadhar: json['aadhar'],
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString())
          : null,
      bank: json['bank'],
      receivedAmount: json['received_amount'] != null
          ? int.tryParse(json['received_amount'].toString())
          : null,
      fileName: json['file_name'],
      isSynced: json['is_synced'] ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registration': registration,
      'name': name,
      'father': father,
      'address': address,
      'aadhar': aadhar,
      'amount': amount,
      'bank': bank,
      'received_amount': receivedAmount,
      'file_name': fileName,
      'is_synced': isSynced,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
