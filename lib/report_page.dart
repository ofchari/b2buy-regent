// import 'dart:convert';
// import 'dart:io';
// import 'package:http/io_client.dart';
// import 'package:b2buy/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
//
// class reportScreen extends StatefulWidget {
//   @override
//   _reportScreenState createState() => _reportScreenState();
// }
//
// class _reportScreenState extends State<reportScreen> {
//   int _currentIndex = 1;
//   List<dynamic> _data = [];
//
//   DateTime _fromDate = DateTime.now();
//   DateTime _toDate = DateTime.now();
//   TextEditingController _fromDateController;
//   TextEditingController _toDateController;
//
//   Future<List<dynamic>> _getReportData() async {
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback =
//         ((X509Certificate cert, String host, int port) => true);
//     IOClient ioClient = new IOClient(client);
//     final response = await ioClient.post(
//       Uri.parse(
//           'https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_mobile_report'),
//       headers: {
//         'Authorization': 'token $apiKey:$apiSecret',
//       },
//       body: jsonEncode({
//         'from_date': _fromDate.toString(),
//         'to_date': _toDate.toString(),
//       }),
//     );
//     if (response.statusCode == 200) {
//       var result = jsonDecode(response.body);
//
//       if (result['message'] != null) {
//         setState(() {
//           _data = result['message'];
//         });
//         return _data;
//       }
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//     return [];
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fromDateController =
//         TextEditingController(text: _fromDate.toString().substring(0, 10));
//     _toDateController =
//         TextEditingController(text: _toDate.toString().substring(0, 10));
//     _getReportData();
//   }
//
//   @override
//   void dispose() {
//     _fromDateController.dispose();
//     _toDateController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text("Report"),
//       ),
//       bottomNavigationBar: SalomonBottomBar(
//         backgroundColor: Colors.blue[300],
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white,
//         margin: EdgeInsets.only(bottom: 5, top: 5, right: 20, left: 20),
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//
//           // Navigate to a new page based on the index
//           switch (index) {
//             case 0:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DocumentListScreen()),
//               );
//               break;
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => reportScreen()),
//               );
//               break;
//           }
//         },
//         items: [
//           SalomonBottomBarItem(
//             icon: Icon(Icons.home),
//             title: Text("Home"),
//             selectedColor: Colors.white,
//           ),
//           SalomonBottomBarItem(
//             icon: Icon(Icons.document_scanner_outlined),
//             title: Text("Report"),
//             selectedColor: Colors.white,
//           ),
//         ],
//       ),
//       body: _data.isNotEmpty
//           ? Column(
//               children: [
//                 Expanded(
//                     child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: SingleChildScrollView(
//                           child: DataTable(
//                             headingRowColor: MaterialStateColor.resolveWith(
//                                 (states) => Colors.lightBlueAccent),
//                             dataRowColor: MaterialStateColor.resolveWith(
//                                 (states) => Colors.white),
//                             columnSpacing: 10.0,
//                             columns: [
//                               DataColumn(label: Text('name')),
//                               DataColumn(label: Text('Date')),
//                               DataColumn(label: Text('Party')),
//                               DataColumn(label: Text('SalesPerson')),
//                               DataColumn(label: Text('Item')),
//                               DataColumn(label: Text('Size')),
//                               DataColumn(label: Text('Qty')),
//                               DataColumn(label: Text('Rate')),
//                               DataColumn(label: Text('Amount')),
//                             ],
//                             rows: _data
//                                 .map(
//                                   (item) => DataRow(cells: [
//                                     DataCell(Text(item['name'] ?? '')),
//
//                                     DataCell(Text(item['date'] ?? '')),
//                                     DataCell(Text(item['party'] ?? '')),
//                                     DataCell(Text(item['person'] ?? '')),
//                                     DataCell(Text(item['item'] ?? '')),
//                                     DataCell(Text(item['size'] ?? '')),
//                                     DataCell(Text(item['qty'] ?? '')),
//                                     DataCell(Text(item['rate'] ?? '')),
//                                     DataCell(Text(item['amount'] ?? '')),
//                                     // DataCell(Text(item['name'] ?? '')),
//                                   ]),
//                                 )
//                                 .toList(),
//                           ),
//                           scrollDirection: Axis.horizontal,
//                         ))),
//               ],
//             )
//           : Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
/*
import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:b2buy/home_page.dart';
import 'package:b2buy/main.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'universalkey.dart';
import 'package:b2buy/buyer_page.dart';
// String apiKey = "3c966af1562b29d"; //3pin
// //String apiSecret = "04004ec744768d0"; //3pin not use
// String apiSecret = "d3948302cc8874c"; //3pin

String apiKey1 = "3c966af1562b29d"; //3pin
String apiKey = nrg_api_Key; //nrg
String apiSecret1 = "d3948302cc8874c"; //3pin
String apiSecret = nrg_api_secret; //nrg

class reportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<reportScreen> {
  int _currentIndex = 1;
  List<dynamic> _data = [];
  DateTime _fromDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _partyFilter = '';
  String _itemFilter = '';
  String _party = '';
  String _item = '';

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              // primary: Colors.orange[500],
              // onPrimary: Colors.orange[50],
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              // primary: Colors.orange[500],
              // onPrimary: Colors.orange[50],
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  Future<List<dynamic>> _getReportData() async {
    print(order_report);
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);
    final response = await ioClient.post(
      Uri.parse(
          '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_mobile_report?buyer=$Order_name&stype=$order_report"'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      // print(jsonDecode(response.body));
      if (result['message'] != null) {
        // print(result['message']);
        setState(() {
          _data = result['message'];
        });
        return _data;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return [];
  }

  void _filterByDate() {
    setState(() {
      _data = _data.where((item) {
        DateTime date = DateTime.parse(item['date']);
        bool isAfterOrEqual = _fromDate == null ||
            date.isAfter(_fromDate) ||
            date.isAtSameMomentAs(_fromDate);
        bool isBeforeOrEqual = _toDate == null ||
            date.isBefore(_toDate) ||
            date.isAtSameMomentAs(_toDate);
        return isAfterOrEqual && isBeforeOrEqual;
      }).toList();
      if (_partyFilter.isNotEmpty) {
        _data = _data
            .where((item) => item['party']
                .toLowerCase()
                .contains(_partyFilter.toLowerCase()))
            .toList();
      }

      if (_itemFilter.isNotEmpty) {
        _data = _data
            .where((item) =>
                item['item'].toLowerCase().contains(_itemFilter.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getReportData();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _data.where((item) {
      final itemDate = DateTime.parse(item['date']);
      return itemDate.isAfter(_fromDate.subtract(Duration(days: 1))) &&
          itemDate.isBefore(_toDate.add(Duration(days: 1)));
    }).toList();
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.orange[200],
        title: Text(
          "Report",
          style: TextStyle(
            color: Colors.white, // Set the text color to orange 500
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        // selectedItemColor: Colors.orange[500],
        // unselectedItemColor: Colors.orange[500],
        margin: EdgeInsets.only(bottom: 5, top: 5, right: 20, left: 20),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to a new page based on the index
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DocumentListScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => reportScreen()),
              );
              break;
          }
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            // selectedColor: Colors.orange[500],
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            title: Text("Report"),
            // selectedColor: Colors.orange[500],
          ),
        ],
      ),
      body: _data.isNotEmpty
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _selectFromDate(context),
                      child: Text(
                        "Select From Date",
                        // style: TextStyle(
                        //   color: Colors
                        //       .orange[500], // Set the text color to orange 500
                        // ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectToDate(context),
                      child: Text(
                        "Select To Date",
                        // style: TextStyle(
                        //   color: Colors
                        //       .orange[500], // Set the text color to orange 500
                        // ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      child: DataTable(
                        // headingRowColor: MaterialStateColor.resolveWith(
                        //     (states) => Colors.orange[100]),
                        // dataRowColor: MaterialStateColor.resolveWith(
                        //     (states) => Colors.white),
                        columnSpacing: 10.0,
                        columns: [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Party')),
                          // DataColumn(label: Text('SalesPerson')),
                          DataColumn(label: Text('Item')),
                          DataColumn(label: Text('Size')),
                          DataColumn(label: Text('Qty')),
                          DataColumn(label: Text('Rate')),
                          DataColumn(label: Text('Amount')),
                        ],
                        rows: filteredData
                            .asMap()
                            .entries
                            .map(
                              (entry) => DataRow(
                                color: MaterialStateColor.resolveWith(
                                  (states) => entry.key % 2 == 0
                                      ? Colors.white
                                      // ? Colors.orange[50]
                                      : Colors.white,
                                ),
                                cells: [
                                  DataCell(Text(
                                      entry.value['name'].toString() ?? '')),
                                  DataCell(Text(
                                      entry.value['daet'].toString() ?? '')),
                                  DataCell(Text(
                                      entry.value['party'].toString() ?? '')),
                                  // DataCell(Text(entry.value['person'] ?? '')),
                                  DataCell(Text(
                                      entry.value['item'].toString() ?? '')),
                                  DataCell(Text(
                                      entry.value['size'].toString() ?? '')),
                                  DataCell(Text(
                                      entry.value['qty'].toString() ?? '')),
                                  DataCell(Text(
                                      entry.value['rate'].toString() ?? '')),
                                  DataCell(Text(
                                      entry.value['amount'].toString() ?? '')),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'universalkey.dart';
import 'package:b2buy/buyer_page.dart';

String apiKey1 = "3c966af1562b29d"; //3pin
String apiKey = nrg_api_Key; //nrg
String apiSecret1 = "d3948302cc8874c"; //3pin
String apiSecret = nrg_api_secret; //nrg

class reportScreen extends StatefulWidget {
  const reportScreen({Key key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<reportScreen> {
  final int _currentIndex = 1;
  // List<dynamic> _data = [];
  List<Map<String, dynamic>> _data = [];
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  final String _partyFilter = '';
  final String _itemFilter = '';
  final String _party = '';
  final String _item = '';

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }
/*

  Future<List<dynamic>> _getReportData() async {
    print(order_report);
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);
    final response = await ioClient.post(
      Uri.parse(
          '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_mobile_report?buyer=$Order_name&stype=$order_report"'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['message'] != null) {
        setState(() {
          _data = result['message'];
        });
        return _data;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return [];
  }
*/

  Future<List<Map<String, dynamic>>> _getReportData() async {
    print(order_report);
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.post(
      Uri.parse(
          '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_mobile_report?buyer=$Order_name&stype=$order_report"'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['message'] != null) {
        // Make sure to cast the data to the correct type
        List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(result['message']);
        setState(() {
          _data = fetchedData;
          yourData = fetchedData;
        });
        return fetchedData;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _getReportData();
  }

  @override
  Widget build(BuildContext context) {
    print(_data);
    final filteredData = _data.where((item) {
      final itemDate = DateTime.parse(item['date']);
      return itemDate.isAfter(_fromDate.subtract(const Duration(days: 1))) &&
          itemDate.isBefore(_toDate.add(const Duration(days: 1)));
    }).toList();

    void clearFilters() {
      setState(() {
        selectedParty = null;
        selectedItem = null;
        selectedSize = null;
      });
      _controller.add(filteredData);
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const buyerdashboard()),
        ); // Call the function you want to navigate to
        return false; // Prevent default back navigation
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            )),
            title: const Text(
              "Report",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          // bottomNavigationBar: SalomonBottomBar(
          //   backgroundColor: Colors.white,
          //   currentIndex: _currentIndex,
          //   margin: EdgeInsets.only(bottom: 5, top: 5, right: 20, left: 20),
          //   onTap: (index) {
          //     setState(() {
          //       _currentIndex = index;
          //     });
          //
          //     // Navigate to a new page based on the index
          //     switch (index) {
          //       case 0:
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(builder: (context) => DocumentListScreen()),
          //         );
          //         break;
          //       case 1:
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(builder: (context) => reportScreen()),
          //         );
          //         break;
          //     }
          //   },
          //   items: [
          //     SalomonBottomBarItem(
          //       icon: Icon(Icons.home),
          //       title: Text("Home"),
          //     ),
          //     SalomonBottomBarItem(
          //       icon: Icon(Icons.document_scanner_outlined),
          //       title: Text("Report"),
          //     ),
          //   ],
          // ),
          // body: _data.isNotEmpty
          body: yourData.isNotEmpty
              ? /*SfDataGrid(
                source: _MyDataSource(_data),
                columns: [
                  GridColumn(columnName: 'name', label: Text('Name')),
                  GridColumn(columnName: 'date', label: Text('Date')),
                  GridColumn(
                      columnName: 'daet', label: Text('Daet'), visible: false),
                  GridColumn(columnName: 'party', label: Text('Party')),
                  GridColumn(columnName: 'item', label: Text('Item')),
                  GridColumn(columnName: 'size', label: Text('Size')),
                  GridColumn(columnName: 'qty', label: Text('Qty')),
                  GridColumn(columnName: 'rate', label: Text('Rate')),
                  GridColumn(columnName: 'amount', label: Text('Amount')),
                ],
                // gridLinesVisibility: GridLinesVisibility.vertical,
                // allowSorting: true,
                // allowMultiColumnSorting: true,
                // allowTriStateSorting: true,
                // columnSizer: ColumnSizer(),
              )*/
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('  Party    :    '),
                        DropdownButton<String>(
                          value: selectedParty,
                          hint: const Text("Select Party"),
                          onChanged: _selectParty,
                          items: [
                            // '', // Empty string for removing the filter
                            ...yourData
                                .map((entry) => entry['party'].toString())
                                .toSet()
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('  Item     :    '),
                        DropdownButton<String>(
                          value: selectedItem,
                          hint: const Text("Select Item"),
                          onChanged: _selectItem,
                          items: [
                            // '', // Empty string for removing the filter
                            ...yourData
                                .map((entry) => entry['item'].toString())
                                .toSet()
                                .map((String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('  Size      :    '),
                            DropdownButton<String>(
                              value: selectedSize,
                              hint: const Text("Select Size"),
                              onChanged: _selectSize,
                              items: [
                                // '', // Empty string for removing the filter
                                ...yourData
                                    .map((entry) => entry['size'].toString())
                                    .toSet()
                                    .map((String value) =>
                                        DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue[500], // set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // set the border radius
                              ),
                            ),
                            onPressed: clearFilters,
                            child: const Text('Clear'),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _controller.stream,
                        initialData: filteredData,
                        builder: (context, snapshot) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 10.0,
                                columns: const [
                                  DataColumn(label: Text('Name')),
                                  DataColumn(
                                      label: Text(
                                          'Date')), // Replace with your actual columns
                                  DataColumn(label: Text('Party')),
                                  DataColumn(label: Text('Item')),
                                  DataColumn(label: Text('Size')),
                                  DataColumn(label: Text('Qty')),
                                  DataColumn(label: Text('Rate')),
                                  DataColumn(label: Text('Amount')),
                                ],
                                rows: snapshot.data
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => DataRow(
                                        color: MaterialStateColor.resolveWith(
                                          (states) => entry.key % 2 == 0
                                              ? Colors.white
                                              : Colors.white,
                                        ),
                                        cells: [
                                          _buildDataCell(
                                              entry.value['name'].toString() ??
                                                  ''),
                                          _buildDataCell(
                                              entry.value['date'].toString() ??
                                                  ''),
                                          _buildDataCell(
                                              entry.value['party'].toString() ??
                                                  ''),
                                          _buildDataCell(
                                              entry.value['item'].toString() ??
                                                  ''),
                                          _buildDataCell(
                                              entry.value['size'].toString() ??
                                                  ''),
                                          _buildDataCell(
                                              entry.value['qty'].toString() ??
                                                  ''),
                                          _buildDataCell(
                                              entry.value['rate'].toString() ??
                                                  ''),
                                          _buildDataCell(entry.value['amount']
                                                  .toString() ??
                                              ''),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              /*Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _selectFromDate(context),
                        child: Text(
                          "Select From Date",
                          // style: TextStyle(
                          //   color: Colors
                          //       .orange[500], // Set the text color to orange 500
                          // ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _selectToDate(context),
                        child: Text(
                          "Select To Date",
                          // style: TextStyle(
                          //   color: Colors
                          //       .orange[500], // Set the text color to orange 500
                          // ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        child: DataTable(
                          // headingRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.orange[100]),
                          // dataRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.white),
                          columnSpacing: 10.0,
                          columns: [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Party')),
                            // DataColumn(label: Text('SalesPerson')),
                            DataColumn(label: Text('Item')),
                            DataColumn(label: Text('Size')),
                            DataColumn(label: Text('Qty')),
                            DataColumn(label: Text('Rate')),
                            DataColumn(label: Text('Amount')),
                          ],
                          rows: filteredData
                              .asMap()
                              .entries
                              .map(
                                (entry) => DataRow(
                                  color: MaterialStateColor.resolveWith(
                                    (states) => entry.key % 2 == 0
                                        ? Colors.white
                                        // ? Colors.orange[50]
                                        : Colors.white,
                                  ),
                                  cells: [
                                    DataCell(Text(
                                        entry.value['name'].toString() ?? '')),
                                    DataCell(Text(
                                        entry.value['daet'].toString() ?? '')),
                                    DataCell(Text(
                                        entry.value['party'].toString() ?? '')),
                                    // DataCell(Text(entry.value['person'] ?? '')),
                                    DataCell(Text(
                                        entry.value['item'].toString() ?? '')),
                                    DataCell(Text(
                                        entry.value['size'].toString() ?? '')),
                                    DataCell(Text(
                                        entry.value['qty'].toString() ?? '')),
                                    DataCell(Text(
                                        entry.value['rate'].toString() ?? '')),
                                    DataCell(Text(
                                        entry.value['amount'].toString() ?? '')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ],
              )*/
              : const Center(child: Text('No Record\'s Found'))),
    );
  }

  String selectedParty;
  String selectedItem;
  String selectedSize;

  List<Map<String, dynamic>> yourData = []; // Replace with your actual data
  final StreamController<List<Map<String, dynamic>>> _controller =
      StreamController<List<Map<String, dynamic>>>();

  List<Map<String, dynamic>> get filteredData {
    List<Map<String, dynamic>> result = yourData;

    if (selectedParty != null && selectedParty.isNotEmpty) {
      result =
          result.where((entry) => entry['party'] == selectedParty).toList();
    }

    if (selectedItem != null && selectedItem.isNotEmpty) {
      result = result.where((entry) => entry['item'] == selectedItem).toList();
    }

    if (selectedSize != null && selectedSize.isNotEmpty) {
      result = result.where((entry) => entry['size'] == selectedSize).toList();
    }

    return result;
  }

  void _selectParty(String value) {
    setState(() {
      selectedParty = value;
    });
    _controller.add(filteredData);
  }

  void _selectItem(String value) {
    setState(() {
      selectedItem = value;
    });
    _controller.add(filteredData);
  }

  void _selectSize(String value) {
    setState(() {
      selectedSize = value;
    });
    _controller.add(filteredData);
  }

  DataCell _buildDataCell(String text) {
    return DataCell(
      GestureDetector(
        onTap: () {
          // Handle the click action, you can implement filtering logic here if needed
          print('Clicked on $text');
        },
        child: Text(text),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class _MyDataSource extends DataGridSource {
  final List<Map<String, dynamic>> _data;

  _MyDataSource(this._data);

  @override
  List<DataGridRow> get rows => _data
      .map((e) => DataGridRow(
          cells: e.entries
              .map<DataGridCell>((entry) => DataGridCell<dynamic>(
                  columnName: entry.key, value: entry.value))
              .toList()))
      .toList();

  // Implement buildRow as required by DataGridSource
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    print(_data);
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(e.value.toString()),
        );
      }).toList(),
    );
  }
}
