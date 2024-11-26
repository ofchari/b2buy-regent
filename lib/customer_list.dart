import 'dart:convert';
import 'dart:io';

import 'package:b2buy/universalkey.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key key}) : super(key: key);

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<String> CustomerListData = [];

  Future<void> fetchCustomerList() async {
    final String adoptUrl = '$http_key://$core_url/api/resource/Customer';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adoptUrl),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          final data = json.decode(response.body)["data"];
          CustomerListData =
              List<String>.from(data.map((x) => x["name"] as String));
        });
      } else {
        // Handle error
        print('Failed to load Customer data');
      }
    } catch (e) {
      throw Exception('Failed to load Customer data: $e');
    } finally {
      ioClient.close();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        )),
        centerTitle: true,
        title: Text(
          'Customer List',
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        ),
        backgroundColor: Colors.black12,
      ),
      body: ListView.builder(
        itemCount: CustomerListData.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                title: Text(
                  CustomerListData[index],
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.brown.shade400,
                ),
                onTap: () {
                  // Handle fabric selection
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (context) => HomePage(),
                  // ));
                  print('Selected ${CustomerListData[index]}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
