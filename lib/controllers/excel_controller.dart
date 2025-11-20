import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../services/storage_service.dart';

class ExcelController extends GetxController {
  final StorageService storageService = StorageService();
  RxList<Map<String, dynamic>> fileStats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFileStats();
  }

  Future<void> loadFileStats() async {
    await storageService.init();
    final rows = await storageService.getRows();
    final Map<String, Map<String, dynamic>> fileData = {};
    for (var row in rows) {
      final fileName = row['file_name'] ?? '';
      if (!fileData.containsKey(fileName)) {
        fileData[fileName] = {
          'file_name': fileName,
          'count': 0,
          'created_at': row['updated_at'],
        };
      }
      fileData[fileName]!['count'] = (fileData[fileName]!['count'] as int) + 1;
    }
    fileStats.value = fileData.values.toList();
    print(fileStats);
  }

  Future<void> pickExcelFile() async {
    await storageService.init();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null) {
      print("User cancelled picker");
      return;
    }

    // Read file bytes
    final bytes = File(result.files.single.path!).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    // First sheet
    final sheet = excel.tables[excel.tables.keys.first]!;

    // Convert excel to JSON-friendly data
    List<String> columns = [];
    List<List<String>> rowsData = [];

    for (int rowIndex = 0; rowIndex < sheet.rows.length; rowIndex++) {
      List<Data?> row = sheet.rows[rowIndex];

      // Convert every cell to simple string
      List<String> rowValues = row.map((cell) {
        return cell?.value.toString() ?? "";
      }).toList();

      // First row = column names
      if (rowIndex == 0) {
        columns = rowValues;
      } else {
        rowsData.add(rowValues);
      }
    }

    // Convert rowsData to List<Map<String, dynamic>> and ignore empty rows
    List<Map<String, dynamic>> jsonList = rowsData.where((row) {
      // Ignore row if all cells are empty or whitespace
      return row.any((cell) => cell.trim().isNotEmpty);
    }).map((row) {
      Map<String, dynamic> rowMap = {};
      for (int i = 0; i < columns.length; i++) {
        rowMap[columns[i]] = row[i];
      }
      rowMap['file_name'] = result.files.single.name;
      return rowMap;
    }).toList();

    // Store each row in DB as JSON
    for (var item in jsonList) {
      await storageService.insertRow(result.files.single.name, item);
    }

    print("Imported and saved ${jsonList.length} rows to DB");

    // Reload file stats after import
    await loadFileStats();
  }
}
