import 'dart:convert';
import 'dart:io';

import 'package:b2buy/layers/product_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';

import '../main.dart';
import '../universalkey.dart';

String PreDefinedCustomerName = '';

class custo extends StatefulWidget {
  const custo({Key key}) : super(key: key);

  @override
  State<custo> createState() => _custoState();
}

class _custoState extends State<custo> {
  // @override
  // void initState() {
  //   super.initState();
  //   fetchPartyData();
  // }

  List<Map<String, dynamic>> CustomerList;
  Future<List<Map<String, dynamic>>> fetchPartyData() async {
    CustomerList = [];
    final urls = [
      if (loginuser != null && loginuser.isNotEmpty)

          '$http_key://$core_url/api/method/regent.regent.flutter.get_api_admin_outstanding_details',
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
        backgroundColor: Colors.black12,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            )),
        title: Center(
            child: Text(
              "Customer",
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
              return SizedBox(
                height: 800,
                width: 400,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: CustomerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            print(CustomerList[index]['customer'].toString());
                            setState(() {
                              PreDefinedCustomerName =
                                  CustomerList[index]['customer'].toString();
                            });
                            if (loginuser != 'admin') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const product_page()));
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Colors.grey.shade200,
                            child: ListTile(
                              title: Text(
                                CustomerList[index]['customer'].toString(),
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueAccent)),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    "Outstanding :",
                                    style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),
                                  Text(
                                    "₹${CustomerList[index]['out_standing']}",
                                    style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "${CustomerList[index]['agent']}",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.brown)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
