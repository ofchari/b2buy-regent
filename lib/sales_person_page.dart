import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:b2buy/home_page.dart';
import 'package:b2buy/layers/product_page.dart';
import 'dart:convert';
import 'universalkey.dart';
import 'package:b2buy/user_profile_page.dart';
/*
class Sales_person_dashboard extends StatefulWidget {
  Sales_person_dashboard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Sales_person_dashboard();
}

class _Sales_person_dashboard extends State<Sales_person_dashboard> {
*/

String apiKey1 = "3c966af1562b29d"; //3pin
String apiKey = nrg_api_Key; //nrg
String apiSecret1 = "d3948302cc8874c"; //3pin
String apiSecret = nrg_api_secret; //nrg

class Sales_person_dashboard extends StatefulWidget {
  const Sales_person_dashboard({Key key}) : super(key: key);

  @override
  _Sales_person_dashboardState createState() => _Sales_person_dashboardState();
}

class _Sales_person_dashboardState extends State<Sales_person_dashboard> {
  int doctypeCount = 0;
  String grandfinal = '';
  int doctypeCountmon = 0;
  String grandfinalmon = '0';

  @override
  void initState() {
    super.initState();
    fetchDatamonth();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final credentials = '631d1cad61d47fc:6a4d3d6082236c6';
  // final credentials = '9f54141c80448fd:cb13840f678bb29';

  Future<void> fetchData() async {
    // Future<List<dynamic>> fetchData() async {
    DateTime now = DateTime.now();
    List<String> dateTimeParts = now.toString().split(' ');
    if (dateTimeParts.isNotEmpty) {
      String datePart = dateTimeParts[0];
      print('Date Part: $datePart');
    }
    String today = DateTime.now().toLocal().toString().split(' ')[0];
    print('Today: $today');

    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(
      Uri.parse(
          '$http_key://$core_url/api/resource/Order%20Form?fields=["name","total_box"]&filters=[["date", "=", "$today"]]&limit_page_length=50000'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );
    print(response.statusCode);
    print(DateTime.now());

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body)["data"];
      });
      final data = json.decode(response.body)["data"];

      // Calculate the sum of total_qty values
      /*  int grandsum = 0;
      for (var item1 in data) {
        // Check if the value is not null and is a valid integer
        if (item1["total_box"] != null && item1["total_box"] is double) {
          // Convert the string to an integer and round it
          grandsum += ((int.parse(item1["total_box"])).round()) as int;
        } else {
          // Handle the case where the value is not a valid integer
          print("Invalid total_box value: ${item1["total_box"]}");
        }
      }*/

      double grandsum1 = 0;
      for (var item1 in data) {
        grandsum1 += item1["total_box"];
      }
      String grandfinal1 = grandsum1.toString();
      List<String> parts = grandfinal1.split('.');
      String result = parts[0];

