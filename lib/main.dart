import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumio_calc/controllers/calculator_controller.dart';
import 'package:sumio_calc/views/calculator/calculator_view.dart';

void main() {
  runApp(SumioApp());
}

class SumioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sumio',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: CalculatorView(),
      initialBinding: BindingsBuilder.put(() => CalculatorController()),
      debugShowCheckedModeBanner: false,
    );
  }
}
