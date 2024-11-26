import 'dart:convert';

import 'package:b2buy/pdf_order.dart';
import 'package:flutter/material.dart';
import 'package:b2buy/layers/pre_approval_page.dart';
import 'package:b2buy/main.dart';
import 'package:b2buy/update_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'universalkey.dart';
import 'package:b2buy/buyer_page.dart';

// String orderID = Order_name;  ,["ref_customer","=","$Order_name"]
String orderApiID = Order_apifilter;
String apiKey = "3c966af1562b29d"; //3pin
// String apiKey1 = "631d1cad61d47fc"; //nrg
String apiKey1 = nrg_api_Key; //nrg
//String apiSecret = "04004ec744768d0"; //3pin not use
String apiSecret = "d3948302cc8874c"; //3pin
// String apiSecret1 = "6a4d3d6082236c6"; //nrg
String apiSecret1 = nrg_api_secret; //nrg
String documentIdNo = ""; //3pin

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
                  builder: (context) => const DocumentListScreen()),
            );
          },
        ),
      ),
    );
  }
}

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({Key key}) : super(key: key);

  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  List<String> _documentIds = [];
  List<String> filteredDocumentIds = [];
  String selectedStatusFilter = "All"; // Track the selected status filter

  // TextEditingController to capture the search input
  TextEditingController searchController = TextEditingController();

  // Filter logic based on search term and selected status
  void _filterDocuments(String searchTerm) {
    setState(() {
      filteredDocumentIds = _documentIds.where((documentId) {
        // Apply search filter
        return documentId.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  // Status-based filter logic
  bool _applyStatusFilter(String workflowState) {
    if (selectedStatusFilter == "All") {
      return true; // No filter applied if "All" is selected
    }
    return workflowState == selectedStatusFilter;
  }

  @override
  void initState() {
    super.initState();
    _loadDocumentIds();
  }

  Future<void> _loadDocumentIds() async {
    try {
      final documentIds = await getDocumentIds('Order Form');
      setState(() {
        _documentIds = documentIds;
        filteredDocumentIds = documentIds;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const buyerdashboard()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Center(
            child: Text(
              "Orders",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
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
                          padding: EdgeInsets.only(left: 10.0, right: 20.0),
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Search Orders",
                              labelStyle: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            onChanged: (value) {
                              _filterDocuments(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20, right: 10.0),
                        child: Container(
                          height: 43,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.white,
                              size: 22,
                            ),
                            onSelected: (String value) {
                              setState(() {
                                selectedStatusFilter = value;
                                _filterDocuments(searchController.text);
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                  value: "All",
                                  child: Text("All"),
                                ),
                                const PopupMenuItem(
                                  value: "Approved",
                                  child: Text("Approved"),
                                ),
                                const PopupMenuItem(
                                  value: "Rejected",
                                  child: Text("Rejected"),
                                ),
                                const PopupMenuItem(
                                  value: "Pending",
                                  child: Text("Pending"),
                                ),
                              ];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDocumentIds.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                          future: getDocument(
                              'Order Form', filteredDocumentIds[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final partyName = snapshot.data[0];
                              final workflowState = snapshot.data[1];
                              final date = snapshot.data[2];
                              final totalBox = snapshot.data[3];
                              final grandTotal = snapshot.data[4];
                              final remarks = snapshot.data[5];

                              // Apply status filter
                              if (!_applyStatusFilter(workflowState)) {
                                return Container(); // Skip if the status doesn't match the filter
                              }

                              // Status indicator logic
                              Container indicator;
                              if (workflowState == "Approved") {
                                indicator = Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "Approved",
                                    style: GoogleFonts.dmSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (workflowState == "Rejected") {
                                indicator = Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "Rejected",
                                    style: GoogleFonts.dmSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                indicator = Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "Pending",
                                    style: GoogleFonts.dmSans(
                                      textStyle: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Container(
                                    height: 210,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 0.5)),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ' ${filteredDocumentIds[index]}',
                                              style: GoogleFonts.outfit(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if (remarks != null)
                                              Icon(
                                                Icons
                                                    .notifications_active_outlined,
                                                color: Colors.red.shade300,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        _buildInfoRow("Party  : ", partyName),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildInfoRow(
                                              "Date : ",
                                              '${date.split('-')[2]}-${date.split('-')[1]}-${date.split('-')[0]}',
                                            ),
                                            _buildInfoRow(
                                              "Total Box : ",
                                              totalBox.toString().split('.')[0],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            _buildInfoRow("Bill Value : ",
                                                "Rs.$grandTotal"),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.0),
                                              child: Text(
                                                "Status  : ",
                                                style: GoogleFonts.dmSans(
                                                  textStyle: const TextStyle(
                                                    fontSize: 15.2,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20.0),
                                              child: indicator,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            documentIdNo =
                                                filteredDocumentIds[index];
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PdfViewerPage(
                                                        name: documentIdNo),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 320,
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "View",
                                                style: GoogleFonts.outfit(
                                                  textStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
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
                                child: Text("Failed to load data"),
                              );
                            } else {
                              return const Center();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Helper method to build rows for Party/Date/Total Box/Bill Value
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              textStyle: const TextStyle(
                fontSize: 15.2,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(
            value,
            style: GoogleFonts.dmSans(
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
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

class PreDocumentListScreen extends StatefulWidget {
  const PreDocumentListScreen({Key key}) : super(key: key);

  @override
  _PreDocumentListScreenState createState() => _PreDocumentListScreenState();
}

class _PreDocumentListScreenState extends State<PreDocumentListScreen> {
  List<String> _documentIds = [];

  @override
  void initState() {
    super.initState();
    _loadDocumentIds();
  }

  Future<void> _loadDocumentIds() async {
    try {
      final documentIds = await getDocumentIds('Pre Order Form');
      setState(() {
        _documentIds = documentIds;
      });
    } catch (e) {
      print(e);
    }
  }

  String _searchQuery = '';
  final int _currentIndex = 0;
  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final filteredDocumentIds = _documentIds
        .where(
            (docId) => docId.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),

          // backgroundColor: Colors.orange[200],
          backgroundColor: const Color(0xFFed6e00),
          title: Container(
            height: height / 19,
            width: width / 1,
            decoration: BoxDecoration(
                border: Border.all(
              color: const Color(0xFFed6e00),
            )),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search document IDs',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        // bottomNavigationBar: SalomonBottomBar(
        //   backgroundColor: Colors.transparent,
        //   currentIndex: _currentIndex,
        //   // selectedItemColor: Colors.orange[500],
        //   // unselectedItemColor: Colors.orange[500],
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
        //
        //         break;
        //       case 2:
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => UserProfilePage()),
        //         );
        //         break;
        //     }
        //   },
        //   items: [
        //     SalomonBottomBarItem(
        //       icon: Icon(Icons.home),
        //       title: Text("Home"),
        //       // selectedColor: Colors.black,
        //       // selectedColor: Colors.orange[500],
        //     ),
        //     SalomonBottomBarItem(
        //       icon: Icon(Icons.document_scanner_outlined),
        //       title: Text("Report"),
        //       // selectedColor: Colors.orange[500],
        //       // selectedColor: Colors.orange[500],
        //     ),
        //     // SalomonBottomBarItem(
        //     //   icon: Icon(Icons.person_2_outlined),
        //     //   title: Text("Report"),
        //     //   selectedColor: Colors.white,
        //     // ),
        //   ],
        // ),
        backgroundColor: Colors.grey.shade300,
        body: _documentIds.isEmpty
            ? const Center(child: Text('No Record\'s Found'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDocumentIds.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // color:
                          //     index % 2 == 0 ? Colors.orange[50] : Colors.white,
                          child: FutureBuilder(
                            future: getDocument(
                                'Pre Order Form', filteredDocumentIds[index]),
                            builder: (context, snapshot) {
                              // print(orderApiID);
                              // print(Order_apifilter.split(',')[3]);
                              // print(snapshot.data[0]);
                              // print(snapshot.data[0]);
                              // print(snapshot.data[0]);
                              // print(snapshot.data[0]);
                              if (snapshot.hasData) {
                                if (snapshot.data[0] == snapshot.data[0]) {
                                  final partyName = snapshot.data[0];
                                  final workflowState = snapshot.data[1];
                                  Container indicator;

                                  if (workflowState == "Approved") {
                                    indicator = Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green[800],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Text("Approved"),
                                    );
                                  } else if (workflowState == "Rejected") {
                                    indicator = Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red[800],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                    );
                                  } else {
                                    indicator = Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange[
                                            800], // Use orange for pending
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 2.0,
                                        bottom: 1.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // height: MediaQuery.of(context).size.height *
                                        // 0.03,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,

                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListTile(
                                          /*  leading: CircleAvatar(
                                          child: Text('N'),
                                        ),*/
                                          title: Text(
                                            filteredDocumentIds[index],
                                            // style: TextStyle(color: Colors.orange[800]),
                                          ),
                                          subtitle: Text(
                                            partyName,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          trailing: SizedBox(
                                            width: 10,
                                            height: 10,
                                            child: indicator,
                                          ),
                                          onTap: () async {
                                            // MyMainWidget
                                            Navigator.of(context).pop();
                                            documentIdNo =
                                                filteredDocumentIds[index];
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PreMyMainWidget(),
                                              ),
                                            );
                                            print(partyName);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => MainPage()),
        //     );
        //   },
        //   // backgroundColor: Colors.orange[500],
        //   child: Icon(
        //     Icons.add,
        //   ),
        // ),
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

Future<List> getDocument(String doctype, String documentId) async {
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
      final workflowState = data['data']['workflow_state'];
      final date = data['data']['date'];
      final totalBox = data['data']['total_box'];
      final grandTotal = data['data']['grand_total'];
      final remarks = data['data']['remarks'];
      return [partyName, workflowState, date, totalBox, grandTotal, remarks];
      // final workflow_state = data['data']['workflow_state'];
      // return workflow_state;
    } else {
      throw Exception('Failed to load document');
    }
  } catch (e) {
    throw Exception('Failed to load document: $e');
  }
}

Future<List<String>> getDocumentIds(String doctypes) async {
  print(Order_name);
  print(Order_apifilter.replaceAll("'", '"'));
  const doctype = 'Flutter Mobile';
  if (loginuser != 'mytherayan') {
    final url =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/resource/$doctypes?fields=[%22name%22,%22buyer%22]&filters=[${Order_apifilter.replaceAll("'", '"')}]&limit_page_length=50000&order_by=name%20desc';
    // &filters=[[%22person%22,%22=%22,%22$loginuser%22]]
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
  if (loginuser == 'mytherayan') {
    final url =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/resource/$doctypes?fields=[%22name%22,%22buyer%22]&limit_page_length=50000';
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
