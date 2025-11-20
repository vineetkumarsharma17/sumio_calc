import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:convert';
import 'dart:io';

class ExcelViewerView extends StatelessWidget {
  const ExcelViewerView({super.key});

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
    print("Rows: ${sheet.maxRows}, Cols: ${sheet.maxCols}");

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

    // JSON structure
    final jsonMap = {
      "file_name": result.files.single.name,
      "columns": columns,
      "data": rowsData,
    };

    print("===== EXCEL JSON OUTPUT =====");
    print(const JsonEncoder.withIndent("  ").convert(jsonMap));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Excel Viewer")),
      body: Center(
        child: ElevatedButton(
          onPressed: pickExcelFile,
          child: const Text("Pick Excel File"),
        ),
      ),
    );
  }
}
