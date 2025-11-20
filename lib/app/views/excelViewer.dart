import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ExcelViewerView extends StatelessWidget {
  const ExcelViewerView({super.key});

  Future<void> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      print("File Picked: ${result.files.single.name}");
    } else {
      print("User cancelled picker");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Excel File Picker"),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.upload_file),
          label: const Text("Pick Excel File"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: pickExcelFile,
        ),
      ),
    );
  }
}
