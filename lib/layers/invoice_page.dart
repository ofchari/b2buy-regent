import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:b2buy/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import '../pdf_invoice.dart';
import '../universalkey.dart';

String apiKey = "3c966af1562b29d"; //3pin
String apiKey1 = nrg_api_Key; //nrg
//String apiSecret = "04004ec744768d0"; //3pin not use
String apiSecret = "d3948302cc8874c"; //3pin
String apiSecret1 = nrg_api_secret; //nrg
String documentIdNo = ""; //3pin
String coreBuyer = universal_customer; //3pin

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update party name in Frappe',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const listview_page(),
    );
  }
}

class listview_page extends StatelessWidget {
  const listview_page({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update party name')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Select a document'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InvoiceListScreen()),
            );
          },
        ),
      ),
    );
  }
}

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({Key key}) : super(key: key);

  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  DateTime selectedDate;
  List<String> filteredDocumentIds = [];
  List<String> _documentIds = [];
  String searchQuery = '';

  void filterDocuments(String searchQuery) {
    setState(() {
      if (searchQuery.isEmpty) {
        // If the search query is empty, show all documents
        filteredDocumentIds = List.from(_documentIds);
      } else {
        // Filter based on the search query
        filteredDocumentIds = _documentIds
            .where((docId) =>
                docId.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredDocumentIds =
          List.from(_documentIds); // Initially, show all documents
      _init(); // Call the async init function to load the documents
    });
  }

  Future<void> _init() async {
    await _getUserProfile(); // Load user profile first
    await Future.delayed(
        const Duration(microseconds: 1500)); // Ensure a slight delay
    _getUserProfile(); // Fetch user profile again (as per your existing logic)
    await _loadDocumentIds(); // Fetch document IDs and display them
  }

  Future<void> _loadDocumentIds() async {
    try {
      final documentIds = await getDocumentIds(); // Fetch document IDs
      setState(() {
        _documentIds = documentIds; // Store document IDs
        filteredDocumentIds =
            List.from(_documentIds); // Show all documents initially
      });
    } catch (e) {
      print(e); // Handle any errors
    }
  }

  Future<List<String>> getDocumentIds() async {
    // Your existing implementation for fetching document IDs
    const doctype = 'Flutter Mobile';
    if (loginuser != 'mytherayan') {
      final url =
          '$http_key://$core_url/api/resource/Invoice?fields=[%22name%22,%22buyer%22]&limit_page_length=50000&filters=[["buyer","=","$coreBuyer"]]';
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(client);
      try {
        final response = await ioClient.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'token $apiKey1:$apiSecret1',
            'Content-Type': 'application/json'
          },
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List<String> documentIds =
              List<String>.from(data['data'].map((doc) => doc['name']));
          return documentIds;
        } else {
          throw Exception('Failed to load document IDs');
        }
      } catch (e) {
        throw Exception('Failed to load document IDs: $e');
      }
    } else if (loginuser == 'mytherayan') {
      final url =
          '$http_key://$core_url/api/resource/Invoice?fields=[%22name%22,%22buyer%22]&limit_page_length=50000';
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(client);
      try {
        final response = await ioClient.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'token $apiKey1:$apiSecret1',
            'Content-Type': 'application/json'
          },
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List<String> documentIds =
              List<String>.from(data['data'].map((doc) => doc['name']));
          return documentIds;
        } else {
          throw Exception('Failed to load document IDs');
        }
      } catch (e) {
        throw Exception('Failed to load document IDs: $e');
      }
    }
  }

  Future<List> getDocument(String documentId) async {
    const doctype = 'Invoice';
    final url = '$http_key://$core_url/api/resource/$doctype/$documentId';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    try {
      final response = await ioClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token $apiKey1:$apiSecret1',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final partyName = data['data']['buyer'];
        final workflowState = data['data']['status'];
        final date = data['data']['date'];
        final psno = data['data']['ps_no1'];
        final totalBox = data['data']['total_qty'];
        final grandTotal = data['data']['grand_total'];
        final lrdates = data['data']['lr_date'];
        final lrno = data['data']['lr_no'];
        print(lrno);
        print(lrno);
        print(lrno);
        print(lrno);
        print(lrno);
        return [
          partyName,
          workflowState,
          date,
          psno,
          totalBox,
          grandTotal,
          lrno,
          lrdates
        ];
      } else {
        throw Exception('Failed to load document');
      }
    } catch (e) {
      throw Exception('Failed to load document: $e');
    }
  }

  Future<void> _getUserProfile() async {
    final adopturl =
        '$http_key://$core_url/api/method/regent.sales.client.user_management?user=$loginuser';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody != null &&
            responseBody["message"] != null &&
            responseBody["message"].isNotEmpty) {
          // Safeguard to ensure the correct data is available
          setState(() {
            var buyerName = responseBody["message"][0]["universal_customer"] ??
                'Unknown Buyer';
            coreBuyer = buyerName;
          });
        } else {
          print('Unexpected response structure: $responseBody');
        }
      } else {
        print('Failed to load invoice data: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load document IDs: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      filteredDocumentIds =
          List.from(_documentIds); // Show all documents when coming back
    });
  }

  void fetchAllDocuments() async {
    final documentIds = await getDocumentIds();

    setState(() {
      _documentIds = documentIds;
      filteredDocumentIds =
          List.from(_documentIds); // Show all documents initially
    });
  }

  void filterdate(DateTime selectedDate) async {
    final filteredIds = <String>[];

    for (String docId in _documentIds) {
      final document = await getDocument(docId); // Fetch the document data
      final docDateStr =
          document[2]; // Assuming date is at index 2 in yyyy-mm-dd format
      final docDate = DateTime.parse(docDateStr); // Parse the document date

      if (docDate.year == selectedDate.year &&
          docDate.month == selectedDate.month &&
          docDate.day == selectedDate.day) {
        filteredIds.add(docId);
      }
    }

    setState(() {
      filteredDocumentIds = filteredIds.isNotEmpty ? filteredIds : [];
    });
  }

  /// Date picker logic
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      filterdate(selectedDate); // Filter documents by the selected date
    }
  }

