import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/data_model.dart';

class ExcelController extends GetxController {
  Future<void> pickExcelFile() async {
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

    // Load column mappings from JSON asset file
    final mappingsJson =
        await rootBundle.loadString('lib/controllers/column_mappings.json');
    final Map<String, dynamic> columnMappings = jsonDecode(mappingsJson);

    // Helper to find actual column index for a required key
    int? findColumnIndex(List<dynamic> possibleNames, List<String> columns) {
      for (final name in possibleNames) {
        final idx = columns.indexWhere((col) =>
            col.trim().toLowerCase() == name.toString().trim().toLowerCase());
        if (idx != -1) return idx;
      }
      return null;
    }

    // Convert rowsData to List<Map<String, dynamic>> and ignore empty rows
    List<Map<String, dynamic>> jsonList = rowsData.where((row) {
      // Ignore row if all cells are empty or whitespace
      return row.any((cell) => cell.trim().isNotEmpty);
    }).map((row) {
      Map<String, dynamic> rowMap = {};
      columnMappings.forEach((key, possibleNames) {
        final idx = findColumnIndex(possibleNames, columns);
        if (idx != null && idx < row.length) {
          rowMap[key] = row[idx];
        }
      });
      rowMap['file_name'] = result.files.single.name;
      return rowMap;
    }).toList();

    // here print all data
    print("Extracted Data: ${jsonList.length}");

    for (var item in jsonList) {
      print(item);
    }

    // Convert jsonList to List<DataModel>
    List<DataModel> dataModels =
        jsonList.map((item) => DataModel.fromJson(item)).toList();

    print("Extracted DataModels: \\${dataModels.length}");
    for (var model in dataModels) {
      print(model.toJson());
    }
  }
}
