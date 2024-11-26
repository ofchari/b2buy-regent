import 'dart:convert';
import 'dart:io';

import 'package:b2buy/update_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../universalkey.dart';

String documentIdNo = "";

class PendOrdAgentList extends StatefulWidget {
  const PendOrdAgentList({Key key}) : super(key: key);

  @override
  State<PendOrdAgentList> createState() => _PendOrdAgentList();
}

class _PendOrdAgentList extends State<PendOrdAgentList> {
  @override
  void initState() {
    super.initState();
    fetchPartyData();
  }

  List<Map<String, dynamic>> CustomerList;
  Future<List<Map<String, dynamic>>> fetchPartyData() async {
    CustomerList = [];
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    final urls = [
      if (loginuser != null && loginuser.isNotEmpty)
        '$http_key://$core_url/api/method/regent.regent.flutter.get_api_agent_order_form_details?name=$universal_customer',
    ];

    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    final requests = urls.map((url) async {
      final response = await ioClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token $nrg_api_Key:$nrg_api_secret',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["message"];
        if (responseData is List) {
          CustomerList.addAll(responseData.cast<Map<String, dynamic>>());
        }
        print(CustomerList);
        print(CustomerList.length);
        return CustomerList;
      } else {
        throw Exception('Failed to load data from $url');
      }
    });
    final results = await Future.wait(requests);

    // Combine the results from all the API requests into a single list
    return results.expand((result) => result).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        )),
        backgroundColor: Colors.black12,
        title: Center(
            child: Text(
          "Pending Orders",
          style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        )),
      ),
      body: FutureBuilder(
          future: fetchPartyData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CustomerList = snapshot.data;
              /*    final partyName = snapshot.data[1][1];
              final order_form = snapshot.data[2][1];
              final workflow_state = snapshot.data[3][1];
              final date = '';
              final total_box = '';
              final grand_total = '';
              final remarks =
                  '';*/ /*
              final date = snapshot.data[2];
              final total_box = snapshot.data[3];
              final grand_total = snapshot.data[4];
              final remarks = snapshot.data[5];*/
              /*Container indicator;
              if (workflow_state == "Approved") {
                indicator = Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.green[800],
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  padding: EdgeInsets.all(4),
                  child: Text(
                    "Approved",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    )),
                  ),
                );
              } else if (workflow_state == "Rejected") {
                indicator = Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.red[800],
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  padding: EdgeInsets.all(4),
                  child: Text(
                    "Rejected",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    )),
                  ),
                );
              } else {
                indicator = Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.orange[
                  //       800], // Use orange for pending
                  //   borderRadius: BorderRadius.circular(100),
                  // ),
                  padding: EdgeInsets.all(4),
                  child: Text(
                    "pending",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[800],
                    )),
                  ),
                );
              }*/
              return SizedBox(
                  height: 800,
                  width: 400,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: CustomerList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (CustomerList[index]['order_form'] != null) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Container(
                                  height: 200,
                                  // height: MediaQuery.of(context).size.height *
                                  // 0.03,
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '     ',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Colors.orange[800],
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                            CustomerList[index]['order_form'],
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 16)),
                                          ),
                                          Row(
                                            children: [
                                              if (CustomerList[index]
                                                      ['remarks'] !=
                                                  null)
                                                Icon(
                                                  Icons
                                                      .notifications_active_outlined,
                                                  color: Colors.red.shade300,
                                                ),
                                              const Text("    ")
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Party :",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Text(
                                                CustomerList[index]['customer'],
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Date :",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Text(
                                                /*'${date.split('-')[2]}-${date.split('-')[1]}-${date
                                .split('-')[0]}'*/
                                                '',
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Total Box :",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Text(
                                                (0.23).toString().split('.')[0],
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Bill Value:",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Text(
                                                "Rs.${CustomerList[index]['grand_total']}",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Status :",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Text(CustomerList[index]
                                                  ['workflow_state'])
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          // MyMainWidget
                                          Navigator.of(context).pop();
                                          documentIdNo =
                                              CustomerList[index]['order_form'];
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Agent_Order_Fullpage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 220,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              "View ",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )));
                        }
                      }));
              /*CustomerList = snapshot.data;
              return Container(
                height: 800,
                width: 400,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: CustomerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (CustomerList[index]['order_form'] != null) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              title: Text(
                                CustomerList[index]['order_form'].toString(),
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    "${CustomerList[index]['customer']}",
                                    style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue)),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "${CustomerList[index]['workflow_state']}",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red.shade900)),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              );*/
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

String apiKey1 = "3c966af1562b29d"; //3pin
String apiKey = nrg_api_Key; //nrg
String apiSecret1 = "d3948302cc8874c"; //3pin
String apiSecret = nrg_api_secret; //nrg
String doctype = "Order form";
String url = "$http_key://$core_url";

class Agent_Order_Fullpage extends StatefulWidget {
  const Agent_Order_Fullpage({Key key}) : super(key: key);

  @override
  _Agent_Order_FullpageState createState() => _Agent_Order_FullpageState();
}

class _Agent_Order_FullpageState extends State<Agent_Order_Fullpage> {
  List<Map<String, dynamic>> _dataList = [];

  var myint = 5;
  final String _imageUrl = '';
  final String _partnerName = '';
  final url = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Order Form'));
  final String _party = '';
  var qtyController = '';

  final bool _isImageVisible = false;
  List<String> _sizes = [];
  final Map<String, double> qtyMap = {};

  // Map of size values and their corresponding text field controllers
  final sizeControllers = <String, TextEditingController>{};
  final apiUrl =
      '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size';