// Search filter function
//   void filterDocuments(String searchQuery) {
//     setState(() {
//       if (searchQuery.isEmpty) {
//         // If the search query is empty, show all documents
//         filteredDocumentIds = List.from(_documentIds);
//       } else {
//         // Filter based on the search query
//         filteredDocumentIds = _documentIds
//             .where((docId) =>
//                 docId.toLowerCase().contains(searchQuery.toLowerCase()))
//             .toList();
//       }
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        title: Text(
          "Invoice",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        ),
      ),
      backgroundColor: Colors.white,
      body: _documentIds.isEmpty
          ? const Center(child: Text('No Record\'s Found'))
          : Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(15),
                            labelText: "Search Invoice",
                            labelStyle: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onChanged: (value) {
                            searchQuery = value; // Update search query
                            filterDocuments(
                                searchQuery); // Filter based on search
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20, right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _selectDate(context); // Trigger date picker
                        },
                        child: Container(
                            height: 40,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: filteredDocumentIds.isEmpty
                      ? const Center(
                          child: Text('No data for the selected date'))
                      : ListView.builder(
                          itemCount: filteredDocumentIds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: FutureBuilder(
                                future: getDocument(filteredDocumentIds[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final partyName = snapshot.data[0];
                                    final workflowState = snapshot.data[1];
                                    final date = snapshot.data[2];
                                    final psno = snapshot.data[3];
                                    final totalBox = snapshot.data[4];
                                    final grandTotal = snapshot.data[5];
                                    final lrno = snapshot.data[6];
                                    final lrdates = snapshot.data[7];
                                    print(lrno);
                                    print(lrno);
                                    print(lrno);
                                    print(lrno);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12.0,
                                          top: 8.0,
                                          bottom: 8.0),
                                      child: Card(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: 250,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 0.5)),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 15),
                                              Text(
                                                filteredDocumentIds[index],
                                                style: GoogleFonts.outfit(
                                                  textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  '   Party: $partyName',
                                                  style: GoogleFonts.dmSans(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 13,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Date : ",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          15.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            Text(
                                                              '${date.split('-')[2]}-${date.split('-')[1]}-${date.split('-')[0]}',
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Pack NO : ",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          15.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            Text(
                                                              "  $psno",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          14.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 13,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Total Box : ",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          15.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            Text(
                                                              "$totalBox",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          14.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Bill Value : ",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          15.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            Text(
                                                              "  Rs.$grandTotal",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          14.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 13,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "LR date : ",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          15.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            Text(
                                                              "$lrdates",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          14.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "LR:NO : ",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          15.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            Text(
                                                              "$lrno",
                                                              style: GoogleFonts.dmSans(
                                                                  textStyle: const TextStyle(
                                                                      fontSize:
                                                                          14.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 23,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  // Pop the current screen if needed
                                                  Navigator.of(context).pop();

                                                  // Set the documentIdNo to the selected value (optional)
                                                  documentIdNo =
                                                      filteredDocumentIds[
                                                          index];

                                                  // Navigate to the PdfInvoice screen and pass the name
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PdfInvoice(
                                                        name: filteredDocumentIds[
                                                            index], // Pass the name here
                                                      ),
                                                    ),
                                                  );

                                                  if (kDebugMode) {
                                                    print(partyName);
                                                  }
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 320,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black87,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Center(
                                                    child: Text(
                                                      "View ",
                                                      style: GoogleFonts.outfit(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white)),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                      child: Text(
                                        'Failed to load party name',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    );
                                  } else {
                                    return const Center();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Future<String> _showPartyNameDialog(BuildContext context) async {
    String partyName;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter party name'),
          content: TextField(
            onChanged: (value) => partyName = value,
            decoration: const InputDecoration(hintText: 'Party name'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );

    return partyName;
  }
}

// Future<void> updatePartyName(String documentId, String partyName) async {
//   final doctype = 'Flutter Mobile';
//   final url = '$http_key://$core_url/api/resource/$doctype/$documentId';
//   HttpClient client = new HttpClient();
//   client.badCertificateCallback =
//       ((X509Certificate cert, String host, int port) => true);
//   IOClient ioClient = new IOClient(client);
//   try {
//     final response = await ioClient.put(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'token $apiKey1:$apiSecret1',
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode({'buyer': partyName}),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print(data);
//     } else {
//       throw Exception('Failed to update party name');
//     }
//   } catch (e) {
//     throw Exception('Failed to update party name: $e');
//   }
// }

/*




// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       home: MyMainWidget(),
//       // home: MyMainWidget(),
//     );
//   }
// }

//
// String apiKey = "7cbf607bc7e6184"; // yaanee
// String apiSecret = "bbce3ba695e127f"; // yaanee
String apiKey1 = "3c966af1562b29d"; //3pin
String apiKey = "631d1cad61d47fc"; //nrg
String apiSecret1 = "d3948302cc8874c"; //3pin
String apiSecret = "6a4d3d6082236c6"; //nrg
String doctype = "Invoice";
String url = "http://$core_url";*/

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key key}) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  Map<String, dynamic> invoiceData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/resource/Invoice/$documentIdNo';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token $apiKey1:$apiSecret1',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          invoiceData = json.decode(response.body)["data"];
        });
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

  Future<void> _downloadPDF() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    // Construct the API endpoint URL
    final url =
        // 'http://erp.yaaneefashions.com/api/method/frappe.utils.print_format.download_pdf?doctype=Order Form&name=FM-23-24-00007';
        '$http_key://$core_url/api/method/frappe.utils.print_format.download_pdf?doctype=Invoice&name=$documentIdNo&format=TAX%20INVOICES&no_letterhead=1&letterhead=No%20Letterhead&settings=%7B%7D&_lang=en';

    // Create HTTP headers
    final headers = {
      'Authorization': 'token $nrg_api_Key:$nrg_api_secret',
    };

    // Send an HTTP POST request to the API endpoint
    final response = await ioClient.post(Uri.parse(url), headers: headers);

    // Check the response code to make sure it was successful
    if (response.statusCode == 200) {
      // Write the response body to a file with the .pdf extension
      final dir = await getExternalStorageDirectory();
      // final file = File('/storage/emulated/0/Documents/FM-23-24-00007.pdf');
      final file = File('/storage/emulated/0/Download/$documentIdNo.pdf');
      await file.writeAsBytes(response.bodyBytes);
      // await file.readAsBytes(response.body);

      print(await file.writeAsBytes(response.bodyBytes));
    } else {
      print(response.reasonPhrase);
      throw Exception('Failed to download PDF: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        title: Text(
          'Invoice Details',
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.black,
              ),
              onTap: () async {
                try {
                  await _downloadPDF();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => PDFDownloader()),
                  // );

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PDF downloaded')));
                } catch (e) {
                  if (ScaffoldMessenger.of(context).mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Failed to download PDF')));
                  }
                  print(e);
                }
              },
            ),
          ),
        ],
      ),
      body: invoiceData == null
          ? const Center(child: CircularProgressIndicator())
          : buildInvoiceDetails(),
    );
  }

  Widget buildInvoiceDetails() {
    List<String> dateParts = invoiceData["date"].split('-');
    String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    String lrformattedDate = '';
    if (invoiceData["lr_date"] != null) {
      List<String> lrdateParts = invoiceData["lr_date"].split('-');
      lrformattedDate = '${lrdateParts[2]}-${lrdateParts[1]}-${lrdateParts[0]}';
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Invoice Number: $documentIdNo',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'Invoiced Date: $formattedDate',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LR NO: ${invoiceData['lr_no'] ?? ''}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'LR Date: ${lrformattedDate ?? ''}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (invoiceData['lr_attach'] != null)
              Image(
                  image: NetworkImage(
                      "http://$core_url/${invoiceData['lr_attach']}")),
            if (invoiceData['lr_attach'] != null) const SizedBox(height: 16),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            /*    Container(
              height: 380,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildItemList(invoiceData["details"]),
                ),
              ),
            ),*/
            SizedBox(
              height: 380,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    invoiceData["details"].length,
                    (index) {
                      dynamic item = invoiceData["details"][index];
                      Color tileColor =
                          index.isOdd ? Colors.white : Colors.orange.shade50;

                      return Container(
                        // color: tileColor,
                        child: ListTile(
                          title: Text(item["product"]),
                          subtitle: Text(
                            'Size: ${item["size"]}, Quantity: ${item["qty"]}, Amount: ₹${item["amount"]}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Center(
              child: Icon(
                Icons.arrow_downward_outlined,
                color: Colors.black,
                size: 20.0,
              ),
            ),
            const Text(
              'Tax Details:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: buildtaxList(invoiceData["tax_details"]),
              ),
            ),
            const Text(
              'Other Charges & Discount:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              // color: Colors.blue,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: buildocList(invoiceData["oc_details"]),
              ),
            ),
            SizedBox(
              // color: Colors.blue,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Discount: ₹${invoiceData["total_cash_dis_amt"]}',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.right,
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),
            Center(
              child: Text(
                'Total Amount: ₹${invoiceData["grand_total"]}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List<Widget> buildItemList(List<dynamic> items) {
  //   return items.map((item) {
  //     return ListTile(
  //       title: Text(item["product"]),
  //       subtitle: Text(
  //           'Size: ${item["size"]}, Quantity: ${item["qty"]}, Amount: \₹${item["amount"]}'),
  //     );
  //   }).toList();
  // }

  List<Widget> buildtaxList(List<dynamic> items) {
    return items.map((item) {
      return Text(
          '${item["gst_per"]}    ${item["rate"]}     ₹${item["amount"]}');
    }).toList();
  }

  List<Widget> buildocList(List<dynamic> items) {
    return items.map((item) {
      return Text('${item["oc_name"]}  ₹${item["amount"]}');
    }).toList();
  }
}
