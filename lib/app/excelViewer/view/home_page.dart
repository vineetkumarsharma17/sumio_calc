import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:sumio_calc/app/excelViewer/controller.dart';
import 'excel_detail_page.dart';

class HomePage extends StatelessWidget {
  final ExcelController excelController = Get.put(ExcelController());

  Future<void> pickExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      await excelController.pickExcelFile(
        result.files.single.path!,
        result.files.single.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uploaded Excel Files")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload_file),
        onPressed: pickExcel,
      ),
      body: Obx(() {
        if (excelController.files.isEmpty) {
          return const Center(
            child: Text("Upload an Excel file"),
          );
        }

        return ListView.builder(
          itemCount: excelController.files.length,
          itemBuilder: (context, index) {
            final file = excelController.files[index];

            return ListTile(
              leading: const Icon(Icons.file_copy),
              title: Text(file.fileName),
              subtitle: Text("Tap to view data"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(() => ExcelDetailPage(fileModel: file));
              },
            );
          },
        );
      }),
    );
  }
}
