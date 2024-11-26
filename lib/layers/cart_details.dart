import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:b2buy/buyer_page.dart';
import 'package:b2buy/home_page.dart';
import 'package:b2buy/main.dart';
import 'package:b2buy/universalkey.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../agent_page.dart';
import 'customer_list_page.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

String coreParty = '';

class CartDatabaseHelper {
  static final CartDatabaseHelper instance = CartDatabaseHelper._();
  static Database _database;

  CartDatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product TEXT,
        qty INTEGER,
        box INTEGER,
        size TEXT,
        rate TEXT
      )
    ''');
  }

  Future<int> insertCartItem(CartItem cartItem) async {
    Database db = await instance.database;
    return await db.insert('cart_items', cartItem.toMap());
  }

  Future<List<CartItem>> getCartItems() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('cart_items');
    return List.generate(maps.length, (index) {
      return CartItem(
        id: maps[index]['id'],
        product: maps[index]['product'],
        qty: maps[index]['qty'],
        box: maps[index]['box'],
        size: maps[index]['size'],
        rate: maps[index]['rate'],
      );
    });
  }

  Future<void> deleteCartItem(int id) async {
    Database db = await instance.database;
    await db.delete('cart_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CartItem>> getGroupedCartItems() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT product, size, rate, SUM(qty) AS qty, SUM(box) AS box
    FROM cart_items
    GROUP BY product, size, rate
  ''');

    return List.generate(maps.length, (index) {
      return CartItem(
        id: maps[index]['id'],
        product: maps[index]['product'],
        qty: maps[index]['qty'], // Use the alias 'totalQty' for the sum
        box: maps[index]['box'], // Use the alias 'totalQty' for the sum
        size: maps[index]['size'],
        rate: maps[index]['rate'],
      );
    });
  }

  Future<List<CartItemQty>> getQtyCountCartItems() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT SUM(qty) AS qty
    FROM cart_items
  ''');

    return List.generate(maps.length, (index) {
      return CartItemQty(
        qty: maps[index]['qty'], // Use the alias 'totalQty' for the sum
      );
    });
  }

  Future<void> deleteCartItems(String product, String size) async {
    Database db = await instance.database;
    await db.delete(
      'cart_items',
      where: 'product = ? AND size = ?',
      whereArgs: [product, size],
    );
  }

  Future<void> updateCartItemQty(
      String product, String size, int newQuantity) async {
    print(product);
    print(product);
    print(newQuantity);
    print(size);
    print(size);
    Database db = await instance.database;
    await db.update(
      'cart_items',
      {'qty': 0}, // New quantity value
      where: 'product = ? AND size = ?',
      whereArgs: [product, size],
    );
    await db.rawUpdate(
      'UPDATE cart_items SET qty = ? WHERE rowid = (SELECT rowid FROM cart_items WHERE product = ? AND size = ? LIMIT 1)',
      [newQuantity, product, size],
    );
  }

  Future<void> clearCartItems() async {
    Database db = await instance.database;
    await db.delete(
      'cart_items',
    );
  }
}

class CartItemQty {
  int qty;

  CartItemQty({this.qty});
}

// Modify CartItem class to include an id field
class CartItem {
  int id;
  final String product;
  final int qty;
  final int box;
  final String size;
  final String rate;

  CartItem({this.id, this.product, this.qty, this.box, this.size, this.rate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product,
      'qty': qty,
      'box': box,
      'size': size,
      'rate': rate,
    };
  }
}

// In CartScreen
class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  final url = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Order Form'));
  final url_second = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Pre Order Form'));
  final List<Map<String, dynamic>> _dataList = [];
  final List<Map<String, dynamic>> _taxList = [];

// Declare a boolean variable to control the visibility of the progress bar
  bool showProgressBar = true;
  @override
  void initState() {
    super.initState();
    // print(_cartItems);
    _getUserProfile();
    // fetchPartyData();
    _loadCartItems();
    _init();
    Future.delayed(const Duration(seconds: 1), () {
      fetchPartyData();
      fetchPartyData();
      setState(() {
        totalValue.text = '0';
        totalQty.text = '0';
        totalBox.text = '0';
        showProgressBar = false;
      });
    });
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    print(buyer_name);
    _getBillId();
    _loadCartItems();
    await Future.delayed(const Duration(seconds: 3));

    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    List<CartItem> cartItems =
        await CartDatabaseHelper.instance.getGroupedCartItems();
    setState(() {
      _cartItems = cartItems;
    });
  }

  Future<void> _deleteCartItem(String product, String size) async {
    await CartDatabaseHelper.instance.deleteCartItems(product, size);
    _loadCartItems();
    _init();
  }

  /* Future<void> _updateCartItemQty(String product, String size, int qty) async {
    await CartDatabaseHelper.instance.updateCartItemQty(product, size, qty);
    // _loadCartItems();
    // _init();
  }*/

  Future<void> _clearCartItem() async {
    await CartDatabaseHelper.instance.clearCartItems();
  }

  String buyer_name = universal_customer;
  String user_type = '';
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

          user_type = json.decode(response.body)["message"][0]["user_type"];
          // print(buyer_name);

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

  String bill_name = '';
  String ref_name = '';
  double dis1 = 0.0;
  double dis2 = 0.0;
  final totalValue = TextEditingController();
  final totalQty = TextEditingController();
  final totalBox = TextEditingController();

  String price_list = '';
  Future<void> _getBillId() async {
    final adopturl2 =
        // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
        '$http_key://$core_url/api/method/regent.regent.flutter.get_customer_types_flutter?name=${PreDefinedCustomerName == '' ? buyer_name : PreDefinedCustomerName}';
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
        setState(() {
          bill_name = json.decode(response.body)["message"][0]["bill_name"];
          ref_name = json.decode(response.body)["message"][0]["ref_name"];
          dis1 = json.decode(response.body)["message"][0]["dis_1"];
          dis2 = json.decode(response.body)["message"][0]["dis_2"];
          price_list = json.decode(response.body)["message"][0]["price_list"];
          // print(buyer_name);
          print(dis1);
          print(dis2);

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

  Future<void> MobileDocumentSecondary(BuildContext context) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final credentials = '$apiKey:$apiSecret';
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-Type': 'application/json',
    };
    print(_cartItems);
    _taxList.add({
      "gst_per": 'CGST',
      "rate": 5 / 2,
      "amount": double.parse(((double.parse(totalValue.text) -
                      (double.parse(totalValue.text) * (dis1 / 100))) *
                  (5 / 100))
              .toStringAsFixed(2)) /
          2,
    });
    _taxList.add({
      "gst_per": 'SGST',
      "rate": 5 / 2,
      "amount": double.parse(((double.parse(totalValue.text) -
                      (double.parse(totalValue.text) * (dis1 / 100))) *
                  (5 / 100))
              .toStringAsFixed(2)) /
          2,
    });

    // Set up the data to create a new document in the Flutter Mobile DocType
    final data = {
      'doctype': 'Pre Order Form',
      'buyer': bill_name,
      'order_no': loginuser,
      'due_date': '2024-04-30',
      'price_list': price_list,
      'ref_customer': coreParty == '' ? ref_name : coreParty,
      // 'retailer': _retailer,
      // 'order_no': _contact,
      // 'allstock': _allstock ? '1' : '0',
      'details': _dataList,
      'tax_details': _taxList,
      'total_amount': totalValue.text,
      'sub_total': (double.parse(totalValue.text) -
              (double.parse(totalValue.text) * (dis1 / 100)))
          .toStringAsFixed(2),
      'round_off': 0,
      'grand_total': (double.parse(totalValue.text) -
              (double.parse(totalValue.text) * (dis1 / 100)) +
              ((double.parse(totalValue.text) -
                      (double.parse(totalValue.text) * (dis1 / 100))) *
                  (5 / 100)))
          .toStringAsFixed(2)
    };
    print(data);

    final body = jsonEncode(data);

    final response =
        await ioClient.post(url_second, headers: headers, body: body);
    if (response.statusCode == 200) {
      _clearCartItem();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PreDocumentListScreen()),
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

  Future<void> MobileDocument(BuildContext context) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final credentials = '$apiKey:$apiSecret';
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-Type': 'application/json',
    };
    print(_cartItems);
    _taxList.add({
      "product": 'IGST',
      "rate": 5,
      "amount": double.parse(((double.parse(totalValue.text) -
                  (double.parse(totalValue.text) * (dis1 / 100))) *
              (5 / 100))
          .toStringAsFixed(2)),
    });

    // Set up the data to create a new document in the Flutter Mobile DocType
    final data = {
      'doctype': 'Order Form',
      'buyer':
          PreDefinedCustomerName == '' ? buyer_name : PreDefinedCustomerName,
      'order_no': loginuser,
      'due_date': '2025-01-31',
      'price_list': price_list,
      'ref_customer':
          PreDefinedCustomerName == '' ? buyer_name : PreDefinedCustomerName,
      // 'retailer': _retailer,
      // 'order_no': _contact,
      // 'allstock': _allstock ? '1' : '0',
      // 'details': _dataList,
      'size_group_details': _dataList,
      // 'tax_details': _taxList,
      // 'total_box': totalBox.text,
      // 'total_amount': totalValue.text,
      // 'sub_total': (double.parse(totalValue.text) -
      //         (double.parse(totalValue.text) * (dis1 / 100)) +
      //         ((double.parse(totalValue.text) -
      //                 (double.parse(totalValue.text) * (dis1 / 100))) *
      //             (5 / 100)))
      //     .toStringAsFixed(2),
      // 'round_off': 0,
      // 'grand_total': (double.parse(totalValue.text) -
      //         (double.parse(totalValue.text) * (dis1 / 100)))
      //     .toStringAsFixed(2)
    };
    print(data);

    final body = jsonEncode(data);

    final response = await ioClient.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      _clearCartItem();
      Navigator.of(context).pop();
      if (user_type != 'Agent') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DocumentListScreen()),
        );
      }
      if (user_type == 'Agent') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const sale()),
        );
      }
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
      print(response.statusCode);
      print(response.body);
      showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Error'),
            content: Text(
                'Request failed with status: ${response.statusCode} ${response.body}'),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
      print(response.body);
      print(response.toString());
    }
  }

  List<Map<String, dynamic>> yourData;
  Future<List<Map<String, dynamic>>> fetchPartyData() async {
    yourData = [];
    final urls = [
      if (loginuser != null && loginuser.isNotEmpty)
        '$http_key://$core_url/api/method/regent.regent.flutter.cart_customer_list?parent=$buyer_name',
    ];
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    final requests = urls.map((url) async {
      final response = await ioClient.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["message"];
        if (responseData is List) {
          yourData.addAll(responseData.cast<Map<String, dynamic>>());
        }
        print(yourData);
        return responseData;
      } else {
        throw Exception('Failed to load data from $url');
      }
    });
    final results = await Future.wait(requests);

    // Combine the results from all the API requests into a single list
    return results.expand((result) => result).toList();
  }

  // Existing code...
  int newQuantity = 0;

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0; // Variable to store the total amount
    double totalqty = 0.0; // Variable to store the total qty
    double totalbox = 0.0; // Variable to store the total qty
    return WillPopScope(
      onWillPop: () async {
        if (user_type == 'Customer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const buyerdashboard()),
          ); // Call the function you want to navigate to
          return false; // Prevent default back navigation
        }
        if (user_type == 'Agent') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const sale()),
          ); // Call the function you want to navigate to
          return false; // Prevent default back navigation
        }
        if (user_type == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const buyerdashboard()),
          ); // Call the function you want to navigate to
          return false; // Prevent default back navigation
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade300,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
          title: Text(
            'Cart',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        // side: BorderSide(color: Colors.orange, width: 2),
                        // set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // set the border radius
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return CartCheckoutView(
                                subTotal: totalValue.text,
                                discount: dis1,
                                yourData: yourData,
                                user_type: user_type,
                                buyer_name: buyer_name,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm'),
                                        content: const Text(
                                            'Are you sure you want to Book?'),
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
                                                borderRadius: BorderRadius.circular(
                                                    20), // set the border radius
                                              ),
                                            ),
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              if (buyer_name.isEmpty) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text('Error'),
                                                    content: const Text(
                                                        'Party cannot be empty!'),
                                                    actions: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20), // set the border radius
                                                          color: Colors.orange[
                                                              500], // set the background color
                                                        ),
                                                        child: TextButton(
                                                          child: const Text(
                                                            'OK',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        'Processing'),
                                                    content:
                                                        const Text('Plz wait'),
                                                    actions: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20), // set the border radius
                                                          color: Colors.orange[
                                                              500], // set the background color
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                for (int index = 0;
                                                    index < _cartItems.length;
                                                    index++) {
                                                  _dataList.add({
                                                    "product": _cartItems[index]
                                                        .product,
                                                    // "box_qty":
                                                    //     _cartItems[index].box,
                                                    "qty":
                                                        _cartItems[index].qty,
                                                    "size_group":
                                                        _cartItems[index].size,
                                                    "rate":
                                                        _cartItems[index].rate,
                                                    "moq": 30,
                                                    // "discount": dis1,
                                                    // "gst_per": 5,
                                                    "amount":
                                                        calculateTotalAmount(
                                                            (_cartItems[index]
                                                                .qty),
                                                            _cartItems[index]
                                                                .rate),
                                                  });
                                                  print(_dataList);
                                                }

                                                print(_dataList);
                                                if (bill_name == ref_name &&
                                                    user_type != 'Sales') {
                                                  MobileDocument(context);
                                                  // MobileDocumentSecondary(context);
                                                }
                                                // if (bill_name == ref_name &&
                                                //     user_type == 'Sales') {
                                                //   // MobileDocument(context);
                                                //   MobileDocumentSecondary(
                                                //       context);
                                                // }
                                                // if (bill_name != ref_name &&
                                                //     user_type != 'Sales') {
                                                //   MobileDocumentSecondary(
                                                //       context);
                                                // }
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                          },
                        );

                        /*showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm'),
                              content: Text('Are you sure you want to Book?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
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
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (buyer_name.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Party cannot be empty!'),
                                          actions: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    20), // set the border radius
                                                color: Colors.orange[
                                                    500], // set the background color
                                              ),
                                              child: TextButton(
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text('Processing'),
                                          content: Text('Plz wait'),
                                          actions: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    20), // set the border radius
                                                color: Colors.orange[
                                                    500], // set the background color
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      for (int index = 0;
                                          index < _cartItems.length;
                                          index++) {
                                        _dataList.add({
                                          "product": _cartItems[index].product,
                                          "qty": _cartItems[index].qty,
                                          "size": _cartItems[index].size,
                                          "rate": _cartItems[index].rate,
                                          "amount": calculateTotalAmount(
                                              _cartItems[index].qty as int,
                                              _cartItems[index].rate as String),
                                        });
                                        print(_dataList);
                                      }

                                      print(_dataList);
                                      MobileDocument(context);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );*/
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              child: Row(
                            children: const [
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                '   Buy Now   ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),

                          // Text('\₹ ${totalAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        /*Column(
            children: [
              Container(
                height: 650,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = _cartItems[index];
                    totalAmount +=
                        calculateTotalAmount(cartItem.qty, cartItem.rate);
                    print(totalAmount);
                    print(totalAmount);
                    return ListTile(
                      title: Text(cartItem.product),
                      subtitle: Text(
                          'Size: ${cartItem.size}  Rate: ${cartItem.rate}  Qty: ${cartItem.qty}  Amt: ${calculateTotalAmount(cartItem.qty, cartItem.rate)}'),
                      trailing: GestureDetector(
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          // Delete the item and refresh the page
                          _deleteCartItem(cartItem.product, cartItem.size);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item removed from cart'),
                            ),
                          );
                          _loadCartItems();
                        },
                      ),
                    );
                  },
                ),
              ),
              Text('Total Amount : ${totalAmount as double}'),
            ],
          ),*/
        body: showProgressBar
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Colors.grey.shade100,
                          height: 640,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = _cartItems[index];
                              totalAmount += calculateTotalAmount(
                                  cartItem.box, cartItem.rate);
                              totalqty += cartItem.qty;
                              totalbox += cartItem.box;
                              totalValue.text = totalAmount
                                  .toString(); // Convert totalAmount to string
                              totalQty.text = totalqty.toString();
                              totalBox.text = totalbox
                                  .toString(); // Convert totalAmount to string
                              print(totalAmount);
                              print(totalQty);
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 2.0,
                                    bottom: 2.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListTile(
                                      title: Text(cartItem.product),
                                      subtitle: Text(
                                          'Size: ${cartItem.size}  Rate: ${cartItem.rate}  box: ${cartItem.box}  Amt: ${calculateTotalAmount(cartItem.box, cartItem.rate)} \n Total Pcs: ${cartItem.qty}'),
                                      trailing: /* GestureDetector(
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              int initialValue = cartItem.qty;

                                              return AlertDialog(
                                                title: Text('Enter Quantity'),
                                                content: TextField(
                                                  controller: TextEditingController(
                                                      text:
                                                          initialValue.toString()),
                                                  keyboardType: TextInputType.phone,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      double parsedValue =
                                                          double.tryParse(
                                                                  newValue) ??
                                                              0;
                                                      print(parsedValue);
                                                      newQuantity =
                                                          (double.tryParse(
                                                                  newValue))
                                                              .toInt();
                                                      print(
                                                          'newQuantity${double.tryParse(newValue).toInt()}');
                                                    });
                                                  },
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () async {
                                                      // update the item and refresh the page

                                                      await CartDatabaseHelper
                                                          .instance
                                                          .updateCartItemQty(
                                                              cartItem.product,
                                                              cartItem.size,
                                                              (newQuantity)
                                                                  .toInt());
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Item Qty Updated in cart'),
                                                        ),
                                                      );
                                                      _loadCartItems();
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        */
                                          SizedBox(
                                        width: 60,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    int initialValue =
                                                        cartItem.qty;
                                                    int newQuantity =
                                                        initialValue; // Initialize newQuantity here

                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Enter Quantity'),
                                                      content: TextField(
                                                        controller:
                                                            TextEditingController(
                                                                text: initialValue
                                                                    .toString()),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            // Parse the input value properly
                                                            int parsedValue =
                                                                int.tryParse(
                                                                        newValue) ??
                                                                    0;
                                                            newQuantity =
                                                                parsedValue; // Update newQuantity
                                                          });
                                                        },
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () async {
                                                            // update the item and refresh the page
                                                            await CartDatabaseHelper
                                                                .instance
                                                                .updateCartItemQty(
                                                                    cartItem
                                                                        .product,
                                                                    cartItem
                                                                        .size,
                                                                    newQuantity); // Pass newQuantity directly
                                                            _loadCartItems();
                                                            _init();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Item Qty Updated in cart'),
                                                              ),
                                                            );
                                                            _loadCartItems();
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
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                // Delete the item and refresh the page
                                                _deleteCartItem(
                                                    cartItem.product,
                                                    cartItem.size);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Item removed from cart'),
                                                  ),
                                                );
                                                _loadCartItems();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

/* onTap: () {
                                          // Delete the item and refresh the page
                                          _updateCartItemQty(
                                              cartItem.product, cartItem.size, 0);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Item Qty Updated in cart'),
                                            ),
                                          );
                                          _loadCartItems();
                                        },*/ /*
                                      ),*/
                                      /*const SizedBox(width: 10),
                                          GestureDetector(
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onTap: () {
                                              // Delete the item and refresh the page
                                              _deleteCartItem(
                                                  cartItem.product, cartItem.size);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Item removed from cart'),
                                                ),
                                              );
                                              _loadCartItems();
                                            },
                                          ),*/
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (totalQty.text != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Qty : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(double.parse(totalQty.text)
                                        .toStringAsFixed(0)),
                                  ],
                                ),
                              ),
                              if (totalBox.text != null)
                                Row(
                                  children: [
                                    const Text(
                                      'Box : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(double.parse(totalBox.text)
                                        .toStringAsFixed(0)),
                                  ],
                                ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Amt : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text((double.parse(totalValue.text) -
                                            (double.parse(totalValue.text) *
                                                (dis1 / 100)))
                                        .toStringAsFixed(2)),
                                  ],
                                ),
                              ),
                            ],
                          ), // Display the updated value
                      ],
                    ),
                    // Text(
                    //     'Total Amount : ${totalValue.text}'), // Display the updated value
                  ],
                ),
              ),
        /*body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 650,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = _cartItems[index];
                    totalAmount +=
                        calculateTotalAmount(cartItem.qty, cartItem.rate);
                    totalValue.text =
                        totalAmount.toString(); // Convert totalAmount to string
                    print(totalAmount);
                    print(totalAmount);
                    return ListTile(
                      title: Text(cartItem.product),
                      subtitle: Text(
                          'Size: ${cartItem.size}  Rate: ${cartItem.rate}  Qty: ${cartItem.qty}  Amt: ${calculateTotalAmount(cartItem.qty, cartItem.rate)}'),
                      trailing: GestureDetector(
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          // Delete the item and refresh the page
                          _deleteCartItem(cartItem.product, cartItem.size);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item removed from cart'),
                            ),
                          );
                          _loadCartItems();
                        },
                      ),
                    );
                  },
                ),
              ),
              Text(
                  'Total Amount : ${totalValue.text}'), // Display the updated value
            ],
          ),
        ),*/
      ),
    );
  }

  void ShowCheckout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CartCheckoutView();
      },
    );
  }

  double calculateTotalAmount(int qty, String rate) {
    try {
      double disRange = 0;
      // double dis_range = (dis1 / 100) * double.parse(rate);
      double rateValue = double.parse(rate) - disRange;
      double totalamountCalce = qty * rateValue;
      print('data1');
      totalValue.text = totalValue.text;
      // _loadCartItems();

      // Convert totalAmount to string with two decimal places
      return double.parse(totalamountCalce.toStringAsFixed(2));
    } catch (e) {
      print('Error: Could not parse $rate as a valid number.');
      return 0.0; // or handle the error in an appropriate way for your use case
    }
  }
}

/*

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  CartScreen({Key key, this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 310,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return ListTile(
                title: Text(cartItem.product),
                subtitle: Text('Size: ${cartItem.size}  Qty: ${cartItem.qty}'),
                trailing: GestureDetector(
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    // Notify the parent widget to remove the item
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Item removed from cart'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
*/

class CartCheckoutView extends StatelessWidget {
  CartCheckoutView(
      {Key key,
      this.subTotal,
      this.user_type,
      this.discount,
      this.onPressed,
      this.buyer_name,
      this.yourData})
      : super(key: key);

  final String subTotal;
  final String user_type;
  final String buyer_name;
  final double discount;
  final Function onPressed;
  final List<Map<String, dynamic>> yourData;

  String selectedParty = '';
  TextEditingController textController = TextEditingController();
/*  List<Map<String, dynamic>> yourData = [
    {'party': 'test1'},
    {'party': 'test2'},
    {'party': 'test3'},
    {'party': 'test4'},
    {'party': 'test5'},
    {'party': 'test6'},
    {'party': 'test7'},
    {'party': 'test8'},
  ];*/

  @override
  Widget build(BuildContext context) {
    yourData.add({'party': buyer_name});
    print(user_type);
    print(yourData);
    return Container(
        height: 700,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Checkout",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black26,
              height: 1,
            ),
            /*    Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Text(
                        "Delivery Type",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  height: 1,
                ),
              ],
            ),*/
            /*if (user_type == 'Agent')
              SizedBox(
                height: 70,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Builder(
                          builder: (context) => TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                labelText: 'Party',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                isDense: true,
                              ),
                              controller:
                                  TextEditingController(text: coreParty),
                            ),
                            suggestionsCallback: (pattern) async {
                              List<String> partyNames = yourData
                                  .map((item) => item["party"]
                                      ?.toString()) // Use the safe navigation operator to prevent null exceptions
                                  .where((party) => party != null)
                                  .cast<String>()
                                  .toSet()
                                  .toList();
                              partyNames = partyNames
                                  .where((name) => name
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()))
                                  .toList();
                              print(partyNames); // Add a print statement here
                              return partyNames;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              coreParty = suggestion;
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              print(coreParty);
                              */ /*setStateCallback(() {
                              _party = suggestion;
                            });*/ /*
                              final partnerData = yourData.firstWhere(
                                (item) =>
                                    item["party"].toString() == suggestion,
                                orElse: () => null,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Bill value",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                              "₹ ${(double.parse(subTotal) - (double.parse(subTotal) * (5 / 105))).toStringAsFixed(2)}",
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Bill Discount",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                              "₹ ${((double.parse(subTotal) - (double.parse(subTotal) * (5 / 105))) * (discount / 100)).toStringAsFixed(2)}",
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "Sub Total",
                  //         style: GoogleFonts.poppins(
                  //           textStyle: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Text(
                  //             "\₹ ${double.parse(subTotal).toStringAsFixed(2)}",
                  //             textAlign: TextAlign.end,
                  //             style: GoogleFonts.poppins(
                  //               textStyle: TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 15,
                  //                   fontWeight: FontWeight.w500),
                  //             )),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Sub Total",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                              "₹ ${((double.parse(subTotal) - (double.parse(subTotal) * (5 / 105))) - ((double.parse(subTotal) - (double.parse(subTotal) * (5 / 105))) * (discount / 100))).toStringAsFixed(2)}",
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "Tax Value (Inclusive)",
                  //         style: GoogleFonts.poppins(
                  //           textStyle: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Text(
                  //           "\₹ ${((double.parse(subTotal)) * (5 / 100)).toStringAsFixed(2)}",
                  //           textAlign: TextAlign.end,
                  //           style: GoogleFonts.poppins(
                  //             textStyle: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.w500),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Tax Value",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "₹ ${((((double.parse(subTotal) - (double.parse(subTotal) * (5 / 105))) - ((double.parse(subTotal) - (double.parse(subTotal) * (5 / 100))) * (discount / 100)))) * (5 / 100)).toStringAsFixed(2)}",
                            textAlign: TextAlign.end,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "Discount ",
                  //         style: GoogleFonts.poppins(
                  //           textStyle: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Text(
                  //           "- \₹ ${(double.parse(subTotal) * (discount / 100)).toStringAsFixed(2)}",
                  //           textAlign: TextAlign.end,
                  //           style: GoogleFonts.poppins(
                  //             textStyle: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 15,
                  //                 fontWeight: FontWeight.w500),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            CheckoutRow(
              title: "Grand Total",
              value:
                  "₹ ${(double.parse(subTotal) - (double.parse(subTotal) * (discount / 100))).toStringAsFixed(2)}",
              onPressed: () {
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                print((double.parse(subTotal) -
                        (double.parse(subTotal) * (discount / 100)))
                    .toStringAsFixed(2));
                showDialog(
                    context: context,
                    builder: (context) {
                      return const Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 20),
                        // child: ErrorView(),
                      );
                    });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500),
                  ),
                  children: [
                    const TextSpan(
                      text: "By continuing you agree to our ",
                    ),
                    TextSpan(
                        text: "Terms",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Terms of Service Click");
                          }),
                    const TextSpan(text: " and "),
                    TextSpan(
                        text: "Privacy Policy.",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Privacy Policy Click");
                          })
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     side: BorderSide(color: Colors.black, width: 2),
                      //     backgroundColor:
                      //         Colors.white, // set the background color
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(
                      //           20), // set the border radius
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //
                      //   },
                      //   child:
                      GestureDetector(
                        onTap: () {
                          onPressed();
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
                                    '   Place Order',
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}

class CheckoutRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onPressed;

  const CheckoutRow({Key key, this.title, this.value, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 23.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.black26,
            height: 1,
          ),
        ],
      ),
    );
  }
}
