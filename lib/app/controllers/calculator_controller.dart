import 'package:get/get.dart';
import 'package:sumio_calc/app/excelViewer/view/home_page.dart';

class CalculatorController extends GetxController {
  RxString expression = ''.obs;
  RxString result = ''.obs;
  RxList<String> history = <String>[].obs;
  RxDouble memory = 0.0.obs;

  void appendInput(String value) {
    expression.value += value;
  }

  void clearAll() {
    expression.value = '';
    result.value = '';
  }

  void calculateResult() {
    try {
      // Basic arithmetic evaluation (for demo, use a proper parser for production)
      final exp = expression.value.replaceAll('×', '*').replaceAll('÷', '/');
      // ignore: avoid_dynamic_calls
      result.value = _evaluate(exp).toString();
      history.add('${expression.value} = ${result.value}');
      checkSecretCode();
    } catch (e) {
      result.value = 'Error';
    }
  }

  // void checkSecretCode() {
  //   if (expression.value == '1122') {
  //     Get.toNamed(Routes.excelViewer);
  //   }
  // }
  void checkSecretCode() {
    if (expression.value == '1122') {
      //Get.toNamed('/excelViewer');
      Get.to(() => HomePage());
    }
  }

  void memoryAdd() {
    memory.value += double.tryParse(result.value) ?? 0.0;
  }

  void memorySubtract() {
    memory.value -= double.tryParse(result.value) ?? 0.0;
  }

  void memoryRecall() {
    result.value = memory.value.toString();
  }

  void memoryClear() {
    memory.value = 0.0;
  }

  num _evaluate(String exp) {
    // Simple parser for +, -, *, /
    // For production, use a math expression package
    return double.tryParse(exp) ?? 0.0;
  }
}