      doctypeCount = data.length;
      grandfinal = result; // Convert to int
      print("Sum of total_box values: $grandsum1");
      print("Sum of total_box values: $grandfinal");
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDatamonth() async {
    // Future<List<dynamic>> fetchData() async {
    // Get the first date of the current month
    DateTime now = DateTime.now();
    String firstDayOfCurrentMonth =
        DateTime(now.year, now.month, 1).toLocal().toString().split(' ')[0];

    // Get the first date of the next month
    String firstDayOfNextMonth =
        DateTime(now.year, now.month + 1, 1).toLocal().toString().split(' ')[0];

    print("First day of current month: $firstDayOfCurrentMonth");
    print("First day of next month: $firstDayOfNextMonth");

    // DateTime now = DateTime.now();
    List<String> dateTimeParts = now.toString().split(' ');
    if (dateTimeParts.isNotEmpty) {
      String datePart = dateTimeParts[0];
      print('Date Part: $datePart');
    }
    String year =
        (DateTime.now().toLocal().toString().split(' ')[0]).split('-')[0];
    String month =
        (DateTime.now().toLocal().toString().split(' ')[0]).split('-')[1];

    print('Today:$year - $month');

    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(
      Uri.parse(
          '$http_key://$core_url/api/resource/Order%20Form?fields=["name","total_box","date"]&limit_page_length=50000&filters=[["date", ">=", "$firstDayOfCurrentMonth"], ["date", "<", "$firstDayOfNextMonth"]]'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );
    print(response.statusCode);
    print(DateTime.now());

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body)["data"];
      });
      final data = json.decode(response.body)["data"];

      // Calculate the sum of total_qty values
      /*  int grandsum = 0;
      for (var item1 in data) {
        // Check if the value is not null and is a valid integer
        if (item1["total_box"] != null && item1["total_box"] is double) {
          // Convert the string to an integer and round it
          grandsum += ((int.parse(item1["total_box"])).round()) as int;
        } else {
          // Handle the case where the value is not a valid integer
          print("Invalid total_box value: ${item1["total_box"]}");
        }
      }*/

      double grandsum1 = 0;
      for (var item1 in data) {
        grandsum1 += item1["total_box"];
      }
      String grandfinal1 = grandsum1.toString();
      List<String> parts = grandfinal1.split('.');
      String result = parts[0];

      doctypeCountmon = data.length;
      grandfinalmon = result; // Convert to int
      // print("Sum of total_box values: $grandsum1");
      // print("Sum of total_box values: $grandfinal");
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now());
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        const SizedBox(
          height: 35,
        ),
        Row(
          children: [
            const SizedBox(
              width: 25,
            ),
            /*Image.asset(
              "images/ic_launcher1.png",
              width: 60,
              height: 60,
            ),*/
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserProfilePage()));
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/ic_launcher1.png"),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 35,
            ),
            const Text("Overview Page",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xfff3ddd0)),
          child: Stack(children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text("Hello, User!                              ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 22,
                    ),
                    Container(
                      width: 140,
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffd89167)),
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 22,
                                ),
                                Text("$doctypeCount",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Today Order's",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 190,
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffd89167)),
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 22,
                                ),
                                Text(grandfinal,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Today Qty",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 22,
                    ),
                    Container(
                      width: 190,
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffd89167)),
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 22,
                                ),
                                Text("$doctypeCountmon",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Total Order's",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 140,
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffd89167)),
                      child: Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 22,
                                ),
                                Text(grandfinalmon,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Total Qty",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Navigation                             ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    )),
                const SizedBox(
                  height: 30,
                ),
                /* GestureDetector(
                  onTap: () {
                    // Add your onTap function logic here
                    // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
                  },
                  child: Container(
                    width: 350,
                    height: 116,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD89167),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    child: Stack(children: <Widget>[
                      Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFD89167),
                              elevation:
                                  0, // Set the button color to transparent
                            ),
                            onPressed: () {
                              // Handle button press
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: 61,
                                  height: 24,
                                  decoration: ShapeDecoration(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Order',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Order Form',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                ),*/
                InkWell(
                  onTap: () {
                    // Add your onTap function logic here
                    // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
                  },
                  child: Container(
                    width: 350,
                    height: 116,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFD89167),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        onTap: () {
                          // Handle button press
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DocumentListScreen()));
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                Container(
                                  width: 61,
                                  height: 24,
                                  decoration: ShapeDecoration(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Order',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Order Form',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                /*Container(
                  width: 350,
                  height: 116,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD89167),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  child: Stack(children: <Widget>[
                    Column(children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFD89167),
                          elevation: 0, // Set the button color to transparent
                        ),
                        onPressed: () {
                          // Handle button press
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 80,
                              height: 24,
                              decoration: ShapeDecoration(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Product',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Product List',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ]),
                ),*/
                InkWell(
                  onTap: () {
                    print("done'");
                    // Add your onTap function logic here
                    // For example:
                  },
                  child: Container(
                    width: 350,
                    height: 116,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFD89167),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const product_page()));
                          // Handle button press
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                Container(
                                  width: 80,
                                  height: 24,
                                  decoration: ShapeDecoration(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Product',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Product List',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          ]),
        ),
      ],
    )));
  }
}
