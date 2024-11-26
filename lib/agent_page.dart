import 'dart:convert';
import 'dart:io';

import 'package:b2buy/main.dart';
import 'package:b2buy/universalkey.dart';
import 'package:b2buy/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import 'About_drawer.dart';
import 'agent_commission_report.dart';
import 'agent_view_pending_order_list.dart';
import 'customer_order_registration.dart';
import 'layers/cart_details.dart';
import 'layers/customer_list_page.dart';
import 'layers/product_page.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

class sale extends StatefulWidget {
  const sale({Key key}) : super(key: key);

  @override
  State<sale> createState() => _saleState();
}

class _saleState extends State<sale> {
  var size, height, width;
  String product_count = '';
  var AgentOutstandingData = '';
  var PendingOrderData = '';
  @override
  void initState() {
    super.initState();
    _getProductCount();
    AgentOutstanding();
    PendingOrderCount();
    fetchPartyData();
    _loadCartCount();
    _getcompanyData();
  }

  Future<void> AgentOutstanding() async {
    print(universal_customer);
    final adopturl =
        '$http_key://$core_url/api/method/regent.regent.flutter.get_api_agent_agent_outstanding_details?name=$universal_customer';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {
          'Authorization': 'token $nrg_api_Key:$nrg_api_secret',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          AgentOutstandingData = (json.decode(response.body)["message"][0]
                  ["out_standing"])
              .toString();
          print(AgentOutstandingData);

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
    print(universal_customer);
    final adopturl =
        '$http_key://$core_url/api/method/regent.regent.flutter.get_api_agent_count_of_order_form?name=$universal_customer';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl),
        headers: {
          'Authorization': 'token $nrg_api_Key:$nrg_api_secret',
        },
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          PendingOrderData =
              (json.decode(response.body)["message"][0]["count"]).toString();
          print(PendingOrderData);

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

  List<Map<String, dynamic>> CustomerCountList;
  Future<List<Map<String, dynamic>>> fetchPartyData() async {
    List<Map<String, dynamic>> CustomerCountList = [];
    final urls = [
      if (loginuser != null && loginuser.isNotEmpty)
        '$http_key://$core_url/api/method/regent.regent.flutter.cart_customer_list?parent=$universal_customer',
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
          CustomerCountList.addAll(responseData.cast<Map<String, dynamic>>());
        }
        print(CustomerCountList);
        print(CustomerCountList.length);
        return responseData;
      } else {
        throw Exception('Failed to load data from $url');
      }
    });
    final results = await Future.wait(requests);

    // Combine the results from all the API requests into a single list
    return results.expand((result) => result).toList();
  }

  int totalCartQty = 0;
  final totalCartCount = TextEditingController();
  Future<void> _loadCartCount() async {
    List<CartItemQty> cartItems =
        (await CartDatabaseHelper.instance.getQtyCountCartItems())
            .cast<CartItemQty>();
    setState(() {
      totalCartQty = 0;
      for (CartItemQty item in cartItems) {
        totalCartQty += item.qty;
      }
      print("Total Quantity: $totalCartQty");
      totalCartCount.text = totalCartQty.toString();
    });
  }

  String email = '';
  String user_name = '';
  String about_us = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _getcompanyData() async {
    final adopturl =
        '$http_key://$core_url/api/resource/Company?fields=["custom_about_us"]';

    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = IOClient(client);
      final response = await ioClient.get(
        Uri.parse(adopturl),
        // ,"item_size.size" &filters=[["name","like","%gym%20vest%"]]
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["data"];
        if (responseData.isNotEmpty) {
          setState(() {
            about_us = (responseData[0]["custom_about_us"]).toString();
            print(about_us);
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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(
        email: email,
        user_name: user_name,
        about_us: about_us,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*   GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfilePage()));
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ),*/
                  IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      )),
                  Center(
                    child: Text(
                      "   Sales",
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Stack(children: [
                    IconButton(
                      icon: Stack(
                        children: [
                          const Icon(
                            Iconsax.shopping_bag,
                            size: 30,
                            color: Colors.black,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 1.0),
                              child: Text(
                                totalCartCount.text,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                    ),
                    /* Positioned(
                      // top: 0.5, // Adjust the top position as needed
                      left: 15, // Adjust the right position as needed
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(50),
                            // color: Colors.redAccent
                            ),
                        child: Text(
                          totalCartCount.text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),*/
                  ]),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            GestureDetector(
              onTap: () {
                // Get.to(repo());
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => repo()));
                //
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AgentOutStandingReport()));
              },
              child: Container(
                height: height / 7.2,
                width: width / 1.1,
                decoration: const BoxDecoration(
                    // gradient: LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomCenter,
                    //     colors: [
                    //       Colors.black,
                    //       Colors.black45,
                    //     ]),
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, top: 8.0, bottom: 1),
                        child: Text(
                          "Outstanding Amount ",
                          style: GoogleFonts.notoSans(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, bottom: 12.0),
                        child: Text(
                          "₹ $AgentOutstandingData",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.white54,
              height: 0.5,
            ),
            GestureDetector(
              onTap: () {
                // Get.to(voic());
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => voic()));
                //
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PendOrdAgentList()));
              },
              child: Container(
                height: height / 15,
                width: width / 1.1,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    /*   gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [Colors.grey.shade800, Colors.white30]),*/
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Pending Order's ",
                            style: GoogleFonts.notoSans(
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                          Text(
                            " - $PendingOrderData",
                            style: GoogleFonts.notoSans(
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /*InkWell(
                      onTap: () {
                        // Handle button press
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             product_page()))
                        //     .then(
                        //         (value) => setState(() {
                        //       _loadCartCount();
                        //       _init();
                        //     }));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => product_page()));
                      },
                      child: _buildProductContainer("Product",
                          product_count.toString(), Icons.archive_outlined),
                    ),
                    SizedBox(
                      width: 10,
                    ),*/
                    InkWell(
                      onTap: () {
                        // Handle button press
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             CartScreen())).then(
                        //         (value) => setState(() {
                        //       _loadCartCount();
                        //       _init();
                        //     }));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const cus()));
                      },
                      child: _buildProductContainer(
                        "Customer",
                        "${0}",
                        Icons.person,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /*InkWell(
                    onTap: () {
                      // Handle button press
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             product_page()))
                      //     .then(
                      //         (value) => setState(() {
                      //       _loadCartCount();
                      //       _init();
                      //     }));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => product_page()));
                    },
                    child: _buildProductContainer("Product",
                        product_count.toString(), Icons.archive_outlined),
                  ),
                  SizedBox(
                    width: 10,
                  ),*/
                  InkWell(
                    onTap: () {
                      // Handle button press
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             CartScreen())).then(
                      //         (value) => setState(() {
                      //       _loadCartCount();
                      //       _init();
                      //     }));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const product_page()));
                    },
                    child: _buildProductContainer(
                      "Product",
                      "${0}",
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 40.0),
            //   child: GestureDetector(
            //     onTap: (){
            //     },
            //     child: Container(
            //       height: height/15,
            //       width: width/1.5,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15),
            //         color: Colors.black
            //       ),
            //       child: Center(child: Text("Report",style:GoogleFonts.notoSans( textStyle: TextStyle(color: Colors.yellowAccent,fontSize: 19,fontWeight: FontWeight.w500),))),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  SizedBox _buildProductContainer(
      String productName, String productqty, IconData iconename) {
    // var iconename;
    return SizedBox(
      // width: 169.5,
      height: 149.5,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 30,
        height: 162,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(right: 92),
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  // color: Colors.orange,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(
                  iconename,
                  color: Colors.black,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 25),
            Center(
              child: Text(
                productName,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 22,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            // if (productqty != '00000')
            //   // Padding(
            //   //   padding: const EdgeInsets.only(left: 60),
            //   Center(
            //     child: Container(
            //       width: 50,
            //       height: 25,
            //       decoration: BoxDecoration(
            //         // color: Colors.orange,
            //         borderRadius: BorderRadius.circular(50.0),
            //       ),
            //       child: Text(
            //         productqty,
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 18,
            //           // color: Colors.white,
            //           // fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String email;
  final String user_name;
  final String about_us;

  MyDrawer({
    Key key,
    this.email,
    this.user_name,
    this.about_us,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user_name),
            accountEmail: Text(email),
            currentAccountPicture: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserProfilePage()));
              },
              child: CircleAvatar(
                // backgroundImage: NetworkImage(
                //   "https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg",
                // ),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://img.freepik.com/premium-photo/abstract-fractal-background_963338-3247.jpg",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      // Extracting the first word of loginuser
                      '',
                      style: TextStyle(
                        fontSize: 24, // adjust font size as needed
                        fontWeight:
                            FontWeight.bold, // adjust font weight as needed
                        color: Colors.white, // adjust text color as needed
                      ),
                    ),
                  ),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://img.freepik.com/premium-photo/abstract-fractal-background_963338-3247.jpg",
                ),
                fit: BoxFit.fill,
              ),
            ),
            /*otherAccountsPictures: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/women/74.jpg",
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/men/47.jpg",
                ),
              ),
            ],*/
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              // Add your logic for Home tap
              // Navigator.pop(context); // Close the drawer
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const sale()),
              );
            },
          ),
          /* ListTile(
            leading: Icon(Icons.account_box),
            title: Text("About"),
            onTap: () {
              // Add your logic for About tap
              // Navigator.pop(context); // Close the drawer
              Navigator.pop(context);
              final Uri _url =
                  Uri.parse("https://nrgimpex.com/about-nrg-impex/");
              _launchUrl(_url);
            },
          ),*/
          // ListTile(
          //   leading: Icon(Icons.grid_3x3_outlined),
          //   title: Text("Products"),
          //   onTap: () {
          //     // Add your logic for Products tap
          //     // Navigator.pop(context); // Close the drawer
          //     Navigator.pop(context);
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => product_page()));
          //   },
          // ),
          /* ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text("Contact"),
            onTap: () {
              // Add your logic for Contact tap
              Navigator.pop(context); // Close the drawer
              _showContactDetailsDialog(context);
            },
          ),*/
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text("About"),
            onTap: () {
              Get.to(About(
                about_us: about_us,
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_align_justify_outlined),
            title: const Text("Customized "),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerOrder()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Contact"),
            onTap: () {
              _showContactDetailsDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showContactDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Contact Us"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: AssetImage('images/insta2.png'),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      final Uri url = Uri.parse(
                          "https://www.instagram.com/bluearc_clothing/");
                      _launchUrl(url);
                    },
                    child: const Text(
                      "bluearc_clothing",
                      style: TextStyle(
                        color: Colors.black,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              /*Text(
                "NRG FASHION",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),*/
              /*SizedBox(height: 8),
              Text("41,42, OLD RAMAKRISHNA PURAM,"),
              Text("3RD STREET,"),
              Text("TIRUPUR – 641607. IN."),*/
              const SizedBox(height: 5),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: AssetImage('images/insta2.png'),
                            fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      final Uri url =
                          Uri.parse("https://www.instagram.com/frosenfox/");
                      _launchUrl(url);
                    },
                    child: const Text(
                      "frosenfox",
                      style: TextStyle(
                        color: Colors.black,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _launchPhone("9363082980");
                },
                child: const Text(
                  "   📞   +91 93630 82980",
                  style: TextStyle(
                    color: Colors.black,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _launchEmail("sbtcc23@gmail.com");
                },
                child: const Text(
                  "   📧   sbtcc23@gmail.com",
                  style: TextStyle(
                    color: Colors.black,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchEmail(String email) async {
    String url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
