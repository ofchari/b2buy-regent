import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';

import '../main.dart';
import '../universalkey.dart';

class AgentOutStandingReport extends StatefulWidget {
  const AgentOutStandingReport({Key key}) : super(key: key);

  @override
  State<AgentOutStandingReport> createState() => _AgentOutStandingReport();
}

class _AgentOutStandingReport extends State<AgentOutStandingReport> {
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
        '$http_key://$core_url/api/method/regent.regent.flutter.get_api_agent_agentwise_report?name=$universal_customer',
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
          "Commission Report",
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
                          child: ListTile(
                            title: Text(
                              CustomerList[index]['buyer'].toString(),
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${(CustomerList[index]['date']).split('-')[2]}/${(CustomerList[index]['date']).split('-')[1]}/${(CustomerList[index]['date']).split('-')[0]}",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ),
                                Text(
                                  "₹${CustomerList[index]['grand_total']}",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ),
                                Text(
                                  "${CustomerList[index]['com_per']}%",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                            trailing: Text(
                              "₹${CustomerList[index]['commission_amt']}",
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green)),
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
