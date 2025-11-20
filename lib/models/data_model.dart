class DataModel {
	final int id;
	final String name;
	final String father;
	final String address;
	final String aadhar;
	final int amount;
	final String bank;
	final int? receivedAmount;
	final String fileName;
	bool isSynced;

	DataModel({
		required this.id,
		required this.name,
		required this.father,
		required this.address,
		required this.aadhar,
		required this.amount,
		required this.bank,
		this.receivedAmount,
		required this.fileName,
		this.isSynced = false,
	});

	factory DataModel.fromJson(Map<String, dynamic> json) {
		return DataModel(
			id: json['id'],
			name: json['name'],
			father: json['father'],
			address: json['address'],
			aadhar: json['aadhar'],
			amount: json['amount'],
			bank: json['bank'],
			receivedAmount: json['received_amount'],
			fileName: json['file_name'],
			isSynced: json['is_synced'] ?? false,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'name': name,
			'father': father,
			'address': address,
			'aadhar': aadhar,
			'amount': amount,
			'bank': bank,
			'received_amount': receivedAmount,
			'file_name': fileName,
			'is_synced': isSynced,
		};
	}
}

