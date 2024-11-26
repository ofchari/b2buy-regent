// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WhatsAppDemo(),
//     );
//   }
// }
//
// class WhatsAppDemo extends StatelessWidget {
//   // Function to launch WhatsApp with better error handling
//   void _launchWhatsApp(String phoneNumber) async {
//     final String url = "https://wa.me/$phoneNumber"; // Correct format
//
//     if (await canLaunchUrl(Uri.parse(url))) {
//       // Use the new Uri format and `launchUrl`
//       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//     } else {
//       // Error handling for failed launch
//       print('Could not launch WhatsApp');
//       throw 'Could not launch WhatsApp. Ensure WhatsApp is installed and the number is correct.';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("WhatsApp Launcher")),
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 15.0),
//               child: Container(
//                 height: 50,
//                 width: 150,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('Bank Details'),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'SRI BALAJI TEXKNIT CLOTHING CO',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16),
//                               ),
//                               Text('A/C No : 5020093825147'),
//                               Text('IFSC      : HDFC0000445'),
//                               Text('HDFC BANK, TIRUPPUR'),
//                               SizedBox(height: 20),
//                               Center(
//                                 child: Image(
//                                   height: 120,
//                                   width: 120,
//                                   image: AssetImage("images/gpay_qr.PNG"),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('Close'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: Center(
//                     child: Text(
//                       "Account  Details",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 15.0),
//               child: GestureDetector(
//                 onTap: () {
//                   _launchWhatsApp(
//                       '917539912802'); // Replace with correct number
//                 },
//                 child: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage("assets/whatsapp.jpg"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
