import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumio_calc/app/controllers/calculator_controller.dart';
import 'package:sumio_calc/app/views/calculator_view.dart';

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
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: CalculatorView(),
      initialBinding: BindingsBuilder.put(() => CalculatorController()),
      debugShowCheckedModeBanner: false,
    );
  }
}
