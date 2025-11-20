// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sumio_calc/controllers/excel_controller.dart';

// class ExcelDetailPage extends GetView<ExcelController> {
//   const ExcelDetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(fileModel.fileName)),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
//           border: TableBorder.all(color: Colors.grey.shade400),
//           columns: fileModel.columns
//               .map(
//                 (col) => DataColumn(
//                   label: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       col,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//           rows: fileModel.rows.map((row) {
//             return DataRow(
//               cells: row
//                   .map(
//                     (cell) => DataCell(
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(cell),
//                       ),
//                     ),
//                   )
//                   .toList(),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
