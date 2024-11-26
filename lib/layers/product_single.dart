import 'dart:convert';

import 'dart:io';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../universalkey.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:b2buy/home_page.dart';
import 'package:b2buy/layers/cart_details.dart';
import 'package:b2buy/main.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:get/get.dart';

import 'customer_list_page.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

class Product {
  final String hsn;
  final String final_description;
  final String other_description;
  final int packing;
  final int moq;
  final String image;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String image5;
  final String image6;
  final String image7;
  final String image8;
  final String image9;
  final String image10;
  final String image11;
  final String image12;
  final String image13;
  final String image14;
  final String image15;
  final String image16;
  final String image17;
  final String image18;
  final String image19;
  final String image20;
  final String image21;
  final String image22;
  final String image23;
  final String image24;
  final String image25;
  final String image26;
  final String image27;
  final String image28;
  final String image29;
  final String size_chart;
  final String description;
  final List<String> size;
  final List<String> colors;

  Product(
      {this.hsn,
      this.packing,
      this.moq,
      this.final_description,
      this.other_description,
      this.description,
      this.image,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.image5,
      this.image6,
      this.image7,
      this.image8,
      this.image9,
      this.image10,
      this.image11,
      this.image12,
      this.image13,
      this.image14,
      this.image15,
      this.image16,
      this.image17,
      this.image18,
      this.image19,
      this.image20,
      this.image21,
      this.image22,
      this.image23,
      this.image24,
      this.image25,
      this.image26,
      this.image27,
      this.image28,
      this.image29,
      this.size_chart,
      this.size,
      this.colors});

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> colors = [];
    if (json['item_colour'] != null) {
      for (var color in json['item_colour']) {
        colors.add(color['colour']);
      }
    }
    List<String> sizes = [];
    if (json['item_size'] != null) {
      for (var size in json['item_size']) {
        sizes.add(size['size']);
      }
    }

    return Product(
      hsn: json['hsn'],
      other_description: json['other_description'],
      final_description: json['final_description'],
      packing: json['packing'],
      moq: json['moq'],
      image: json['image'],
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      image4: json['image4'],
      image5: json['image5'],
      image6: json['image6'],
      image7: json['image7'],
      image8: json['image8'],
      image9: json['image9'],
      image10: json['image10'],
      image11: json['image11'],
      image12: json['image12'],
      image13: json['image13'],
      image14: json['image14'],
      image15: json['image15'],
      image16: json['image16'],
      image17: json['image17'],
      image18: json['image18'],
      image19: json['image19'],
      image20: json['image20'],
      image21: json['image21'],
      image22: json['image22'],
      image23: json['image23'],
      image24: json['image24'],
      image25: json['image25'],
      image26: json['image26'],
      image27: json['image27'],
      image28: json['image28'],
      image29: json['image29'],
      size_chart: json['size_chart'],
      description: json['description'],
      size: sizes,
      colors: colors,
    );
  }
}

class ProductView extends StatefulWidget {
  final String productName;

