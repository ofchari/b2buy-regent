// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:b2buy/home_page.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
//
// String apiKey = "7cbf607bc7e6184"; //yaanee
// String apiSecret = "bbce3ba695e127f"; //yaanee
//
// class FrappePDFDownloader extends StatefulWidget {
//   @override
//   _FrappePDFDownloaderState createState() => _FrappePDFDownloaderState();
// }
//
// class _FrappePDFDownloaderState extends State<FrappePDFDownloader> {
//   PDFDocument _pdfDoc;
//
//   Future<void> _downloadPDF() async {
//     // Construct the API endpoint URL
//     final url =
//         'https://erp.yaaneefashions.com/api/method/frappe.utils.print_format.download_pdf?doctype=Flutter%20Mobile&name=FM-23-24-00007';
//     // 'https://erp.yaaneefashions.com/api/method/frappe.utils.print_format.download_pdf?doctype=Flutter%20Mobile&name=$documentIdNo';
//
//     // Create HTTP headers
//     final headers = {
//       'Authorization': 'token $apiKey:$apiSecret',
//     };
//
//     // Send an HTTP POST request to the API endpoint
//     final response = await http.post(Uri.parse(url), headers: headers);
//
//     // Check the response code to make sure it was successful
//     if (response.statusCode == 200) {
//       // Write the response body to a file with the .pdf extension
//       final dir = await getExternalStorageDirectory();
//       final file = File('/storage/emulated/0/Documents/FM-23-24-007.pdf');
//       // final file = File('/storage/emulated/0/Documents/$documentIdNo.pdf');
//       await file.writeAsBytes(response.bodyBytes);
//       // await file.readAsBytes(response.body);
//
//       setState(() async {
//         _pdfDoc = await PDFDocument.fromFile(file);
//
//         // _pdfDoc = PDFDocument.fromFile(file) as PDFDocument;
//       });
//     } else {
//       print(response.reasonPhrase);
//       throw Exception('Failed to download PDF: ${response.reasonPhrase}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           if (_pdfDoc != null)
//             Expanded(
//               child: PDFViewer(document: _pdfDoc),
//             )
//           else
//             const Spacer(),
//           Text('noting'),
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 await _downloadPDF();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('PDF downloaded')));
//               } catch (e) {
//                 if (ScaffoldMessenger.of(context).mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Failed to download PDF')));
//                 }
//                 print(e);
//               }
//             },
//             child: const Text('Download'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // class FrappePDFDownloader extends StatelessWidget {
// //   Future<void> _downloadPDF() async {
// //     // Construct the API endpoint URL
// //     final url =
// //         'https://erp.yaaneefashions.com/api/method/frappe.utils.print_format.download_pdf?doctype=Flutter%20Mobile&name=FM-23-24-00007';
// //     // 'https://erp.yaaneefashions.com/api/method/frappe.utils.print_format.download_pdf?doctype=Flutter%20Mobile&name=$documentIdNo';
// //
// //     // Create HTTP headers
// //     final headers = {
// //       'Authorization': 'token $apiKey:$apiSecret',
// //     };
// //
// //     // Send an HTTP POST request to the API endpoint
// //     final response = await http.post(Uri.parse(url), headers: headers);
// //
// //     // Check the response code to make sure it was successful
// //     if (response.statusCode == 200) {
// //       // Write the response body to a file with the .pdf extension
// //       final dir = await getExternalStorageDirectory();
// //       final file = File('/storage/emulated/0/Documents/FM-23-24-00007.pdf');
// //       // final file = File('/storage/emulated/0/Documents/$documentIdNo.pdf');
// //       await file.writeAsBytes(response.bodyBytes);
// //       // await file.readAsBytes(response.body);
// //
// //       print(await file.writeAsBytes(response.bodyBytes));
// //     } else {
// //       print(response.reasonPhrase);
// //       throw Exception('Failed to download PDF: ${response.reasonPhrase}');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Column(
// //         children: [
// //           ElevatedButton(
// //             onPressed: () async {
// //               try {
// //                 await _downloadPDF();
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(content: Text('PDF downloaded')));
// //               } catch (e) {
// //                 if (ScaffoldMessenger.of(context).mounted) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(content: Text('Failed to download PDF')));
// //                 }
// //                 print(e);
// //               }
// //             },
// //             child: const Text('Download ijik'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
