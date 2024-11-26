import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:b2buy/layers/cart_details.dart';

import 'package:path_provider/path_provider.dart';
import 'package:b2buy/home_page.dart';
import 'package:b2buy/main.dart';
import '../universalkey.dart';
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
String apiKey = nrg_api_Key; //nrg
String apiSecret1 = "d3948302cc8874c"; //3pin
String apiSecret = nrg_api_secret; //nrg
String doctype = "Order form";
String url = "$http_key://$core_url";

class PreMyListView extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;

  const PreMyListView({Key key, this.dataList}) : super(key: key);

  @override
  _PreMyListViewState createState() => _PreMyListViewState();
}

class _PreMyListViewState extends State<PreMyListView> {
  List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dataList.length,
      (index) => TextEditingController(
        text: '${widget.dataList[index]['qty']}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 450, // Set the height to a fixed value
        child: ListView.builder(
          itemCount: widget.dataList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text('    ${index + 1}.'),
              title: Text(widget.dataList[index]['product']),
              subtitle: Text(
                'Size: ${widget.dataList[index]['size']} Box: ${widget.dataList[index]['box_qty']}  Qty: ${widget.dataList[index]['qty']} Rate: ${widget.dataList[index]['rate']} ',
              ),
              /*   trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  */ /*GestureDetector(
                    child: const Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Update Quantity'),
                          content: TextField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter Quantity',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.orange[
                                      500], // Set the text color to orange 500
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.orange[
                                      500], // Set the text color to orange 500
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  final newQty =
                                      int.tryParse(_controllers[index].text) ??
                                          0;
                                  if (index >= 0 &&
                                      index < _controllers.length) {
                                    widget.dataList[index]['qty'] = newQty;
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),*/ /*

                  */ /*   const SizedBox(width: 10),
                  GestureDetector(
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        widget.dataList.removeAt(index);
                      });
                    },
                  ),*/ /*
                ],
              ),*/
            );
          },
        ),
      );
}

class PreMyMainWidget extends StatefulWidget {
  const PreMyMainWidget({Key key}) : super(key: key);

  @override
  _PreMyMainWidgetState createState() => _PreMyMainWidgetState();
}