  const ProductView({Key key, this.productName}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _productNameController = TextEditingController();
  Product _product;
  List<String> _sizes = [];
  final Map<String, double> qtyMap = {};
  final String _imageUrl =
      'https://nrgimpex.com/wp-content/uploads/2022/07/nrg-impex-classic-color-white-vest-rns.png';
  String _partnerName = '';
  final url = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Order Form'));
  final String _party = '';
  final sizesqty = TextEditingController();
  final String _retailer = '';
  final String _contact = '';
  var qtyController = '';
  final List<Map<String, dynamic>> _dataList = [];
  final qtyreset = TextEditingController();

  final bool _isImageVisible = false;

  // Map of size values and their corresponding text field controllers
  final sizeControllers = <String, TextEditingController>{};
  final mrpControllers = <String, TextEditingController>{};
  final rateControllers = <String, TextEditingController>{};
  final moqControllers = <String, TextEditingController>{};
  final apiUrl =
      '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size_rate';
  // '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size';
  final apiUrlrj =
      '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size_rate';
  // '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size';
  final bool _allstock = false;
  double allqty = 0;

  String buyer_name = universal_customer;

  final List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _getUserProfile();
    _loadCartCount();
    // Fetch product details when the widget is initialized
    _fetchProductDetails(widget.productName);
    _init();
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

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 1));

    _loadCartCount();
    fetchDatasize();
    await Future.delayed(const Duration(seconds: 2));
    fetchDatasize();
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
        setState(() {
          buyer_name =
              json.decode(response.body)["message"][0]["universal_customer"];
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

  Future<void> _fetchProductDetails(String productName) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(
      Uri.parse(
          '$http_key://$core_url/api/resource/Product/$productName?fields=[%22item_size.size%22,%22item_colour.colour%22,%22hsn%22,%22description%22]'),
      // ,"item_size.size"
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _product = Product.fromJson(data['data']);
      });
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<List<dynamic>> fetchData() async {
    /*final urls = [
      // "https://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_stock_style",
      "https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_data",
      'https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_party?party=$loginuser',
      if (_partnerName != null && _partnerName.isNotEmpty)
        'https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_size?name=$_partnerName',
    ];*/
    final urls = [
      // "http://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_stock_style",
      "$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_data",
      '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_party',
      // 'http://$core_url/api/method/regent.regent.flutter.get_flutter_party?party=$loginuser',
      if (widget.productName != null && widget.productName.isNotEmpty)
        '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size?name=${widget.productName}',
    ];

    // Create an HTTP client with the necessary certificates
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

  Future<void> fetchDatasize() async {
    print(widget.productName);
    if (widget.productName == null || widget.productName.isEmpty) {
      return;
    }
    print(widget.productName);
    print(buyer_name);
    print(widget.productName);
    print(buyer_name);
    print(widget.productName);
    print(buyer_name);
    print(widget.productName);
    print(buyer_name);
    print(widget.productName);
    print(buyer_name);
    print(widget.productName);
    print(buyer_name);
    print(widget.productName);
    print(buyer_name);
    print(widget.productName);
    print(buyer_name);

    // Build the API endpoint URL with the partner name as a query parameter
    // final url = '$apiUrl?name=$_partnerName';
    String url;
    if (loginuser == 'admin') {
      PreDefinedCustomerName = 'SRIE BALAJI KNIT WEAR';
    }
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);
    print(loginuser);

    if (_allstock) {
      url =
          '$apiUrl?name=${widget.productName}&customer=${PreDefinedCustomerName == '' ? buyer_name : PreDefinedCustomerName}';
    } else {
      url =
          '$apiUrlrj?product=${widget.productName}&customer=${PreDefinedCustomerName == '' ? buyer_name : PreDefinedCustomerName}';
    }
    // Create an HTTP client with the necessary certificates
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

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
      print(data);

      // Update the text field controllers for each size returned by the API
      data.forEach((item) {
        final size = item["size"];
        final stock = item["stock"].toString();
        final rate = item["rate"].toString();
        final mrp = item["mrp"].toString();
        final moq = item["moq"].toString();
        if (!sizeControllers.containsKey(size)) {
          sizeControllers[size] = TextEditingController();
        }
        sizeControllers[size]?.text = stock;
        if (!rateControllers.containsKey(size)) {
          mrpControllers[size] = TextEditingController();
        }
        mrpControllers[size]?.text = mrp;
        if (!rateControllers.containsKey(size)) {
          rateControllers[size] = TextEditingController();
        }
        rateControllers[size]?.text = rate;
        if (!moqControllers.containsKey(size)) {
          moqControllers[size] = TextEditingController();
        }
        moqControllers[size]?.text = moq;
        print(size);
        print(mrp);
        print(mrp);
        print(mrp);
        print(mrp);
        print(mrp);
        print(mrp);
        print(stock);
        print(rate);
      });

      // Update the list of sizes and rebuild the UI with the updated text field values
      setState(() {
        _sizes = sizeControllers.keys.toList();
      });
    } else {
      throw Exception('Failed to load data from $url');
    }
  }

  Future<void> MobileDocument() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final credentials = '$apiKey:$apiSecret';
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-Type': 'application/json',
    };

    // Set up the data to create a new document in the Flutter Mobile DocType
    final data = {
      'doctype': 'Order Form',
      'buyer': _party,
      'order_no': loginuser,
      'due_date': '2023-11-20',
      'price_list': '01.07.2023',
      // 'retailer': _retailer,
      // 'order_no': _contact,
      // 'allstock': _allstock ? '1' : '0',
      'details': _dataList
    };
    print(data);

    final body = jsonEncode(data);

    final response = await ioClient.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const DocumentListScreen()),
      );
    } else if (response.statusCode == 417) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Message'),
          content: SingleChildScrollView(
            child: Text(json.decode(response.body)['_server_messages']),
            // child: Text(json.decode(response.body).toString()),
          ),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      // print(json.decode(response.body)['_server_messages']);
      dynamic responseJson = json.decode(response.body.toString());
      dynamic responseList = responseJson['_server_messages'];
      dynamic responcemsg = responseList['message'];
      print(responcemsg);
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

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      _product?.image,
      _product?.image1,
      _product?.image2,
      _product?.image3,
      _product?.image4,
      _product?.image5,
      _product?.image6,
      _product?.image7,
      _product?.image8,
      _product?.image9,
      _product?.image10,
      _product?.image11,
      _product?.image12,
      _product?.image13,
      _product?.image14,
      _product?.image15,
      _product?.image16,
      _product?.image17,
      _product?.image18,
      _product?.image19,
      _product?.image20,
      _product?.image21,
      _product?.image22,
      _product?.image23,
      _product?.image24,
      _product?.image25,
      _product?.image26,
      _product?.image27,
      _product?.image28,
      _product?.image29,
    ];

