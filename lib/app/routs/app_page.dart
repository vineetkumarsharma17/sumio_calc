import 'package:get/get.dart';
import 'package:sumio_calc/app/routs/routs.dart';
import 'package:sumio_calc/app/views/excelViewer.dart';

class AppPages {
  static final pages = [
    // other routes...

    GetPage(
      name: Routes.excelViewer,
      page: () => ExcelViewerView(),
    ),
  ];
}
