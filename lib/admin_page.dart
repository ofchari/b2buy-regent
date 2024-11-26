import 'dart:convert';
import 'dart:io';

import 'package:b2buy/layers/product_page.dart';
import 'package:b2buy/universalkey.dart';
import 'package:b2buy/user_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';

import 'admin_agent_view.dart';
import 'agent_list.dart';
import 'customer_list.dart';
import 'customer_list_2.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

class adm extends StatefulWidget {
  const adm({Key key}) : super(key: key);

  @override
  State<adm> createState() => _admState();
}

class _admState extends State<adm> {
  var size, height, width;
  var OrderCountData = '';
  var AgentCountData = '';
  var CustomerCountData = '';
  var PendingOrderCountData = '';
  String product_count = '';

  List<dynamic> AgentListData = [];

  @override
  void initState() {
    super.initState();
    OrderCount();
    PendingOrderCount();
    AgentList();
    AgentCount();
    CustomerCount();
    _getProductCount();
  }

  Future<void> _getProductCount() async {
    final adopturl =
        '$http_key://$core_url/api/resource/Product?fields=["count(name)"]&filters=[["is_inactive","=","0"]]';

    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(client);
      final response = await ioClient.get(
        Uri.parse(adopturl),
        // ,"item_size.size" &filters=[["name","like","%gym%20vest%"]]
        headers: {
          'Authorization': 'token $nrg_api_Key:$nrg_api_secret',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["data"];
        if (responseData.isNotEmpty) {
          setState(() {
            product_count = (responseData[0]["count(name)"]).toString();
            print(product_count);
          });
        } else {
          print('Response data is empty');
          print('271');
        }
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

  Future<void> overallLoder() async {
    await Future.delayed(const Duration(microseconds: 1000));
    OrderCount();
    PendingOrderCount();
    AgentList();
    AgentCount();
    CustomerCount();
    _getProductCount();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> AgentCount() async {
    final adopturl =
        '$http_key://$core_url/api/resource/Agent?fields=["count(name)"]';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          AgentCountData =
              (json.decode(response.body)["data"][0]["count(name)"]).toString();
          print(AgentCountData);

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

  Future<void> CustomerCount() async {
    final adopturl =
        '$http_key://$core_url/api/resource/Customer?fields=["count(name)"]';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          CustomerCountData =
              (json.decode(response.body)["data"][0]["count(name)"]).toString();
          print(CustomerCountData);

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

  Future<void> OrderCount() async {
    final adopturl =
        '$http_key://$core_url/api/resource/Order%20Form?fields=["count(name)"]';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          OrderCountData =
              (json.decode(response.body)["data"][0]["count(name)"]).toString();
          print(OrderCountData);

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

  Future<void> PendingOrderCount() async {
    final adopturl =
        '$http_key://$core_url/api/resource/Order%20Form?fields=["count(name)"]&filters=[["workflow_state","=","Pending"]]';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          PendingOrderCountData =
              (json.decode(response.body)["data"][0]["count(name)"]).toString();
          print(PendingOrderCountData);

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

  Future<void> AgentList() async {
    final adopturl = '$http_key://$core_url/api/resource/Agent';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          final data = json.decode(response.body)["data"];
          AgentListData = List<dynamic>.from(data.map((x) => x["name"]));
          print(AgentListData);
        });
      } else {
        // Handle error
        print('Failed to load agent data');
      }
    } catch (e) {
      throw Exception('Failed to load agent data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorslist = [
      Colors.lime.shade300,
      Colors.blue.shade200,
      // Colors.green,
      Colors.grey.shade300,
      // Colors.brown,
      Colors.black26,
    ];
    List<String> a = [...AgentListData];

    List<String> b = [
      "₹5,200",
      "₹4,800",
      "₹3,200",
      "₹6,600",
      "₹6,600",
    ];
    List<String> alle = [
      "Order Count",
      "Pending Order",
      "Customers",
      "Products",
    ];
    List<IconData> iconslist = [
      Icons.border_all_rounded,
      Icons.border_color_outlined,
      CupertinoIcons.person_2,
      Icons.production_quantity_limits
    ];
    List caros = [
      "https://rukminim2.flixcart.com/image/850/1000/xif0q/t-shirt/t/m/3/xl-ds27-ngu-blue-printed-black-diolsan-original-imagrg73urg9sjsm.jpeg?q=20&crop=false",
      "https://prabhubhakti.in/wp-content/uploads/2023/01/Stylish-OM-Trishul-with-Third-Eye-men-t-shirt.jpg",
      "https://rukminim2.flixcart.com/image/850/1000/xif0q/t-shirt/g/q/f/l-8702993541-metronaut-original-imagtqyzxptmzrvb.jpeg?q=90&crop=false",
      "https://static-01.daraz.pk/p/ad4bd2874be2a13dd8c51827d3b7ef60.jpg",
      "https://mellmon.in/wp-content/uploads/2021/12/orange.jpg",
      "https://www.teez.in/cdn/shop/products/LarsenAndToubroT-ShirtForMen_3_1024x1024.jpg?v=1601705944"
    ];

    // List<String> route = [
    //   "/ce",
    //   "/pe",
    //   "/cuu",
    //   "/pro",
    // ];
    //
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return RefreshIndicator(
      onRefresh: overallLoder,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white24,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Admin",
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserProfilePage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.logout,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: height / 6,
                            width: width / 2.2,
                            decoration: BoxDecoration(
                              color: Colors.lime.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 35.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: height / 18,
                                            width: width / 9,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green),
                                            child: const Icon(
                                              Icons.border_all_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Order Count ",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.9,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                Text(
                                  OrderCountData,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const pendingagent()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: height / 6,
                                width: width / 2.2,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 35.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: height / 18,
                                                width: width / 9,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green),
                                                child: const Icon(
                                                  Icons.border_color_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Pending " "Order ",
                                                  style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.9,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Text(
                                      PendingOrderCountData,
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const custo()));
                            },
                            child: Container(
                              height: height / 6,
                              width: width / 2.2,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 35.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              height: height / 18,
                                              width: width / 9,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green),
                                              child: const Icon(
                                                CupertinoIcons.person_2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Customer ",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.9,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const product_page()));
                              },
                              child: Container(
                                height: height / 6,
                                width: width / 2.2,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 35.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: height / 18,
                                                  width: width / 9,
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green),
                                                  child: const Icon(
                                                    Icons
                                                        .production_quantity_limits_sharp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 14.0),
                                                  child: Text(
                                                    "product",
                                                    style: GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 14.9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ]),
                                        )),
                                    Text(
                                      " $product_count",
                                      style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomerListScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: height / 6,
                              width: width / 2.2,
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: height / 18,
                                                width: width / 9,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green),
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30.0),
                                                child: Text(
                                                  "Buyer",
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 14.9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black)),
                                                ),
                                              ),
                                            ]),
                                      )),
                                  Text(
                                    CustomerCountData,
                                    style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AgentListScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: height / 6,
                                  width: width / 2.2,
                                  decoration: BoxDecoration(
                                    color: Colors.pinkAccent.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    height: height / 18,
                                                    width: width / 9,
                                                    decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green),
                                                    child: const Icon(
                                                      Icons
                                                          .shopping_bag_outlined,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 30.0),
                                                    child: Text(
                                                      "Agent",
                                                      style: GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14.9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black)),
                                                    ),
                                                  ),
                                                ]),
                                          )),
                                      Text(
                                        AgentCountData,
                                        style: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 730.0, left: 100.0),
            //   child: Container(
            //     height: height / 16,
            //     width: width / 2,
            //     decoration: BoxDecoration(
            //         color: Colors.black45,
            //         borderRadius: BorderRadius.circular(12)),
            //     child: Center(
            //       child: Text(
            //         "Cart",
            //         style: GoogleFonts.poppins(
            //             textStyle: TextStyle(
            //                 color: Colors.yellow,
            //                 fontSize: 15,
            //                 fontWeight: FontWeight.w500)),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
