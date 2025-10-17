import 'package:get/get.dart';
import '../views/calculator_view.dart';
import '../views/excel_viewer_view.dart';

class Routes {
  static const calculator = '/';
  static const excelViewer = '/excelViewer';
}

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.calculator,
      page: () => CalculatorView(),
    ),
  ];
}