class _PreMyMainWidgetState extends State<PreMyMainWidget> {
  List<Map<String, dynamic>> _dataList = [];
  String orderForm = 'Order Form';
  var myint = 5;
  final String _imageUrl = '';
  final String _partnerName = '';
  final url = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Order Form'));
  final url_pri = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Pre Order Form'));
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
  String data9 = '';
  String data10 = '';
  String data11 = '';
  String data5 = '';
  String data6 = '';
  String workflow_state = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _getUserProfile();
  }

  String buyer_name = '';
  String email = '';
  String user_name = '';
  Future<void> _getUserProfile() async {
    final adopturl =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
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
        setState(() {
          buyer_name =
              json.decode(response.body)["message"][0]["universal_customer"];
          email = json.decode(response.body)["message"][0]["user_id"];
          user_name = json.decode(response.body)["message"][0]["user_name"];
          print(buyer_name);

          // universal_customer = json.decode(response.body)["message"][0]
          // ["universal_customer"];
        });
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

  Future<void> _loadData() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(
      Uri.parse(
          '$http_key://$core_url/api/resource/Pre Order Form/$documentIdNo'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );
    final data = json.decode(response.body)['data'];

    setState(() {
      data5 = json.decode(response.body)['data']['buyer'];
      data6 = json.decode(response.body)['data']['ref_customer'];
      data7 = json.decode(response.body)['data']['name'];
      data8 = json.decode(response.body)['data']['total_qty'].toString();
      data9 = json.decode(response.body)['data']['total_box'].toString();
      data10 = json.decode(response.body)['data']['total_amount'].toString();
      data11 = json.decode(response.body)['data']['grand_total'].toString();
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
        '$http_key://$core_url/api/method/frappe.utils.print_format.download_pdf?doctype=Pre Order Form&name=$documentIdNo&format=Order%20Form&no_letterhead=0&settings=%7B%7D&_lang=en';

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
    print(buyer_name);
    print(data5);
    print(data7);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PreDocumentListScreen()),
        ); // Call the function you want to navigate to
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFFed6e00),
            title: const Text('Order'),
            centerTitle: true,
            // centerTitle: true,
            actions: [
              if (buyer_name == data5)
                IconButton(
                  icon: const Icon(Icons.verified),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Verification'),
                          /*   content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Colors.red[500], // set the background color
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(
                                  //       20), // set the border radius
                                  // ),
                                ),
                                child: Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  workflow_state = 'Rejected';
                                  updateWorkflowFlutterMobileDocument();
                                  // updateFlutterMobileDocument();
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //       builder: (context) => MyMainWidget()),
                                  // );
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .green[500], // set the background color
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(
                                  //       20), // set the border radius
                                  // ),
                                ),
                                child: Text(
                                  'Approve',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  workflow_state = 'Approved';
                                  updateWorkflowFlutterMobileDocument();
                                  // updateFlutterMobileDocument();
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //       builder: (context) => MyMainWidget()),
                                  // );
                                },
                              ),
                            ],
                          ),*/
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .red[500], // set the background color
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(
                                    //       20), // set the border radius
                                    // ),
                                  ),
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    workflow_state = 'Rejected';
                                    updateWorkflowFlutterMobileDocument();
                                    // updateFlutterMobileDocument();
                                    // Navigator.of(context).pop();
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //       builder: (context) => MyMainWidget()),
                                    // );
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .green[500], // set the background color
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(
                                    //       20), // set the border radius
                                    // ),
                                  ),
                                  child: const Text(
                                    'Approve',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    print(_dataList);

                                    for (var data in _dataList) {
                                      CartItem cartItem = CartItem(
                                        product: data['product'],
                                        qty: data['qty'],
                                        box: data['box_qty'].toInt(),
                                        size: data['size'],
                                        rate: data['rate']
                                            .toString(), // Assuming rate is a String in your CartItem class
                                      );

                                      await CartDatabaseHelper.instance
                                          .insertCartItem(cartItem);
                                    }
                                    workflow_state = 'Approved';
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm'),
                                          content: const Text(
                                              'Are you sure you want to Update?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange[
                                                    500], // set the background color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // set the border radius
                                                ),
                                              ),
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                updateWorkflowFlutterMobileDocument();
                                                Navigator.of(context).pop();
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //       builder: (context) => MyMainWidget()),
                                                // );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    // updateWorkflowFlutterMobileDocument();
                                    // updateFlutterMobileDocument();
                                    // Navigator.of(context).pop();
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //       builder: (context) => MyMainWidget()),
                                    // );
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              IconButton(
                icon: const Icon(Icons.picture_as_pdf),
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
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text('Are you sure you want to Update?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .orange[500], // set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // set the border radius
                              ),
                            ),
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              updateFlutterMobileDocument();
                              Navigator.of(context).pop();
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //       builder: (context) => MyMainWidget()),
                              // );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ]),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isImageVisible)
                        // print('Image should be visible');
                        if (_imageUrl.isNotEmpty)
                          Image.network(
                            _imageUrl,
                            height: 500,
                            width: 550,
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      /* IconButton(
                        icon: _isImageVisible
                            ? Icon(Icons.arrow_drop_up_outlined)
                            : Icon(Icons.drag_handle_sharp),
                        onPressed: () {
                          setState(() {
                            _isImageVisible = !_isImageVisible;
                            print(_isImageVisible);
                          });
                        },
                      ),*/
                      // Container(
                      //   width: 500,
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   child: TypeAheadFormField<String>(
                      //     textFieldConfiguration: TextFieldConfiguration(
                      //       decoration: InputDecoration(
                      //         labelText: 'Party',
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.all(
                      //             Radius.circular(15),
                      //           ),
                      //         ),
                      //         isDense: true,
                      //       ),
                      //       controller: TextEditingController(text: _party),
                      //     ),
                      //     suggestionsCallback: (pattern) async {
                      //       List<String> partyNames = (snapshot.data ?? [])
                      //           .map((item) => item["party"]
                      //               ?.toString()) // Use the safe navigation operator to prevent null exceptions
                      //           .where((party) => party != null)
                      //           .cast<String>()
                      //           .toList();
                      //       partyNames = partyNames
                      //           .where((name) => name
                      //               .toLowerCase()
                      //               .contains(pattern.toLowerCase()))
                      //           .toList();
                      //       print(partyNames); // Add a print statement here
                      //       return partyNames;
                      //     },
                      //     itemBuilder: (context, suggestion) {
                      //       return ListTile(
                      //         title: Text(suggestion),
                      //       );
                      //     },
                      //     onSuggestionSelected: (suggestion) {
                      //       setState(() {
                      //         _party = suggestion;
                      //       });
                      //       final partnerData = (snapshot.data ?? []).firstWhere(
                      //         (item) => item["party"].toString() == suggestion,
                      //         orElse: () => null,
                      //       );
                      //     },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Invoice No : ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (data7 != null && data7.isNotEmpty)
                              Text(
                                data7.split('-')[2],
                                style: const TextStyle(
                                  fontSize:
                                      16.0, // Set the font size to 12 pixels
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Order by     : ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data6.split('-')[0],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              'Shiped to   : ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data5.split('-')[0],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /*const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 500,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: 'Item',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              isDense: true,
                            ),
                            controller: TextEditingController(text: _partnerName),
                          ),
                          suggestionsCallback: (pattern) async {
                            // Filter the partner names based on the input pattern
                            List<String> partnerNames = (snapshot.data ?? [])
                                .map((item) => item["partner_name"]
                                    ?.toString()) // Use the safe navigation operator to prevent null exceptions
                                .where((partner_name) => partner_name != null)
                                .cast<String>()
                                .toList();
                            partnerNames = partnerNames
                                .where((name) => name
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList();
                            print(partnerNames);
                            // Add a print statement here
                            return partnerNames; // Add a print statement here
                            return partnerNames;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              _partnerName = suggestion;
                              fetchDatasize();
                            });
                            final partnerData = (snapshot.data ?? []).firstWhere(
                              (item) =>
                                  item["partner_name"].toString() == suggestion,
                              orElse: () => null,
                            );
                            if (partnerData != null) {
                              final image = partnerData["images"].toString();
                              _imageUrl = image;
                            }
                          },
                        ),
                      ),
                      ..._sizes.map((size) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 111,
                                  height: 35,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      // labelText: 'Size',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    controller: TextEditingController(text: size),
                                    onChanged: (newValue) {
                                      setState(() {
                                        size = newValue;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 111,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Bls: ',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          sizeControllers[size]?.text ?? '',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 111,
                                  height: 35,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      // labelText: 'Qty',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        qtyMap[size] =
                                            double.tryParse(newValue) ?? 0;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                      ElevatedButton(
                        onPressed: () {
                          // Add the entered data to a list
                          _sizes.forEach((size) {
                            var qtyController = sizeControllers[size];
                            var stock = qtyController.text.isNotEmpty
                                ? double.parse(qtyController.text)
                                : 0;
                            var qty = qtyMap[size] ??
                                0; // get qty value after updating qtyMap
                            if (qty != null && qty != 0) {
                              _dataList.add({
                                "item": _partnerName,
                                "qty": qty.round(),
                                "size": size,
                                "stock": stock,
                              });
                            }
                          });
                          print(_dataList);
                          // Clear the text fields
                          setState(() {
                            _sizes = [];
                          });
                          qtyMap.clear();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 15),
                            SizedBox(width: 2),
                            Text(
                              'Add',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange[500],
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        ),
                      ),*/
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(
                        color: Color(0xFFed6e00),
                      ),
                      _dataList.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : PreMyListView(dataList: _dataList),
                      //Text( 'Total Amount: ${_amount1 + _amount2 + _amount3}', style: TextStyle(fontSize: 20), ),
                      const Divider(
                        color: Color(0xFFed6e00),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Qty : $data8',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total Box\'s:$data9',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Text(
                      //   'Total Amount : $data10',
                      //   style: TextStyle(
                      //     color: Colors.black87,
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      /*     Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                          ],
                        ),
                      ),*/
                      Center(
                        child: Text(
                          'Final Value : $data11',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Future<void> updateWorkflowFlutterMobileDocument() async {
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
      // 'details': _dataList
      'workflow_state': workflow_state
    };

    final body = jsonEncode(data);

    final url =
        '$http_key://$core_url/api/resource/Pre Order Form/$documentIdNo';
    final response =
        await ioClient.put(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PreDocumentListScreen()),
      );
    } else if (response.statusCode == 417) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Plz Contact admin the your auth is Locked'),
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

    final url =
        '$http_key://$core_url/api/resource/Pre Order Form/$documentIdNo';
    final response =
        await ioClient.put(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PreDocumentListScreen()),
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