  String data7 = '';
  String data8 = '';
  double data9 = 0;
  int data10 = 0;
  double data11 = 0;
  String data5 = '';
  String dataremark = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(
      Uri.parse('$http_key://$core_url/api/resource/Order Form/$documentIdNo'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );
    final data = json.decode(response.body)['data'];

    setState(() {
      data5 = json.decode(response.body)['data']['buyer'];
      data7 = json.decode(response.body)['data']['name'];
      data8 = json.decode(response.body)['data']['total_qty'];
      data9 = json.decode(response.body)['data']['total_box'];
      data10 = json.decode(response.body)['data']['total_amount'];
      data11 = json.decode(response.body)['data']['grand_total'];
      dataremark = json.decode(response.body)['data']['remarks'];
      _dataList = List<Map<String, dynamic>>.from(data['details']);
    });
    print(json.decode(response.body)['data']['buyer']);
    print(json.decode(response.body)['data']['name']);
  }

  Future<void> _downloadPDF() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    // Construct the API endpoint URL
    final url =
        // 'http://erp.yaaneefashions.com/api/method/frappe.utils.print_format.download_pdf?doctype=Order Form&name=FM-23-24-00007';
        '$http_key://$core_url/api/method/frappe.utils.print_format.download_pdf?doctype=Order Form&name=$documentIdNo&format=Order%20Form&no_letterhead=0&settings=%7B%7D&_lang=en';

    // Create HTTP headers
    final headers = {
      'Authorization': 'token $apiKey:$apiSecret',
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PendOrdAgentList()),
        ); // Call the function you want to navigate to
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            backgroundColor: Colors.grey.shade300,
            centerTitle: true,
            title: Text(data7,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                      fontWeight:
                          FontWeight.w500 // Set the font size to 12 pixels
                      ),
                )),
            // centerTitle: true,
            actions: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _downloadPDF();
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .grey.shade300, // Set the background color to orange 200
                ),
                child: const Icon(
                  Icons.print,
                  color: Colors.black,
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      if (_isImageVisible)
                        const SizedBox(
                          height: 150,
                        ),

                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        data5,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      _dataList.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : MyListView(dataList: _dataList),
                      //Text( 'Total Amount: ${_amount1 + _amount2 + _amount3}', style: TextStyle(fontSize: 20), ),
                      SizedBox(
                        height: 2,
                        child: Container(
                          color: Colors.black,
                          height: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Box\'s:$data9',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Grand Total :₹ $data11',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (dataremark != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(dataremark,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red.shade200)),
                        )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                //return CircularProgressIndicator();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchDatasize() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    if (_partnerName == null || _partnerName.isEmpty) {
      return;
    }

    // Build the API endpoint URL with the partner name as a query parameter
    final url = '$apiUrl?name=$_partnerName';

    // Create an HTTP client with the necessary certificates

    // Make the API request
    final response = await ioClient.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );

    // Parse the API response
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["message"];

      // Update the text field controllers for each size returned by the API
      data.forEach((item) {
        final size = item["size"];
        final stock = item["stock"].toString();
        if (!sizeControllers.containsKey(size)) {
          sizeControllers[size] = TextEditingController();
        }
        sizeControllers[size]?.text = stock;
        print(size);
        print(stock);
      });

      // Update the list of sizes and rebuild the UI with the updated text field values
      setState(() {
        _sizes = sizeControllers.keys.toList();
      });
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  Future<List<dynamic>> fetchData() async {
    final urls = [
      // "http://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_stock_style",
      "$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_data",
      '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_party',
      // '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_party?party=$loginuser',
      if (_partnerName != null && _partnerName.isNotEmpty)
        '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size?name=$_partnerName',
    ];
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    final requests = urls.map((url) async {
      if (url.contains('get_flutter_size')) {
        final response = await ioClient.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'token $apiKey:$apiSecret',
          },
        );
        if (response.statusCode == 200) {
          return json.decode(response.body)["message"];
        } else {
          throw Exception('Failed to load data from $url');
        }
      } else if (url.contains('get_flutter_party')) {
        final response = await ioClient.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'token $apiKey:$apiSecret',
          },
        );
        if (response.statusCode == 200) {
          return json.decode(response.body)["message"];
        } else {
          throw Exception('Failed to load data from $url');
        }
      } else {
        final response = await ioClient.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'token $apiKey:$apiSecret',
            'Content-Type': 'application/json'
          },
          body: json.encode({}),
        );
        if (response.statusCode == 200) {
          return json.decode(response.body)["message"];
        } else {
          throw Exception('Failed to load data from $url');
        }
      }
    });
    final results = await Future.wait(requests);

    // Combine the results from all the API requests into a single list
    return results.expand((result) => result).toList();
  }

  Future<void> updateFlutterMobileDocument() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final credentials = '$apiKey:$apiSecret';
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-Type': 'application/json',
    };

    // Set up the data to update the existing document in the Order form DocType
    final data = {
      // 'party': _party,
      // 'person': _partnerName,
      'details': _dataList
    };

    final body = jsonEncode(data);

    final url = '$http_key://$core_url/api/resource/Order Form/$documentIdNo';
    final response =
        await ioClient.put(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PendOrdAgentList()),
      );
    } else if (response.statusCode == 417) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Plz Check The stock'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      print(response.body);
      print(json.decode(response.body)['exc_type']);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Request failed with status: ${response.statusCode}'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      print(response.body);
      print(response.toString());
    }
  }
}
