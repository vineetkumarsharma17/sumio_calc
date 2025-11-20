// import 'package:flutter/material.dart';

// class ExcelDetailPage extends StatelessWidget {
//   final ExcelFileModel fileModel;

//   const ExcelDetailPage({required this.fileModel, super.key});

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
