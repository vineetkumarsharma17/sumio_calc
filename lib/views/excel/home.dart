import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:sumio_calc/controllers/excel_controller.dart';

class HomeScreen extends GetView<ExcelController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to Sumio")),
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blue,
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            controller.pickExcelFile();
          },
        ),
      ),
      body: const Center(
        child: Text("data"),
      ),
    );
  }
}
