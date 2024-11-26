import 'dart:async';

import 'package:b2buy/customer_order_registration.dart';
import 'package:b2buy/dash_product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'dart:io';
import 'package:b2buy/home_page.dart';
import 'package:b2buy/layers/cart_details.dart';
import 'package:b2buy/layers/invoice_page.dart';
import 'package:b2buy/layers/ledger_report.dart';
import 'package:b2buy/layers/product_page.dart';
import 'package:b2buy/main.dart';
import 'package:b2buy/user_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:b2buy/universalkey.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

String Order_name = '';
String Order_apifilter = '';
String order_report = '';

class buyerdashboard extends StatefulWidget {
  const buyerdashboard({Key key}) : super(key: key);

  @override
  State<buyerdashboard> createState() => _buyerdashboardState();
}

class _buyerdashboardState extends State<buyerdashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> invoiceData;
  Future<List<Map<String, dynamic>>> _buyerDashboardFuture;
  double outstanding = 0;
  String ttype = '';
  double credit = 0;
  double debit = 0;
  double balance = 0;
  double product = 0;
  double order_qty = 0;
  double pre_order_qty = 0;
  double pcs_qty = 0;
  String buyer_name = universal_customer;
  String product_count = '';
  String email = '';
  String user_name = '';
  String about_us = '';
  String user_type = '';
  Timer _timer;
  int currentIndex = 0;
  List<String> imageList = [];
  bool isDialogShown = false;

  Future<void> _load_Banner_dashboard() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    // Construct the API URL with search filter
    String apiUrl =
        'http://sribalajitexknit.regenterp.com/api/method/regent.regent.flutter.api_mobile_app_dashboard_app'; // Insert your API URL here
    final response = await ioClient.get(
      Uri.parse(apiUrl),
      // ,"item_size.size" &filters=[["name","like","%gym%20vest%"]]
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );

    print('token $apiKey:$apiSecret');
    print(response.statusCode);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          json.decode(response.body)["message"]);

      // Append data to imageList
      for (var item in data) {
        if (item.containsKey('attach_image')) {
          imageList.add(item['attach_image']);
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();

    // Show the dialog only if it hasn't been shown yet
    // if (!isDialogShown) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (ModalRoute.of(context)?.isFirst ?? false) {
    //       // Check if this is the first route in the stack
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             contentPadding:
    //                 EdgeInsets.zero, // Removes the padding around the dialog
    //             content: Stack(
    //               children: [
    //                 Container(
    //                   height: 213,
    //                   width: 280,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(5),
    //                   ),
    //                   child: Column(
    //                     children: [Image.asset('assets/sales.jpg')],
    //                   ),
    //                 ),
    //                 Positioned(
    //                   right: 0.0,
    //                   top: 0.0,
    //                   child: IconButton(
    //                     icon: const Icon(Icons.cancel, color: Colors.red),
    //                     onPressed: () {
    //                       Navigator.of(context)
    //                           .pop(); // Close the dialog when the cancel button is pressed
    //                       setState(() {
    //                         isDialogShown =
    //                             true; // Set the flag to true so the dialog doesn't show again
    //                       });
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //       );
    //     }
    //   });
    // }

    // Start a timer for periodic actions
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % imageList.length;
      });
    });

    // Load initial data
    _load_Banner_dashboard();
    _loadCartCount();
    _getcompanyData();
    _productsFuture = fetchProductlists();
    _init();
  }

  bool _showProgress = true;

  Future<void> _init() async {
    await Future.delayed(const Duration(microseconds: 1000));
    _getcompanyData();
    _getProductCount();
    _getUserProfile();
    print(buyer_name);

    await Future.delayed(const Duration(microseconds: 2500));

    fetchbuyer();
    fetchproduct();
    fetchboxqty();
    _getBillId();
    _getcompanyData();

    print(buyer_name);
  }

  int totalCartQty = 0;
  final totalCartCount = TextEditingController();
  //
  /*Future<void> _loadCartCount() async {
    List<CartItemQty> cartItems =
        (await CartDatabaseHelper.instance.getQtyCountCartItems())
            .cast<CartItemQty>();
    setState(() {
      totalCartQty = 0;

      for (CartItemQty item in cartItems) {
        totalCartQty += item.qty;
      }
      print("Total Quantity: $totalCartQty");
      totalCartCount.text = '0';
      totalCartCount.text = totalCartQty.toString();
      print("Total cart text Quantity:${totalCartCount.text}");
    });
  }*/

  Future<void> _loadCartCount() async {
    List<CartItemQty> cartItems =
        (await CartDatabaseHelper.instance.getQtyCountCartItems())
            .cast<CartItemQty>();
    int calculatedTotalCartQty = 0; // Ensure proper initialization
    if (cartItems != null) {
      for (CartItemQty item in cartItems) {
        if (calculatedTotalCartQty != null && calculatedTotalCartQty != '') {
          calculatedTotalCartQty += item.qty;
        }
      }
    }
    setState(() {
      totalCartQty =
          calculatedTotalCartQty; // Assign calculated total cart quantity
      print("Total Quantity: $totalCartQty");
      totalCartCount.text = totalCartQty?.toString() ??
          '0'; // Safe handling for potential null value
      print("Total cart text Quantity: ${totalCartCount.text}");
    });
  }

  String bill_name = '';
  String ref_name = '';
  double dis1 = 0.0;
  double dis2 = 0.0;
  final totalValue = TextEditingController();
  String price_list = '';

  Future<void> _getBillId() async {
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    print(buyer_name);
    final adopturl2 =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/method/regent.regent.flutter.get_customer_types_flutter?name=$buyer_name';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(adopturl2),
        headers: {},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["message"];
        if (responseData.isNotEmpty) {
          setState(() {
            bill_name = json.decode(response.body)["message"][0]["bill_name"];
            ref_name = json.decode(response.body)["message"][0]["ref_name"];
            dis1 = json.decode(response.body)["message"][0]["dis_1"];
            dis2 = json.decode(response.body)["message"][0]["dis_2"];
            price_list = json.decode(response.body)["message"][0]["price_list"];
            // print(buyer_name);
            print(dis1);
            print(dis2);
            if (buyer_name == bill_name) {
              print(bill_name);

              Order_name = bill_name;
              Order_apifilter = "['buyer','=','$Order_name']";
              order_report = "buyer";
              print(Order_apifilter);
              print(order_report);
            } else {
              print(ref_name);
              print(Order_name);
              Order_name = ref_name;
              Order_apifilter = "['ref_customer','=','$Order_name']";
              order_report = "ref_customer";
              print(Order_apifilter);
              print(order_report);
            }
            _showProgress = false;

            // universal_customer = json.decode(response.body)["message"][0]
            // ["universal_customer"];
          });
          _showProgress = false;
        } else {
          print('Response data is empty');
          print('194');
        }
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

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
        final responseData = json.decode(response.body)["message"];
        if (responseData.isNotEmpty) {
          setState(() {
            buyer_name =
                json.decode(response.body)["message"][0]["universal_customer"];
            email = json.decode(response.body)["message"][0]["user_id"];
            user_name = json.decode(response.body)["message"][0]["user_name"];
            user_type = json.decode(response.body)["message"][0]["user_type"];
            print(buyer_name);

            // universal_customer = json.decode(response.body)["message"][0]
            // ["universal_customer"];
          });
        } else {
          print('Response data is empty');
          print('234');
        }
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

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

  Future<void> _getProductCount() async {
    final adopturl =
        '$http_key://$core_url/api/resource/Product?fields=["count(name)"]&filters=[["is_inactive","=","0"],["published","=","1"]]';

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

  Future<void> fetchbuyer() async {
    final url =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/method/regent.sales.client.customer_summary?buyer=$buyer_name';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(url),
        headers: {},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["message"];
        if (responseData.isNotEmpty) {
          setState(() {
            outstanding = json.decode(response.body)["message"][0]["amount"];
            ttype = json.decode(response.body)["message"][0]["ttype"];
            credit = json.decode(response.body)["message"][0]["tot_credit"];
            debit = json.decode(response.body)["message"][0]["tot_debit"];
            print(outstanding);
            print(ttype);
          });
        } else {
          print('Response data is empty');
          print('308');
        }
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

  Future<void> fetchproduct() async {
    final url =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/method/regent.sales.client.orderform_count?name=$buyer_name';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(url),
        headers: {},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["message"];
        if (responseData.isNotEmpty) {
          setState(() {
            product = json.decode(response.body)["message"][0]["product"];
            order_qty = json.decode(response.body)["message"][0]["order_form"];
            pre_order_qty =
                json.decode(response.body)["message"][0]["pre_order_form"];
          });
        } else {
          print('Response data is empty');
          print('345');
        }
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

  /// Product list Api's method ///

  // Future<List<String>> fetchFirstFiveProductImages() async {
  //   HttpClient client = HttpClient();
  //   client.badCertificateCallback =
  //       ((X509Certificate cert, String host, int port) => true);
  //   IOClient ioClient = IOClient(client);
  //
  //   // Construct the API URL with search filter
  //   String apiUrl =
  //       '$http_key://$core_url/api/resource/Product?fields=["name","image","item_name","item_names","size_type","brand"]&limit_page_length=50000';
  //
  //   final response = await ioClient.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Authorization': 'token $apiKey:$apiSecret',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body)["data"];
  //     // Extract the first 5 images
  //     List<String> images =
  //         data.take(5).map((item) => item["image"] as String).toList();
  //     return images;
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future<void> fetchboxqty() async {
    print(buyer_name);
    final url =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/method/regent.sales.client.orderform_buyer?buyer=$buyer_name';
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(url),
        headers: {},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["message"];
        if (responseData.isNotEmpty) {
          setState(() {
            pcs_qty = responseData[0]["qty"];
            // order_qty = responseData[0]["order_form"];
          });
          /* setState(() {
            pcs_qty = json.decode(response.body)["message"][0]["qty"];
            // order_qty = json.decode(response.body)["message"][0]["order_form"];
          });*/
        } else {
          // Handle empty response data
          print('Response data is empty');
          print('385');
        }
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

  // Function to launch WhatsApp
  void _launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  int currentPageIndex = 0;
  final int _currentPage = 0;

  List<Widget> _buildDots(int length) {
    List<Widget> dots = [];
    for (int i = 0; i < length; i++) {
      dots.add(
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == i ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      );
    }
    return dots;
  }

  String _searchTerm;
  String _searchFilter;

  Future<List<Map<String, dynamic>>> fetchProductlists() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    // Construct the API URL with search filter
    String apiUrl =
        '$http_key://$core_url/api/resource/Product?fields=["name","image","item_name","item_names","size_type","brand"]&limit_page_length=50000';

    // Check if both _searchTerm and _searchFilter contain data
    if (_searchTerm != null &&
        _searchTerm.isNotEmpty &&
        _searchFilter != null &&
        _searchFilter.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["name","like","%$_searchTerm%"],["product_type","like","%$_searchFilter%"]]&order_by=modified%20desc';
    } else if (_searchTerm != null && _searchTerm.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"],["name","like","%$_searchTerm%"]]&order_by=modified%20desc';
    } else if (_searchFilter != null && _searchFilter.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"],["product_type","like","%$_searchFilter%"]]&order_by=modified%20desc';
    } else {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"]]&order_by=modified%20desc';
    }

    print(apiUrl);
    final response = await ioClient.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );

    print('token $apiKey:$apiSecret');
    print(response.statusCode);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["data"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void handleProductTap(String productName) {
    // Handle the product tap action here
    print("Tapped on product: $productName");
  }

  @override
  void dispose() {
    // Dispose timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This is the home page'),
          ),
        ); // Call the function you want to navigate to
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   title: Text("Buyer"),
        //   backgroundColor: Colors.black,
        // ),
        drawer: MyDrawer(
          email: email,
          user_name: user_name,
          about_us: about_us,
        ),
        // backgroundColor: Color(0xFFFFDCbf),
        body: _showProgress
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  // alignment: AlignmentDirectional.center,
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 40, left: 10, right: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Hello,  ',
                                        style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '$loginuser  ', // Show full username
                                          style: GoogleFonts.outfit(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Inter',
                                                height: 0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          overflow: TextOverflow
                                              .visible, // Ensure full name is shown
                                          softWrap:
                                              true, // Allow wrapping to the next line if needed
                                        ),
                                      ),
                                      const Text(
                                        '👋',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w800,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10), // Space between username and cart icon
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen()),
                                    ).then((value) => setState(() {
                                          _loadCartCount();
                                          _init();
                                        }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        totalCartCount.text != null &&
                                                totalCartCount.text
                                                    .trim()
                                                    .isNotEmpty
                                            ? totalCartCount.text
                                            : "0",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              // width: 211,
                              height: 12,
                            ),

                            /*  if (user_type == 'Buyer')
                          SizedBox(
                            // width: 211,
                            height: 15,
                          ),*/
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(imageList[currentIndex]),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          10,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.black,
                                              Colors.black,
                                            ]),
                                        border: Border.all(
                                            // color: Color(0xFFed6e00),
                                            width: 0.5),
                                        borderRadius: BorderRadius.circular(1),
                                        /* image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                imageList[currentIndex]),
                                          ),*/
                                      ),
                                      child: Center(
                                        child: RichText(
                                            text: TextSpan(
                                                text: "Current Outstanding :",
                                                style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 19.5,
                                                        color: Colors.white)),
                                                children: [
                                              TextSpan(
                                                  text:
                                                      ' ₹ ${outstanding.abs()}',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: ttype == 'Db'
                                                        ? Colors.red
                                                        : Colors.green,
                                                  )))
                                            ])),
                                      ),
                                    ),
                                  ],
                                ),
                                /*    Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: DotsIndicator(
                                        dotsCount: imageList.length,
                                        position: currentIndex.toDouble(),
                                        decorator: DotsDecorator(
                                          color:
                                              Colors.grey, // Inactive dot color
                                          activeColor:
                                              Colors.white, // Active dot color
                                          size: Size.square(8.0), // Dot size
                                          activeSize: Size.square(
                                              8.0), // Active dot size
                                          spacing: EdgeInsets.all(
                                              4.0), // Spacing between dots
                                          activeShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0)), // Active dot shape
                                        ),
                                      ),
                                    ),
                                  ),*/
                              ],
                            ),

                            /*     Container(
                          width: 800,
                          height: 190,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(19.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Outstanding',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '\₹ ${outstanding}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w800,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Ordered Qty - ${pcs_qty} / pcs',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),*/
                            const SizedBox(
                              height: 20,
                            ),
                            /*   Padding(
                          padding: EdgeInsets.only(right: 230),
                          child: Text(
                            'Reports',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              height: 0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),*/

                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Handle button press
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const product_page()))
                                        .then((value) => setState(() {
                                              _loadCartCount();
                                              _init();
                                            }));
                                  },
                                  child: _buildProductContainer(
                                      "Product",
                                      product_count.toString(),
                                      Icons.archive_outlined),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                /* SizedBox(height: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Handle button press
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DocumentListScreen()))
                                        .then((value) => setState(() {
                                              _loadCartCount();
                                              _init();
                                            }));
                                  },
                                  child: _buildProductContainer(
                                      "Order",
                                      order_qty.toString(),
                                      Icons.check_rounded),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    // Handle button press
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                reportScreen()));
                                  },
                                  child: _buildProductContainer("Report",
                                      '00000', Icons.receipt_long),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Handle button press
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PreDocumentListScreen()))
                                        .then((value) => setState(() {
                                              _loadCartCount();
                                              _init();
                                            }));
                                  },
                                  child: _buildProductContainer(
                                      "Secondary Order",
                                      '00000',
                                      Icons.person),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    // Handle button press
                                  },
                                  child: Container(
                                    width: 169.5,
                                    height: 169.5,
                                  ),
                                ),
                              ],
                            ),*/
                                // Row(
                                //   children: [
                                //     InkWell(
                                //       child: _buildProductContainer(
                                //           "Notification",
                                //           '5',
                                //           Icons.notifications),
                                //     ),
                                //     SizedBox(
                                //       width: 10,
                                //     ),
                                //     InkWell(
                                //       child: Container(
                                //         width: 169.5,
                                //         height: 169.5,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "    New Arrivals",
                                style: GoogleFonts.dmSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            /// Logic for showing product fisrt five images //
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _productsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.data == null ||
                                    snapshot.data.isEmpty) {
                                  return const Center(
                                      child: Text('No data available'));
                                } else {
                                  // Use the data to populate the GridView
                                  List<Map<String, dynamic>> products =
                                      snapshot.data;

                                  return SingleChildScrollView(
                                    scrollDirection: Axis
                                        .horizontal, // Enables horizontal scrolling
                                    child: Row(
                                      children: List.generate(
                                        products.length > 6
                                            ? 6
                                            : products.length,
                                        (index) {
                                          bool highlight = index <
                                              6; // Highlight first 6 items

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      product_page(
                                                    product: products[
                                                        index], // Pass the product data
                                                  ),
                                                ),
                                              );

                                              // Trigger a highlight blink on tap
                                              setState(() {
                                                highlight = true;
                                              });

                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300), () {
                                                setState(() {
                                                  highlight = false;
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.2),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                height: 190,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    if (highlight)
                                                      BoxShadow(
                                                        color: Colors
                                                            .yellow.shade50,
                                                        blurRadius: 15,
                                                        spreadRadius: 5,
                                                      ),
                                                  ],
                                                ),
                                                child: Card(
                                                  color: Colors.white,
                                                  child: Material(
                                                    shadowColor: highlight
                                                        ? Colors.yellow.shade400
                                                        : null,
                                                    elevation: 15,
                                                    child: Column(
                                                      children: [
                                                        if (products[index]
                                                                ["image"] ==
                                                            null)
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                products[index][
                                                                        "name"][0]
                                                                    .toUpperCase(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 80,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        if (products[index]
                                                                ["image"] !=
                                                            null)
                                                          Center(
                                                            child: SizedBox(
                                                              height: 160,
                                                              width: 126,
                                                              child:
                                                                  Image.network(
                                                                '$http_key://$core_url/${products[index]["image"]}',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                            height: 4),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),

                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  if (user_type != 'Consumer' &&
                                      user_type != null)
                                    InkWell(
                                      onTap: () {
                                        // Handle button press
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DocumentListScreen()))
                                            .then((value) => setState(() {
                                                  _loadCartCount();
                                                  _init();
                                                }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            border: Border.all(
                                                color: Colors.black,
                                                // color: Color(0xFFed6e00),
                                                width: 0.1),
                                            // color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                          ),
                                          child: Center(
                                              child: ListTile(
                                            leading: const Icon(
                                              Icons.delivery_dining_outlined,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              'Order',
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          )

                                              /*   Text(
                                          'Order',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),*/
                                              ),
                                        ),
                                      ),
                                    ),
                                  if (user_type != 'Consumer')
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     // Handle button press
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 reportScreen()));
                                  //   },
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Container(
                                  //       width: double.infinity,
                                  //       height: 50,
                                  //       decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Color(0xFFed6e00),
                                  //             width: 0.1),
                                  //         // color: Colors.orange,
                                  //         borderRadius:
                                  //             BorderRadius.circular(10.0),
                                  //       ),
                                  //       child: Center(
                                  //           child: ListTile(
                                  //         leading: Icon(Icons
                                  //             .format_list_numbered_outlined),
                                  //         title: Text(
                                  //           'Report\'s',
                                  //         ),
                                  //       )
                                  //
                                  //           /*  Text(
                                  //     'Report\'s',
                                  //     textAlign: TextAlign.left,
                                  //     style: TextStyle(
                                  //       fontSize: 18,
                                  //       color: Colors.black,
                                  //       // fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),*/
                                  //           ),
                                  //     ),
                                  //   ),
                                  // ),
                                  if (user_type == 'Customer')
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  if (user_type == 'Customer')
                                    InkWell(
                                      onTap: () {
                                        // Handle button press
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const InvoiceListScreen()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: double.infinity,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  // color: Color(0xFFed6e00),
                                                  width: 0.1),
                                              // color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                            ),
                                            child: Center(
                                              child: ListTile(
                                                leading: const Icon(
                                                  Icons.receipt_long,
                                                  color: Colors.black,
                                                ),
                                                title: Text(
                                                  'Invoice',
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
                                                trailing: (InvoiceScreen !=
                                                        null // Replace with your logic to check for data
                                                    ? const Icon(Icons.circle,
                                                        color: Colors.red,
                                                        size: 13)
                                                    : SizedBox.shrink()),
                                              ),
                                            )

                                            /*Text(
                                      'Invoice',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),*/
                                            ),
                                      ),
                                    ),
                                  if (user_type == 'Customer')
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  if (user_type == 'Customer')
                                    InkWell(
                                      onTap: () {
                                        // Handle button press
                                        /*     Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FilteringDataGrid()));*/
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            border: Border.all(
                                                color: Colors.black,
                                                // color: Color(0xFFed6e00),
                                                width: 0.1),
                                            // color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                          ),
                                          child: InkWell(
                                              onTap: () {
                                                // Handle button press
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ledgervalue()));
                                              },
                                              child: Center(
                                                child: ListTile(
                                                  leading: const Icon(
                                                    Icons.pending_actions,
                                                    color: Colors.black,
                                                  ),
                                                  title: Text('Ledger',
                                                      style: GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))),
                                                ),
                                              )

                                              /* Text(
                                        'Ledger',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          // color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),*/
                                              ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Bank Details',
                                                    style: GoogleFonts.outfit(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        'SRI BALAJI TEXKNIT CLOTHING CO',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                          'A/C No : 50200093825147'),
                                                      Text(
                                                          'IFSC      : HDFC0000445'),
                                                      Text(
                                                          'HDFC BANK, TIRUPPUR'),
                                                      SizedBox(height: 20),
                                                      Center(
                                                        child: Image(
                                                          height: 120,
                                                          width: 120,
                                                          image: AssetImage(
                                                              "images/gpay_qr.PNG"),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            "Bank Details",
                                            style: GoogleFonts.outfit(
                                                textStyle: const TextStyle(
                                                    fontSize: 15.5,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 170.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            launchUrl(
                                              Uri.parse(
                                                  'https://wa.me/919790678397?text=Hi'),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child: Tab(
                                            icon: Image.asset(
                                                "assets/whatsapp.png"),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Stack _buildProductContainer(
      String productName, String productqty, IconData iconename) {
    // var iconename;
    return Stack(
      children: [
        Container(
          height: 159.4,
          width: 360,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              image: const DecorationImage(
                  image: AssetImage("assets/tshirt.png"),
                  fit: BoxFit.fitWidth,
                  colorFilter:
                      ColorFilter.mode(Colors.grey, BlendMode.darken))),
        ),
        Positioned(
          top: 10,
          left: 50,
          right: 50,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 30),
              Text(productName,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                        // fontWeight: FontWeight.bold,
                        ),
                  )),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ],
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

  Future<void> _lauchabout(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

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
                MaterialPageRoute(builder: (context) => const buyerdashboard()),
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
          ListTile(
            leading: const Icon(Icons.grid_3x3_outlined),
            title: const Text("Products"),
            onTap: () {
              // Add your logic for Products tap
              // Navigator.pop(context); // Close the drawer
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const product_page()));
            },
          ),
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
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text("About"),
            onTap: () {
              final Uri url = Uri.parse('https://www.frosenfox.com/about');
              _lauchabout(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Contact"),
            onTap: () {
              /*  showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(child: Text('Contact Us')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIky2LlhIcf8VzxpWXVdbYZmeS2CFif0Pgitig_Klw1TFEjJxuycQtKGcjxEVY0GQ61AI&usqp=CAU"),
                                      fit: BoxFit.cover)),
                            ),
                            Text(
                              "  Instagram",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://static.vecteezy.com/system/resources/previews/018/930/698/original/facebook-logo-facebook-icon-transparent-free-png.png"),
                                      fit: BoxFit.contain)),
                            ),
                            Text(
                              "Facebook",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtPIOkB5MxFhveoJ14Sl6_w3ERyfE6s1dhXxsxc5gXNQ&s"),
                                      fit: BoxFit.cover)),
                            ),
                            Text(
                              "Whatsapp",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        // Add more details here as needed
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );*/
              _showContactDetailsDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.deck),
            title: const Text(
              "Customized Order",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              /*  showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(child: Text('Contact Us')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIky2LlhIcf8VzxpWXVdbYZmeS2CFif0Pgitig_Klw1TFEjJxuycQtKGcjxEVY0GQ61AI&usqp=CAU"),
                                      fit: BoxFit.cover)),
                            ),
                            Text(
                              "  Instagram",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://static.vecteezy.com/system/resources/previews/018/930/698/original/facebook-logo-facebook-icon-transparent-free-png.png"),
                                      fit: BoxFit.contain)),
                            ),
                            Text(
                              "Facebook",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtPIOkB5MxFhveoJ14Sl6_w3ERyfE6s1dhXxsxc5gXNQ&s"),
                                      fit: BoxFit.cover)),
                            ),
                            Text(
                              "Whatsapp",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        // Add more details here as needed
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );*/
              // _showContactDetailsDialog(context);
              Get.to(const CustomerOrder());
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer_sharp),
            title: const Text("Faq's"),
            onTap: () {
              _showFaqDialog(context);
            },
          ),
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
        ],
      ),
    );
  }

  // Contact us //
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
                      final Uri url0 =
                          Uri.parse("https://www.instagram.com/frosenfox/");
                      _launchUrl(url0);
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
                  _launchPhone("9790678397");
                },
                child: const Text(
                  "   📞   +91 97906 78397",
                  style: TextStyle(
                    color: Colors.black,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _launchEmail("customer.sbtcc23@gmail.com");
                },
                child: const Text(
                  "   📧   customer.sbtcc23@gmail.com",
                  style: TextStyle(
                    color: Colors.black,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Working Hours :  Monday - Saturday 10Am - 6PM",
                style: TextStyle(
                  fontSize: 14.8,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  // decoration: TextDecoration.underline,
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

  /// Faq's logic //

  /// Faq us //

  void _showFaqDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Center(
              child: Text(
                "Faq's B2 Buy App",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  _buildFaqItem(
                    "1. HOW TO IDENTIFY NEWLY LAUNCHED PRODUCT?",
                    "Newly launched product will appear on top of the product list and highlighted by golden glow box.",
                  ),
                  _buildFaqItem(
                    "2. HOW TO CHECK THE SELECTED PRODUCTS AND ITS QUANTITY?",
                    "Click on cart option and find the selected products, its quantity and price details of the same after verifying, proceed with “buy now” and place your order with us.",
                  ),
                  _buildFaqItem(
                    "3. HOW TO CHECK MY PLACED ORDERS?",
                    "Click on “order” on the home page and find your orders placed along with its status and further details.",
                  ),
                  _buildFaqItem(
                    "4. HOW TO CHECK MY INVOICES?",
                    "Click on “invoice” on the home page and find all your invoices even for a particular date. You can download the invoice as pdf by clicking on the download symbol on the top corner. (Invoice will be generated only when the goods are dispatched).",
                  ),
                  _buildFaqItem(
                    "5. CAN I CHECK MY LEDGER DETAILS IN THE APP?",
                    "Yes, you can check the complete ledger by clicking on “Ledger” option on the home page. You can verify even for a particular period and can also download it as a pdf.",
                  ),
                  _buildFaqItem(
                    "6. IS THERE ANY OPTION TO MAKE PAYMENT THROUGH THE APP?",
                    "Yes, our bank account details and the UPI QR code is available at the bottom of the home page. (We request you to inform regarding payments made to us through call/ WhatsApp +91 93630 82980 – SBTCC Accounts department).",
                  ),
                  _buildFaqItem(
                    "7. CAN WE MAKE CUSTOMISED ORDERS?",
                    "Yes, we have given an option for sharing the details of customized orders along with images in the menu bar under option “CUSTOMISED ORDERS”. Or if there is any inconvenience you can contact us @+91 97906 78397 – SBTCC customer support team.",
                  ),
                  _buildFaqItem(
                    "8. I CAN’T FIND A FEW OPTIONS MENTIONED?",
                    "Please update the app in the google play store or app store. If there is any further inconvenience contact our customer care.",
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "FOR ANY FURTHER QUERIES CONTACT OUR CUSTOMER CARE:\n",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                "+91 93630 82980 – SBTCC Accounts department\n+91 97906 78397 – SBTCC customer support team\nWorking hours: 10.00am to 6.00 pm (Monday to Saturday)",
                            style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
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
        );
      },
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: GoogleFonts.spaceGrotesk(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            answer,
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
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