// Filter out null or empty images
    List<String> validImages = imageList
        .where((image) => image != null && image.isNotEmpty)
        .cast<String>()
        .toList();

    List<Widget> imageWidgets = [];

    for (String imageUrl in validImages) {
      imageWidgets.add(
        WidgetZoom(
          maxScaleFullscreen: 8,
          minScaleFullscreen: 0.20,
          heroAnimationTag: Object(),
          zoomWidget: Image.network(
            '$http_key://$core_url/$imageUrl',
            height: 300,
            width: 400,
            errorBuilder: (context, error, stackTrace) {
              // If the image fails to load, skip it (don't add to the list)
              return SizedBox(); // Skips invalid images
            },
          ),
        ),
      );
      print('Valid images count: ${imageWidgets.length}');
    }

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.orange,
      //   title: Text('Product Details'),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     Stack(children: [
      //       IconButton(
      //         icon: Icon(
      //           Icons.shopping_bag,
      //           size: 22,
      //         ),
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CartScreen(),
      //             ),
      //           );
      //         },
      //       ),
      //       Positioned(
      //         // top: 0.5, // Adjust the top position as needed
      //         left: 15, // Adjust the right position as needed
      //         child: Container(
      //           height: 15,
      //           decoration: BoxDecoration(
      //               // borderRadius: BorderRadius.circular(50),
      //               // color: Colors.redAccent
      //               ),
      //           child: Text(
      //             totalCartCount.text,
      //             style: TextStyle(
      //               fontSize: 12,
      //               color: Colors.yellow,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ]),
      //     Text(
      //       '  ',
      //       style: TextStyle(fontSize: 20),
      //     )
      //   ],
      // ),
      bottomNavigationBar: loginuser != 'admin'
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors
                              .white, // Replace with your desired background color
                        ),
                        onPressed: () async {
                          print(_sizes);
                          print(_sizes);
                          print(_sizes);
                          print(_sizes);
                          print(_sizes);
                          print(_sizes);
                          print(_sizes);
                          print(_sizes);
                          // Add the entered data to the cart and database
                          for (var size in _sizes) {
                            var qtyController = sizeControllers[size];
                            if (qtyController != null &&
                                qtyController.text != null) {
                              var stock = (qtyController.text).isNotEmpty
                                  ? double.parse(qtyController.text)
                                  : 0;
                              // Proceed with your logic
                            } else {
                              print(
                                  "QtyController or its text is null for size $size");
                            }

                            var qtyBox =
                                (qtyMap[size]?.toInt() ?? allqty.toInt()) *
                                    (_product.packing);
                            var qty = qtyMap[size]?.toInt() ?? allqty.toInt();

                            var rate = rateControllers[size]?.text;

                            if (qty != null && qty != 0 && qty > 0) {
                              CartItem cartItem = CartItem(
                                product: widget.productName,
                                qty: qty,
                                box: qty,
                                size: size,
                                rate:
                                    rate, // You may need to set the correct rate value
                              );

                              print(qty);
                              if (_product.moq.toInt() <= qty.toInt()) {
                                await CartDatabaseHelper.instance
                                    .insertCartItem(cartItem);
                              } else {
                                showDialog(
                                  context:
                                      context, // Assuming you have access to the context
                                  builder: (BuildContext context) {},
                                );
                              }
                            }
                          }
                          // Clear the text fields
                          setState(() {
                            _sizes = [];
                            sizeControllers.clear();
                            allqty = 0;
                            sizesqty.text = '';
                            qtyreset.text = '';
                          });
                          qtyMap.clear();
                          _partnerName = '';
                          fetchDatasize();
                        },
                        child: Container(
                          height: 50,
                          width: 350,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            // borderRadius: BorderRadius.all(
                            //   Radius.circular(5),
                            // )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '    Add to cart ',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: Colors
                      //         .white, // Replace with your desired background color
                      //   ),
                      //   onPressed: () async {
                      //     // Add the entered data to the cart and database
                      //     _sizes.forEach((size) async {
                      //       var qtyController = sizeControllers[size];
                      //       var stock = qtyController.text.isNotEmpty
                      //           ? double.parse(qtyController.text)
                      //           : 0;
                      //       var qty_box =
                      //           (qtyMap[size]?.toInt() ?? allqty.toInt()) *
                      //               (_product.packing);
                      //       var qty = qtyMap[size]?.toInt() ?? allqty.toInt();
                      //       var rate = rateControllers[size]?.text;
                      //       if (qty != null && qty != 0 && qty > 0) {
                      //         CartItem cartItem = CartItem(
                      //           product: widget.productName,
                      //           qty: qty_box,
                      //           box: qty,
                      //           size: size,
                      //           rate:
                      //               rate, // You may need to set the correct rate value
                      //         );
                      //         await CartDatabaseHelper.instance
                      //             .insertCartItem(cartItem);
                      //       }
                      //     });
                      //
                      //     // Clear the text fields
                      //     setState(() {
                      //       _sizes = [];
                      //       sizeControllers.clear();
                      //       allqty = 0;
                      //       sizesqty.text = '';
                      //       qtyreset.text = '';
                      //     });
                      //     qtyMap.clear();
                      //     _partnerName = '';
                      //     // fetchDatasize();
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => CartScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //           width: 1,
                      //           color: Color(0xFFed6e00),
                      //         ),
                      //         borderRadius: BorderRadius.all(
                      //           Radius.circular(80),
                      //         )),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(10),
                      //       child: Text(
                      //         '          Buy Now          ',
                      //         style: TextStyle(color: Colors.black),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            )
          : null,
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<List<dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          // Product Name

                          /*  Image.network(
                            _imageUrl,
                            fit: BoxFit.fitHeight,
                            height: 300,
                            width: 325,
                          ),*/
                          /*if (_product?.image == null)
                            Container(
                              height: 300,
                              width: 325,
                              child: Center(
                                child: Text(
                                  widget.productName[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          if (_product?.image != null)
                            Center(
                              child: Image.network(
                                '$http_key://$core_url/${_product?.image}',
                                fit: BoxFit.fitHeight,
                                height: 300,
                                width: 325,
                              ),
                            ),*/
                          /* if (imageWidgets.isNotEmpty)
                            Center(
                              child: SizedBox(
                                height: 300,
                                width: 325,
                                child: PageView(
                                  children: imageWidgets,
                                ),
                              ),
                            ),*/
                          if (imageWidgets.isNotEmpty)
                            Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width / 1,
                                child: Stack(
                                  children: [
                                    PageView(
                                      onPageChanged: (index) {
                                        setState(() {
                                          currentPageIndex = index;
                                          imageWidgets = [imageWidgets[index]];
                                        });
                                      },
                                      controller: PageController(
                                        initialPage: currentPageIndex,
                                      ),
                                      children: imageWidgets,
                                    ),
                                    /*  Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          if (currentPageIndex > 0) {
                                            setState(() {
                                              currentPageIndex--;
                                              imageWidgets = [
                                                imageWidgets[currentPageIndex]
                                              ];
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          if (currentPageIndex <
                                              imageWidgets.length - 1) {
                                            setState(() {
                                              currentPageIndex++;
                                            });
                                          }
                                        },
                                      ),
                                    ),*/
                                    Positioned(
                                      bottom: 16,
                                      left: 0,
                                      right: 0,
                                      child: DotsIndicator(
                                        dotsCount: imageWidgets.length,
                                        position: currentPageIndex.toDouble(),
                                        decorator: DotsDecorator(
                                          color: Colors.grey
                                              .shade600, // Inactive dot color
                                          activeColor:
                                              Colors.white, // Active dot color
                                          // Size of the active dot
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 30,
                                        right: 0,
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: IconButton(
                                            icon: Stack(
                                              children: [
                                                const Icon(
                                                  Iconsax.shopping_bag,
                                                  size: 27,
                                                  color: Colors.white,
                                                ),
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 3.0),
                                                    child: Text(
                                                      totalCartCount.text,
                                                      style: const TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
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
                                                  builder: (context) =>
                                                      const CartScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        //       ),
                                        ),
                                    Positioned(
                                        top: 30,
                                        left: 0,
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: IconButton(
                                            icon: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: const Icon(
                                                Icons.arrow_back,
                                                size: 27,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         CartScreen(),
                                              //   ),
                                              // );
                                            },
                                          ),
                                        )
                                        //       ),
                                        ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              (widget.productName).split('-').last,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          /* Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "MOQ: ${_product.moq != null ? _product.moq : '-'}",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),*/
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // SizedBox(width: 12.0),
                                    const Text(
                                      'Box Contain :',
                                      style: TextStyle(
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    if (_product?.packing != null)
                                      _product.packing != null
                                          ? Text(
                                              '${_product.packing} / PCS',
                                              style: const TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            )
                                          : const CircularProgressIndicator(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // Text('Sizes: ${_product.size.join(', ')}'),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "MRP inclusive of all taxes,\nfree delivery",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          // SizedBox(height: 5.0),
                          // HSN and Sizes

                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          /*   Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 12.0),
                                  Text(
                                    'HSN Code :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  if (_product?.hsn != null)
                                    _product.hsn != null
                                        ? Text(
                                            _product.hsn,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          )
                                        : CircularProgressIndicator(),
                                ],
                              ),*/
                          // Text('Sizes: ${_product.size.join(', ')}'),
                          //   ],
                          // ),
                          /* if (_product?.description != null)
                            SizedBox(height: 8.0),
                          if (_product?.description != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    border: Border.all(
                                        color: Color(0xFFed6e00), width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        " Description",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ), // Add ellipsis for overflow
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      ReadMoreText(
                                        _product.description,
                                        trimLines: 2,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                        colorClickableText: Colors.pink,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: '...Show More',
                                        trimExpandedText: ' Show Less ',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),*/
                          const Divider(
                              // color: Color(0xFFed6e00),
                              ),
                          /*          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 12.0),
                                  Text(
                                    'Size:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              // Text('Sizes: ${_product.size.join(', ')}'),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 16.0),
                              // Size
                              if (_product?.size != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8.0),
                                    Wrap(
                                      spacing: 8.0,
                                      children: _product.size
                                          .map((size) => _buildChip(size))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              SizedBox(width: 16.0),

                              // Colors
                            ],
                          ),*/
                          /*     Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // SizedBox(width: 12.0),
                                  Text(
                                    'Avaliable Colors:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextButton(
                                    child: Text(
                                      'View all',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Text('Sizes: ${_product.size.join(', ')}'),
                            ],
                          ),
                          if (_product?.colors != null)
                            Stack(
                              children: [
                                SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Wrap(
                                            spacing: 5.0,
                                            children: _product.colors
                                                .map((colors) =>
                                                    _buildColorCircle(colors))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      // Add other widgets as needed
                                    ],
                                  ),
                                ),
                                // Add other overlapping widgets here
                              ],
                            ),
*/
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Avaliable Sizes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ..._sizes.map((size) {
                            return Column(
                              children: [
                                /*DataTable(
                                  // dividerThickness: ,
                                  border: TableBorder.all(
                                      color: Colors.transparent,
                                      width: 2,
                                      borderRadius: BorderRadius.circular(10)),
                                  showCheckboxColumn: true,
                                  // headingRowColor: MaterialStateColor.resolveWith((states) => CupertinoColors.activeBlue),
                                  // showBottomBorder: true,

                                  // headingRowHeight: 60.0,
                                  columns: [
                                    DataColumn(
                                      label: Expanded(
                                          flex: 1,
                                          child: Text(
                                            "5",
                                          )),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          flex: 1,
                                          child: Text(
                                            "6",
                                          )),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          flex: 1,
                                          child: Text(
                                            "7",
                                          )),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          flex: 3,
                                          child: Text(
                                            "8",
                                          )),
                                    )
                                  ],
                                  rows: [
                                    DataRow(
                                        color:
                                            MaterialStateProperty.resolveWith(
                                                (states) => Colors.transparent),
                                        cells: [
                                          DataCell(
                                            Text(
                                              '${size}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${(sizeControllers[size]?.text).split('.')[0]}' ??
                                                  '',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          DataCell(Text(
                                            '₹${(rateControllers[size]?.text).split('.')[0]}' ??
                                                '',
                                            style: TextStyle(fontSize: 14),
                                          )),
                                          DataCell(
                                            Container(
                                              // width: 170,
                                              height: 35,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        // Decrease the value by 1, but ensure it doesn't go below 0
                                                        qtyMap[size] =
                                                            (qtyMap[size] ??
                                                                    0) -
                                                                1;
                                                        if (qtyMap[size] < 0) {
                                                          qtyMap[size] = 0;
                                                        }
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.remove,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          int maxAllowedQuantity =
                                                              int.tryParse((sizeControllers[
                                                                              size]
                                                                          ?.text)
                                                                      .split(
                                                                          '.')[0]) ??
                                                                  0;

                                                          int initialValue =
                                                              qtyMap[size]
                                                                      ?.toInt() ??
                                                                  0;

                                                          return AlertDialog(
                                                            title: Text(
                                                                'Enter Quantity'),
                                                            content: TextField(
                                                              controller: TextEditingController(
                                                                  text: initialValue
                                                                      .toString()),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  double
                                                                      parsedValue =
                                                                      double.tryParse(
                                                                              newValue) ??
                                                                          0;
                                                                  print(
                                                                      parsedValue);
                                                                  */ /*   qtyMap[size] =
                                                              parsedValue >= 0
                                                                  ? parsedValue
                                                                  : 0;*/ /*
                                                                  // int parsedValue = int.tryParse(newValue) ?? 0;
                                                                  qtyMap[
                                                                      size] = parsedValue <=
                                                                          maxAllowedQuantity
                                                                      ? parsedValue
                                                                      : maxAllowedQuantity;
                                                                });
                                                              },
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                    'Cancel'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    // child: Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFFed6e00),
                                                            width: 0.3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1),
                                                        color: Colors.white,
                                                      ),
                                                      width: 70,
                                                      */ /* decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(15),
                                                  ),
                                                ),*/ /*
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          (qtyMap[size]
                                                                      ?.toInt() ??
                                                                  0)
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    // ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        // Increase the value by 1
                                                        */ /*qtyMap[size] =
                                                    (qtyMap[size] ?? 0) + 1;*/ /*
                                                        int maxAllowedQuantity =
                                                            int.tryParse((sizeControllers[
                                                                            size]
                                                                        ?.text)
                                                                    .split(
                                                                        '.')[0]) ??
                                                                0;
                                                        // Increase the value by 1, but ensure it doesn't exceed the max allowed quantity
                                                        qtyMap[size] = (qtyMap[
                                                                            size] ??
                                                                        0) +
                                                                    1 <=
                                                                maxAllowedQuantity
                                                            ? (qtyMap[size] ??
                                                                    0) +
                                                                1
                                                            : maxAllowedQuantity;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),*/
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(width: 10),

                                          const SizedBox(
                                            width: 75,
                                            child: Text(
                                              'Size\'s',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 55,
                                            child: Text(
                                              'Stock',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 55,
                                            child: Text(
                                              'Rate',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 55,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'MOQ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 150,
                                            height: 30,
                                            child: Center(
                                                child: Text(
                                              'Qty',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                          Container(
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Amount',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(width: 10),

                                          SizedBox(
                                            width: 75,
                                            child: Text(
                                              '${size.split('-')[0]} ',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          // SizedBox(width: 15),
                                          SizedBox(
                                            width: 55,
                                            child: Text(
                                              (sizeControllers[size]?.text)
                                                      .split('.')[0] ??
                                                  '',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),

                                          // SizedBox(width: 20),
                                          SizedBox(
                                            width: 55,
                                            child: Column(
                                              children: [
                                                const Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  'Rs.${(rateControllers[size]?.text).split('.')[0]}' ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  'MRP.${(mrpControllers[size]?.text).split('.')[0]}',
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(width: 20),
                                          SizedBox(
                                            width: 55,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                (moqControllers[size]?.text)
                                                        .split('.')[0] ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            // width: 170,
                                            height: 30,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      // Decrease the value by 1, but ensure it doesn't go below 0
                                                      qtyMap[size] = (qtyMap[
                                                                  size] ??
                                                              0) -
                                                          (double.tryParse(
                                                              (moqControllers[
                                                                          size]
                                                                      ?.text)
                                                                  .split(
                                                                      '.')[0]));

                                                      /* (qtyMap[
                                                                  size] ??
                                                              0) -
                                                          (1 *
                                                              (double.tryParse(
                                                                      (moqControllers[
                                                                                  size]
                                                                              ?.text)
                                                                          .split(
                                                                              '.')[0]))
                                                                  .toInt());*/
                                                      if (qtyMap[size] < 0) {
                                                        qtyMap[size] = 0;
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    size: 14,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        int maxAllowedQuantity =
                                                            int.tryParse((sizeControllers[
                                                                            size]
                                                                        ?.text)
                                                                    .split(
                                                                        '.')[0]) ??
                                                                0;

                                                        int initialValue =
                                                            qtyMap[size]
                                                                    ?.toInt() ??
                                                                0;

                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Enter Quantity'),
                                                          content: TextField(
                                                            controller: TextEditingController(
                                                                text: initialValue
                                                                    .toString()),
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            onChanged:
                                                                (newValue) {
                                                              setState(() {
                                                                double
                                                                    parsedValue =
                                                                    double.tryParse(
                                                                            newValue) ??
                                                                        0;
                                                                print(
                                                                    parsedValue);
                                                                /*   qtyMap[size] =
                                                                    parsedValue >= 0
                                                                        ? parsedValue
                                                                        : 0;*/
                                                                // int parsedValue = int.tryParse(newValue) ?? 0;
                                                                qtyMap[
                                                                    size] = parsedValue <=
                                                                        maxAllowedQuantity
                                                                    ? parsedValue
                                                                    : maxAllowedQuantity;
                                                              });
                                                            },
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  'OK'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  // child: Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1),
                                                      color: Colors.white,
                                                    ),
                                                    width: 50,
                                                    /* decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                      ),*/
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        (qtyMap[size]
                                                                    ?.toInt() ??
                                                                0)
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  // ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      // Increase the value by 1
                                                      /*qtyMap[size] =
                                                          (qtyMap[size] ?? 0) + 1;*/
                                                      int maxAllowedQuantity =
                                                          int.tryParse((sizeControllers[
                                                                          size]
                                                                      ?.text)
                                                                  .split(
                                                                      '.')[0]) ??
                                                              0;
                                                      // Increase the value by 1, but ensure it doesn't exceed the max allowed quantity
                                                      qtyMap[size] = (qtyMap[
                                                                  size] ??
                                                              0) +
                                                          (double.tryParse(
                                                              (moqControllers[
                                                                          size]
                                                                      ?.text)
                                                                  .split(
                                                                      '.')[0]));

                                                      /*    (qtyMap[
                                                                          size] ??
                                                                      0) +
                                                                  (1 *
                                                                      (_product.moq)
                                                                          .toInt()) <=
                                                              maxAllowedQuantity
                                                          ? (qtyMap[size] ?? 0) + 1
                                                          : maxAllowedQuantity;*/
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.add,
                                                    size: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            child: Text(
                                              'Rs.${((double.tryParse(rateControllers[size]?.text ?? '0') ?? 0).toInt() * (qtyMap[size] ?? 0))}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          }).toList(),
                          const Divider(
                              // color: Color(0xFFed6e00),
                              ),
                          if (_product.size_chart != null)
                            const SizedBox(height: 5),
                          if (_product.size_chart != null)
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Size Chart',
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.black)),
                                      ),
                                      content: WidgetZoom(
                                        heroAnimationTag: Object(),
                                        zoomWidget: Image(
                                            image: NetworkImage(
                                                "http://$core_url/${_product.size_chart}")),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.gesture_outlined,
                                    size: 20,
                                  ),
                                  Text(
                                    'Size Chart',
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                          if (_product.size_chart != null)
                            const SizedBox(height: 5),

                          ExpansionTile(
                            title: const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            children: <Widget>[
                              const SizedBox(height: 5.0),
                              HtmlWidget(_product.final_description ?? ''),
                            ],
                          ),
                          ExpansionTile(
                            title: const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Other Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            children: <Widget>[
                              const SizedBox(height: 5.0),
                              HtmlWidget(_product.other_description ?? ''),
                            ],
                          ),
                        ],
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
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildColorCircle(
    String colors,
  ) {
    return Chip(
      label: Text(
        colors.split(' ').last.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepOrangeAccent,
    );
  }
}
