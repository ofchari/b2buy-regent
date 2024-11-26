import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';

import '../main.dart';
import '../universalkey.dart';

class pendingagent extends StatefulWidget {
  const pendingagent({Key key}) : super(key: key);

  @override
  State<pendingagent> createState() => _PendOrdAgentList();
}

class _PendOrdAgentList extends State<pendingagent> {
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
        '$http_key://$core_url/api/method/regent.regent.flutter.get_api_admin_order_form_details',
    ];
    if (loginuser != 'admin') {
      print(
          '$http_key://$core_url/api/method/regent.regent.flutter.get_api_agent_order_form_details?name=$universal_customer');
    }
    if (loginuser == 'admin') {
      print(
          '$http_key://$core_url/api/method/regent.regent.flutter.get_api_admin_order_form_details');
    }
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
              return SizedBox(
                height: 800,
                width: 400,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: CustomerList.length,
                    itemBuilder: (BuildContext context, int index) {
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
