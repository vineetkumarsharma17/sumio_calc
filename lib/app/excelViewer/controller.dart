import 'dart:io';
import 'package:excel/excel.dart';
import 'package:get/get.dart';

class ExcelFileModel {
  final String fileName;
  final String filePath;
  final List<String> columns;
  final List<List<String>> rows;

  ExcelFileModel({
    required this.fileName,
    required this.filePath,
    required this.columns,
    required this.rows,
  });
}

class ExcelController extends GetxController {
  var files = <ExcelFileModel>[].obs;

  Future<void> pickExcelFile(String filePath, String fileName) async {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables.keys.first;
    final table = excel.tables[sheet]!;

    // Columns
    List<String> headers =
        table.rows.first.map((c) => c?.value.toString() ?? "").toList();

    // Rows
    List<List<String>> dataRows = table.rows
        .skip(1)
        .map((row) => row.map((c) => c?.value.toString() ?? "").toList())
        .toList();

    files.add(
      ExcelFileModel(
        fileName: fileName,
        filePath: filePath,
        columns: headers,
        rows: dataRows,
      ),
    );
  }
}
