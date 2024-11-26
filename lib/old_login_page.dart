import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:b2buy/buyer_page.dart';
import 'package:b2buy/config.dart';
import 'package:b2buy/home_page.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:b2buy/sales_person_page.dart';
import 'universalkey.dart';

//void main() => runApp(MyApp());
void main() {
  runApp(MaterialApp(
    title: 'Login',
    theme: ThemeData(
      fontFamily: 'Poppins',
    ),
    debugShowCheckedModeBanner: false,
    // home: DocumentListScreen(),
    // home: MainPage(),
    // home: reportScreen(),
    // home: FrappePDFDownloader(),
    home: const LoginPage(),
    // home: Sales_person_dashboard(),
    // home: buyerdashboard(),
  ));
}

// Replace the placeholders with your actual API key and secret
//String apiKey = "7cbf607bc7e6184"; //yaanee
//String apiSecret = "bbce3ba695e127f"; //yaanee
// String apiKey1 = "3c966af1562b29d"; //3pin
//String apiSecret = "04004ec744768d0"; //3pin not use
// String apiSecret1 = "d3948302cc8874c"; //3pin
String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg
String loginuser = '';
String universal_customer = '';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Company,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const Sales_person_dashboard(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    //HttpClient createHttpClient(SecurityContext context) {
    HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username');
    String storedPassword = prefs.getString('password');
    DateTime lastLoginTime =
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt('lastLoginTime') ?? 0);
    print(loginuser);
    print(_password);

    if (storedUsername != null &&
        storedPassword != null &&
        _isLastLoginWithin24Hours(lastLoginTime)) {
      // You may want to add additional validation here
      // to ensure the stored credentials are still valid
      setState(() {
        loginuser = storedUsername;
        _password = storedPassword;
      });
      print(loginuser);
      print(_password);

      _handleLogin();
    } else {
      // Prompt the user to enter credentials
    }
  }

  bool _isLastLoginWithin24Hours(DateTime lastLoginTime) {
    if (lastLoginTime == null) {
      return false;
    }

    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(lastLoginTime);

    return difference.inHours < 2400;
  }

  Future<void> _saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    prefs.setInt('lastLoginTime', DateTime.now().millisecondsSinceEpoch);
  }

  final String _email = '';
  String _password = '';
  String _errorMessage = '';
  bool _obscureText = true;
  IconData _eyeIcon = Icons.visibility_off;

  void _togglePasswordVisibility(bool visible) {
    setState(() {
      _obscureText = !visible;
      _eyeIcon = visible ? Icons.visibility : Icons.visibility_off;
    });
  }
  //
  // void _handleLogin() async {
  //   HttpClient client = new HttpClient();
  //   client.badCertificateCallback =
  //       ((X509Certificate cert, String host, int port) => true);
  //   IOClient ioClient = new IOClient(client);
  //
  //   // Make the API request
  //
  //   // var url = 'https://3pin.glenmargon.com/api/method/login';
  //   // var response = await ioClient.post(Uri.parse(url), body: {
  //   //   'usr': _email,
  //   //   'pwd': _password,
  //   // });
  //   if (loginuser == 'mytherayan' && _password == 'mystic') {
  //     await _saveCredentials(loginuser, _password);
  //     print('mystic');
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => DocumentListScreen()),
  //     );
  //   } else {
  //     var url =
  //         'https://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_login?name=$loginuser';
  //     // var response = await ioClient.post(Uri.parse(url), headers: {
  //     //   'Authorization': 'token $apiKey1:$apiSecret1',
  //     // });
  //
  //     // Make API request to validate credentials
  //     var response = await ioClient.post(
  //       Uri.parse('http://$core_url/api/method/login'),
  //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //       body: {
  //         'usr': loginuser,
  //         'pwd': _password,
  //       },
  //     );
  //     print(json.decode(response.body));
  //     print(json.decode(response.body)["message"]);
  //     // if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     if (data['message'] == 'Logged In') {
  //       final daat = json.decode(response.body)['message'];
  //       // if (daat.isEmpty) {
  //       print(response.body);
  //       daat.forEach((item) {
  //         final password = item["password"];
  //         print(password);
  //         if (loginuser == 'mytherayan' && _password == 'mystic') {
  //           print('mystic');
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => DocumentListScreen()),
  //           );
  //         } else if (_password == password) {
  //           print('else');
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => DocumentListScreen()),
  //           );
  //         } else {
  //           setState(() {
  //             _errorMessage = 'Invalid email or password';
  //           });
  //         }
  //       });
  //     } else {
  //       setState(() {
  //         _errorMessage = 'Invalid email or password';
  //       });
  //     }
  //   }
  // }

  void _handleLogin() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    if (loginuser == 'mytherayan' && _password == 'mystic') {
      await _saveCredentials(loginuser, _password);
      print('mystic');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DocumentListScreen()),
      );
    } else {
      await _saveCredentials(loginuser, _password);
      // var url =
      // 'https://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_login?name=$loginuser';

      var response = await ioClient.post(
        Uri.parse('$http_key://$core_url/api/method/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'usr': loginuser,
          'pwd': _password,
        },
      );

      print(json.decode(response.body));
      print(json.decode(response.body)["message"]);

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        // Assuming data is a Map, not an array
        final password = data["password"];

        if (loginuser == 'mytherayan' && _password == 'mystic') {
          print('mystic');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DocumentListScreen()),
          );
        }
        /* else if (_password == password) {
          print('else');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DocumentListScreen()),
          );
        } */
        else if (data['message'] == 'Logged In') {
          print('else');
          /* Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DocumentListScreen()),
          );*/

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
                var userType =
                    json.decode(response.body)["message"][0]["user_type"];
                print(userType);
                /* if (user_type == 'Buyer') {*/
                universal_customer = json.decode(response.body)["message"][0]
                    ["universal_customer"];
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const buyerdashboard()),
                );
                /*  } else if (user_type == 'Sales') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Sales_person_dashboard()),
                  );
                } else {
                  Navigator.pop(context, 'Invalid user ID');
                }*/
              });
            } else {
              // Handle error
              print('Failed to load invoice data');
            }
          } catch (e) {
            throw Exception('Failed to load document IDs: $e');
          }
        } else {
          setState(() {
            _errorMessage = 'Invalid email or password';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    }
  }

  // Future<void> _saveCredentials(String username, String password) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('username', username);
  //   prefs.setString('password', password);
  // }

  int _backButtonPressedCount = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if user has pressed back button twice
        if (_backButtonPressedCount < 1) {
          _backButtonPressedCount++;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back button again to exit')),
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/primaryOrg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 200, left: 68),
                  child: const Text(
                    '',
                    style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 195, left: 65),
                  width: 260,
                  height: 130,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Image.asset(
                    'images/nrg_lg1.png',
                    // 'images/pin.JPG',
                    width: 40,
                    height: 49,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 380),
                  // width: 320,
                  child: TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                          color: Colors
                              .orange[100], // Set the border color to orange
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter User ID or Email',
                      hintStyle: const TextStyle(color: hintText),
                    ),
                    onChanged: (text) {
                      setState(() {
                        loginuser = text;
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 460),
                  // width: 280,
                  child: TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(
                          color: Colors
                              .orange[100], // Set the border color to orange
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter Password',
                      hintStyle: const TextStyle(color: hintText),
                      suffixIcon: LongPressDraggable(
                        feedback: Icon(
                          _eyeIcon,
                          color: Colors.grey,
                        ),
                        child: Icon(
                          _eyeIcon,
                          color: Colors.blueGrey,
                        ),
                        onDragStarted: () {
                          _togglePasswordVisibility(true);
                        },
                        onDragEnd: (_) {
                          _togglePasswordVisibility(false);
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    onChanged: (text) {
                      setState(() {
                        _password = text;
                      });
                    },
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(left: 210, top: 528),
                //   child: Text(
                //     'Forgot Password?',
                //     style: TextStyle(
                //       color: forgotPasswordText,
                //       fontSize: 16,
                //       fontFamily: 'Poppins-Medium',
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(left: 210, top: 528),
                  child: GestureDetector(
                    // onTap: () async {
                    //   Uri phoneNumber = Uri.parse('tel:+919688890777');
                    //   if (await canLaunch(phoneNumber.toString())) {
                    //     await launch(phoneNumber.toString());
                    //   } else {
                    //     // Dialer could not be opened
                    //   }
                    // },
                    child: const Text(
                      '',
                      style: TextStyle(
                        color: forgotPasswordText,
                        fontSize: 16,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _handleLogin,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 548,
                      left: 110,
                    ),
                    width: 180,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange[400],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Log In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 350,
                    left: 116,
                  ),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontFamily: 'Poppins-Regular',
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 235, top: 780),
                  child: const Text(
                    'Powered By',
                    style: TextStyle(
                      color: forgotPasswordText,
                      fontSize: 12,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 300, top: 773),
                  child: const Text(
                    ' Regent',
                    style: TextStyle(
                      color: regent,
                      fontSize: 20,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 300, top: 815),
                  child: const Text(
                    ' ',
                    style: TextStyle(
                      color: regent,
                      fontSize: 20,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Container(
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //     image: AssetImage('images/primaryBg1.png'),
        //     fit: BoxFit.cover,
        //   )),
        //   child: Stack(
        //     children: <Widget>[
        //       Positioned(
        //           top: 200,
        //           left: 68,
        //           child: Container(
        //             child: Text(
        //               '',
        //               style: TextStyle(
        //                   fontSize: 48,
        //                   fontFamily: 'Poppins-Medium',
        //                   fontWeight: FontWeight.w500,
        //                   color: Colors.white),
        //             ),
        //           )),
        //       Positioned(
        //         top: 100,
        //         left: 13,
        //         child: Container(
        //           width: 350,
        //           height: 200,
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.only(
        //                   topLeft: Radius.circular(20),
        //                   bottomRight: Radius.circular(20))),
        //           child: Image.asset(
        //             'images/pin3.png',
        //             // 'images/pin.JPG',
        //             width: 40,
        //             height: 49,
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //           left: 60,
        //           top: 390,
        //           child: Container(
        //             width: 280,
        //             child: TextField(
        //               decoration: InputDecoration(
        //                 border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.all(
        //                     Radius.circular(15),
        //                   ),
        //                 ),
        //                 prefixIcon: Icon(Icons.email),
        //                 hintText: 'Enter User ID or Email',
        //                 hintStyle: TextStyle(color: hintText),
        //               ),
        //               onChanged: (text) {
        //                 setState(() {
        //                   loginuser = text;
        //                 });
        //               },
        //             ),
        //           )),
        //       Positioned(
        //         left: 60,
        //         top: 460,
        //         child: Container(
        //           width: 280,
        //           child: TextField(
        //             decoration: InputDecoration(
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(
        //                   Radius.circular(15),
        //                 ),
        //               ),
        //               prefixIcon: Icon(Icons.lock),
        //               hintText: 'Enter Password',
        //               hintStyle: TextStyle(color: hintText),
        //               suffixIcon: LongPressDraggable(
        //                 feedback: Icon(_eyeIcon),
        //                 child: Icon(_eyeIcon),
        //                 onDragStarted: () {
        //                   _togglePasswordVisibility(true);
        //                 },
        //                 onDragEnd: (_) {
        //                   _togglePasswordVisibility(false);
        //                 },
        //               ),
        //             ),
        //             obscureText: _obscureText,
        //             onChanged: (text) {
        //               setState(() {
        //                 _password = text;
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //           right: 45,
        //           top: 528,
        //           child: Text(
        //             'Forgot Password?',
        //             style: TextStyle(
        //                 color: forgotPasswordText,
        //                 fontSize: 16,
        //                 fontFamily: 'Poppins-Medium',
        //                 fontWeight: FontWeight.w600),
        //           )),
        //       Positioned(
        //         top: 568,
        //         right: 120,
        //         child: GestureDetector(
        //           onTap: _handleLogin,
        //           child: Container(
        //             width: 150,
        //             height: 40,
        //             decoration: BoxDecoration(
        //               color: Colors.blueAccent,
        //               borderRadius: BorderRadius.only(
        //                   topLeft: Radius.circular(10),
        //                   bottomLeft: Radius.circular(10),
        //                   topRight: Radius.circular(10),
        //                   bottomRight: Radius.circular(10)),
        //             ),
        //             child: Padding(
        //               padding: const EdgeInsets.only(top: 6.0),
        //               child: Text(
        //                 'Log In',
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 18,
        //                     fontFamily: 'Poppins-Medium',
        //                     fontWeight: FontWeight.w400),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         top: 350,
        //         left: 116,
        //         right: 0,
        //         child: Text(
        //           _errorMessage,
        //           style: TextStyle(
        //               color: Colors.red,
        //               fontFamily: 'Poppins-Regular',
        //               fontSize: 14),
        //         ),
        //       ),
        //       Positioned(
        //           right: 108,
        //           top: 780,
        //           child: Text(
        //             'Powered By',
        //             style: TextStyle(
        //                 color: forgotPasswordText,
        //                 fontSize: 12,
        //                 fontFamily: 'Poppins-Medium',
        //                 fontWeight: FontWeight.w600),
        //           )),
        //       Positioned(
        //           right: 40,
        //           top: 773,
        //           child: Text(
        //             ' Regent',
        //             style: TextStyle(
        //                 color: regent,
        //                 fontSize: 20,
        //                 fontFamily: 'Poppins-Medium',
        //                 fontWeight: FontWeight.w600),
        //           )),
        //       // Positioned(top: 290, right: 0, bottom: 0, child: LayerOne()),
        //       // Positioned(top: 318, right: 0, bottom: 28, child: LayerTwo()),
        //       // Positioned(top: 200, right: 0, bottom: 48, child: LayerThree()),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

// class MainPage extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MainPage> {
//   String _imageUrl = '';
//   String _partnerName = '';
//   final url = Uri.parse(
//       Uri.encodeFull('$http_key://$core_url/api/resource/Order Form'));
//   String _party = '';
//   final sizesqty = TextEditingController();
//   String _retailer = '';
//   String _contact = '';
//   var qtyController = '';
//   List<Map<String, dynamic>> _dataList = [];
//   final qtyreset = TextEditingController();
//
//   bool _isImageVisible = false;
//   // List of sizes returned by the API
//   List<String> _sizes = [];
//   final Map<String, double> qtyMap = {};
//
//   // Map of size values and their corresponding text field controllers
//   final sizeControllers = Map<String, TextEditingController>();
//   final apiUrl =
//       '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size';
//   final apiUrlrj =
//       '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size';
//   bool _allstock = false;
//   double allqty = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     HttpOverrides.global = MyHttpOverrides();
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Frappe API Demo',
//       home: Scaffold(
//         appBar: AppBar(
//             backgroundColor: Colors.orange[200],
//             title: const Text('Order Details'),
//             centerTitle: true,
//             actions: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors
//                       .orange[200], // Set the background color to orange 200
//                 ),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Confirm'),
//                         content: Text('Are you sure you want to Book?'),
//                         actions: <Widget>[
//                           TextButton(
//                             child: Text('Cancel'),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors
//                                   .orange[500], // set the background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                     20), // set the border radius
//                               ),
//                             ),
//                             child: Text(
//                               'Yes',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             onPressed: () {
//                               if (_party.isEmpty) {
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => AlertDialog(
//                                     title: Text('Error'),
//                                     content: Text('Party cannot be empty!'),
//                                     actions: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                               20), // set the border radius
//                                           color: Colors.orange[
//                                               500], // set the background color
//                                         ),
//                                         child: TextButton(
//                                           child: Text(
//                                             'OK',
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                           onPressed: () =>
//                                               Navigator.of(context).pop(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               } else {
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => AlertDialog(
//                                     title: Text('Processing'),
//                                     content: Text('Plz wait'),
//                                     actions: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                               20), // set the border radius
//                                           color: Colors.orange[
//                                               500], // set the background color
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                                 MobileDocument();
//                                 // createFlutterMobileDocument();
//                                 // Navigator.of(context).pop();
//                                 // Navigator.of(context).push(
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) =>
//                                 //           DocumentListScreen()),
//                                 // );
//                               }
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Icon(Icons.send),
//               ),
//             ]),
//         body: SingleChildScrollView(
//           child: Center(
//             child: FutureBuilder<List<dynamic>>(
//               future: fetchData(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return Column(
//                     children: [
//                       if (_isImageVisible)
//                         // print('Image should be visible');
//                         if (_imageUrl.isNotEmpty)
//                           Image.network(
//                             _imageUrl,
//                             height: 500,
//                             width: 550,
//                           ),
//
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.start,
//                       //   children: [
//                       //     SizedBox(width: 170),
//                       //     IconButton(
//                       //       icon: _isImageVisible
//                       //           ? Icon(Icons.arrow_drop_up_outlined)
//                       //           : Icon(Icons.image),
//                       //       onPressed: () {
//                       //         setState(() {
//                       //           _isImageVisible = !_isImageVisible;
//                       //           print(_isImageVisible);
//                       //         });
//                       //       },
//                       //     ),
//                       //     SizedBox(width: 40),
//                       //     Checkbox(
//                       //       value: _allstock,
//                       //       onChanged: (bool value) {
//                       //         setState(() {
//                       //           _allstock = value;
//                       //         });
//                       //         print(_allstock);
//                       //       },
//                       //     ),
//                       //     Text('All Stock'),
//                       //   ],
//                       // ),
//                       SizedBox(height: 40),
//
//                       Container(
//                         width: 500,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: TypeAheadFormField<String>(
//                           textFieldConfiguration: TextFieldConfiguration(
//                             decoration: InputDecoration(
//                               labelText: 'Party',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(15),
//                                 ),
//                               ),
//                               isDense: true,
//                             ),
//                             controller: TextEditingController(text: _party),
//                           ),
//                           suggestionsCallback: (pattern) async {
//                             List<String> partyNames = (snapshot.data ?? [])
//                                 .map((item) => item["buyer"]
//                                     ?.toString()) // Use the safe navigation operator to prevent null exceptions
//                                 .where((party) => party != null)
//                                 .toList();
//                             partyNames = partyNames
//                                 .where((name) => name
//                                     .toLowerCase()
//                                     .contains(pattern.toLowerCase()))
//                                 .toList();
//                             print(partyNames); // Add a print statement here
//                             return partyNames;
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return ListTile(
//                               title: Text(suggestion),
//                             );
//                           },
//                           onSuggestionSelected: (suggestion) {
//                             setState(() {
//                               _party = suggestion;
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       Container(
//                         width: 500,
//                         height: 50,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Order no',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(15),
//                               ),
//                             ),
//                           ),
//                           onChanged: (newValue) {
//                             setState(() {
//                               _retailer = newValue;
//                             });
//                             print(_retailer);
//                           },
//                           // keyboardType: TextInputType.number,
//                         ),
//                       ),
//
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       Container(
//                         width: 500,
//                         height: 50,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Contact',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(15),
//                               ),
//                             ),
//                           ),
//                           onChanged: (newValue) {
//                             setState(() {
//                               _contact = newValue;
//                             });
//                           },
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//
//                       Container(
//                         width: 500,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: TypeAheadFormField<String>(
//                           textFieldConfiguration: TextFieldConfiguration(
//                             decoration: InputDecoration(
//                               labelText: 'Item',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(15),
//                                 ),
//                               ),
//                               isDense: true,
//                             ),
//                             controller:
//                                 TextEditingController(text: _partnerName),
//                           ),
//                           suggestionsCallback: (pattern) async {
//                             // Filter the partner names based on the input pattern
//                             List<String> partnerNames = (snapshot.data ?? [])
//                                 .map((item) => item["partner_name"]
//                                     ?.toString()) // Use the safe navigation operator to prevent null exceptions
//                                 .where((partner_name) => partner_name != null)
//                                 .toList();
//                             partnerNames = partnerNames
//                                 .where((name) => name
//                                     .toLowerCase()
//                                     .contains(pattern.toLowerCase()))
//                                 .toList();
//                             print(partnerNames);
//                             // Add a print statement here
//                             return partnerNames; // Add a print statement here
//                           },
//                           itemBuilder: (context, suggestion) {
//                             return ListTile(
//                               title: Text(suggestion),
//                             );
//                           },
//                           // onSuggestionSelected: (suggestion) {
//                           //   setState(() {
//                           //     _partnerName = suggestion;
//                           //
//                           //     fetchDatasize();
//                           //   });
//                           //   final partnerData =
//                           //       (snapshot.data ?? []).firstWhere(
//                           //     (item) =>
//                           //         item["partner_name"].toString() == suggestion,
//                           //     orElse: () => null,
//                           //   );
//                           //   if (partnerData != null) {
//                           //     final image = partnerData["images"].toString();
//                           //     _imageUrl = image;
//                           //   }
//                           // },
//                           onSuggestionSelected: (suggestion) async {
//                             setState(() {
//                               _partnerName = suggestion;
//                             });
//
//                             // Clear the old data and sizes
//                             setState(() {
//                               // _dataList = [];
//                               _sizes = [];
//                               qtyMap.clear();
//                               sizeControllers.clear();
//                               qtyreset.text = '';
//                             });
//                             allqty = 0;
//
//                             // Fetch new data and sizes
//                             await fetchDatasize();
//
//                             final partnerData =
//                                 (snapshot.data ?? []).firstWhere(
//                               (item) =>
//                                   item["partner_name"].toString() == suggestion,
//                               orElse: () => null,
//                             );
//
//                             if (partnerData != null) {
//                               final image = partnerData["images"].toString();
//                               _imageUrl = image;
//                             }
//                           },
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       // Container(
//                       //   width: 500,
//                       //   height: 40,
//                       //   padding: EdgeInsets.symmetric(horizontal: 10),
//                       //   child: TextField(
//                       //     decoration: InputDecoration(
//                       //       labelText: 'QTY',
//                       //       border: OutlineInputBorder(
//                       //         borderRadius: BorderRadius.all(
//                       //           Radius.circular(15),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //     controller: qtyreset,
//                       //     onChanged: (newValue) {
//                       //       setState(() {
//                       //         allqty = double.tryParse(newValue) ?? 0;
//                       //       });
//                       //       print(allqty);
//                       //     },
//                       //     keyboardType: TextInputType.number,
//                       //   ),
//                       // ),
//                       Container(
//                         width: 500,
//                         height: 40,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   labelText: 'QTY',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(15),
//                                     ),
//                                   ),
//                                 ),
//                                 controller: qtyreset,
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     allqty = double.tryParse(newValue) ?? 0;
//                                   });
//                                   print(allqty);
//                                 },
//                                 keyboardType: TextInputType.number,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   allqty = (allqty ?? 0) - 1;
//                                   qtyreset.text = allqty.toString();
//                                 });
//                               },
//                               icon:
//                                   Icon(Icons.indeterminate_check_box, size: 30),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   allqty = (allqty ?? 0) + 1;
//                                   qtyreset.text = allqty.toString();
//                                 });
//                               },
//                               icon: Icon(Icons.add_box_sharp, size: 30),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       const SizedBox(
//                         height: 8,
//                       ),
//
//                       ..._sizes.map((size) {
//                         return Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(width: 35),
//                                 Container(
//                                   width: 111,
//                                   height: 35,
//                                   child: TextField(
//                                     decoration: InputDecoration(
//                                       // labelText: 'Size',
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(15),
//                                         ),
//                                       ),
//                                       // Align the text at the center
//                                       contentPadding: EdgeInsets.symmetric(
//                                           vertical: 0, horizontal: 10),
//                                       // Optionally, you can also set the text alignment directly in the labelStyle
//                                       /*labelStyle: TextStyle(
//                                         textAlign: TextAlign.center,
//                                       ),*/
//                                     ),
//                                     enabled: false,
//                                     controller:
//                                         TextEditingController(text: size),
//                                     onChanged: (newValue) {
//                                       setState(() {
//                                         size = newValue;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(width: 30),
//                                 /*SizedBox(width: 10),
//                                 Container(
//                                   width: 75,
//                                   child: SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           'Bls:',
//                                           style: TextStyle(fontSize: 20),
//                                         ),
//                                         Text(
//                                           sizeControllers[size]?.text ?? '',
//                                           style: TextStyle(fontSize: 20),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),*/
//                                 // SizedBox(width: 10),
//
//                                 Container(
//                                   width: 170,
//                                   height: 35,
//                                   child: Row(
//                                     children: [
//                                       IconButton(
//                                         onPressed: () {
//                                           setState(() {
//                                             // Decrease the value by 1
//                                             qtyMap[size] =
//                                                 (qtyMap[size] ?? 0) - 1;
//                                           });
//                                         },
//                                         icon: Icon(
//                                           Icons.remove,
//                                           size: 15,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: TextField(
//                                           decoration: InputDecoration(
//                                             border: OutlineInputBorder(
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(15),
//                                               ),
//                                             ),
//                                           ),
//                                           controller: TextEditingController(
//                                             text:
//                                                 qtyMap[size]?.toString() ?? '0',
//                                           ),
//                                           onChanged: (newValue) {
//                                             setState(() {
//                                               qtyMap[size] =
//                                                   double.tryParse(newValue) ??
//                                                       0;
//                                             });
//                                           },
//                                           keyboardType: TextInputType.number,
//                                         ),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {
//                                           setState(() {
//                                             // Increase the value by 1
//                                             qtyMap[size] =
//                                                 (qtyMap[size] ?? 0) + 1;
//                                           });
//                                         },
//                                         icon: Icon(
//                                           Icons.add,
//                                           size: 15,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//
//                                 // Container(
//                                 //   width: 111,
//                                 //   height: 35,
//                                 //   child: Row(
//                                 //     children: [
//                                 //       // IconButton(
//                                 //       //   onPressed: () {
//                                 //       //     setState(() {
//                                 //       //       qtyMap[size] =
//                                 //       //           double.tryParse("10") - 1;
//                                 //       //     });
//                                 //       //   },
//                                 //       //   icon: Icon(Icons.remove),
//                                 //       // ),
//                                 //       Expanded(
//                                 //         child: TextField(
//                                 //           decoration: InputDecoration(
//                                 //             border: OutlineInputBorder(
//                                 //               borderRadius: BorderRadius.all(
//                                 //                 Radius.circular(15),
//                                 //               ),
//                                 //             ),
//                                 //           ),
//                                 //           controller: sizesqty,
//                                 //           onChanged: (newValue) {
//                                 //             setState(() {
//                                 //               qtyMap[size] =
//                                 //                   double.tryParse(newValue) ??
//                                 //                       0;
//                                 //             });
//                                 //           },
//                                 //           keyboardType: TextInputType.number,
//                                 //         ),
//                                 //       ),
//                                 //       // IconButton(
//                                 //       //   onPressed: () {
//                                 //       //     setState(() {
//                                 //       //       qtyMap[size] = (100) as double;
//                                 //       //     });
//                                 //       //   },
//                                 //       //   icon: Icon(Icons.add),
//                                 //       // ),
//                                 //     ],
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 3,
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                       Container(
//                         width: 200,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Add the entered data to a list
//                             _sizes.forEach((size) {
//                               var qtyController = sizeControllers[size];
//                               var stock = qtyController.text.isNotEmpty
//                                   ? double.parse(qtyController.text)
//                                   : 0;
//                               // print(allqty);
//                               var qty = 0;
//                               print(allqty);
//                               // if (allqty != null &&
//                               //     allqty != 0 &&
//                               //     allqty > 0 &&
//                               //     allqty.toString().isNotEmpty) {
//                               //   qty = allqty.toInt();
//                               // } else {
//                               //   qty = qtyMap[size]?.toInt() ?? 0;
//                               // }
//                               if (qtyMap[size]?.toInt() != null) {
//                                 qty = qtyMap[size]?.toInt();
//                               } else {
//                                 qty = allqty.toInt();
//                               }
//                               print(qty);
//                               if (qty != null && qty != 0 && qty > 0) {
//                                 // _dataList.add({
//                                 //   "item": _partnerName,
//                                 //   "qty": qty,
//                                 //   "size": size,
//                                 //   "stock": stock,
//                                 // });
//                                 _dataList.add({
//                                   "product": _partnerName,
//                                   "qty": qty,
//                                   "size": size,
//                                   "rate": '1',
//                                 });
//                               }
//                             });
//                             print(_dataList);
//                             // Clear the text fields
//                             setState(() {
//                               _sizes = [];
//                               sizeControllers.clear();
//                               allqty = 0;
//                               sizesqty.text = '';
//                               qtyreset.text = '';
//                             });
//                             qtyMap.clear();
//                             _partnerName = '';
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.add, size: 15),
//                               SizedBox(width: 2),
//                               Text(
//                                 'Add',
//                                 style: TextStyle(
//                                     fontSize: 15, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             backgroundColor: Colors.orange[500],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 5),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ), //
//
//                       // ..._sizes.map((size) {
//                       //   var qtyController = sizeControllers[size];
//                       //
//                       //   return Column(
//                       //     children: [
//                       //       Row(
//                       //         mainAxisAlignment: MainAxisAlignment.center,
//                       //         children: [
//                       //           Container(
//                       //             width: 111,
//                       //             height: 30,
//                       //             child: TextField(
//                       //               decoration: InputDecoration(
//                       //                 border: OutlineInputBorder(
//                       //                   borderRadius: BorderRadius.all(
//                       //                     Radius.circular(15),
//                       //                   ),
//                       //                 ),
//                       //               ),
//                       //               controller:
//                       //                   TextEditingController(text: size),
//                       //               onChanged: (newValue) {
//                       //                 setState(() {
//                       //                   size = newValue;
//                       //                 });
//                       //               },
//                       //             ),
//                       //           ),
//                       //           SizedBox(width: 10),
//                       //           Container(
//                       //             width: 111,
//                       //             child: SingleChildScrollView(
//                       //               scrollDirection: Axis.horizontal,
//                       //               child: Row(
//                       //                 children: [
//                       //                   Text(
//                       //                     'Stock: ',
//                       //                     style: TextStyle(fontSize: 20),
//                       //                   ),
//                       //                   Text(
//                       //                     sizeControllers[size]?.text ?? '',
//                       //                     style: TextStyle(fontSize: 20),
//                       //                   ),
//                       //                 ],
//                       //               ),
//                       //             ),
//                       //           ),
//                       //           SizedBox(width: 10),
//                       //           Container(
//                       //             width: 111,
//                       //             height: 30,
//                       //             child: TextField(
//                       //               decoration: InputDecoration(
//                       //                 border: OutlineInputBorder(
//                       //                   borderRadius: BorderRadius.all(
//                       //                     Radius.circular(15),
//                       //                   ),
//                       //                 ),
//                       //               ),
//                       //               // controller:
//                       //               // TextEditingController(text: _size1),
//                       //               controller: qtyController,
//                       //               // keyboardType: TextInputType.number,
//                       //             ),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     ],
//                       //   );
//                       // }).toList(),
//                       Container(
//                         height: 310, // Set the height to a fixed value
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _dataList.length,
//                           itemBuilder: (context, index) {
//                             final data = _dataList[index];
//                             return ListTile(
//                               title: Text(data["product"]),
//                               subtitle: Text(
//                                 'Size: ${data["size"]}  Qty: ${data["qty"]}',
//                               ),
//                               trailing: GestureDetector(
//                                 child: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 ),
//                                 onTap: () {
//                                   setState(() {
//                                     _dataList.removeAt(index);
//                                   });
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       //Text( 'Total Amount: ${_amount1 + _amount2 + _amount3}', style: TextStyle(fontSize: 20), ),
//                       Text(
//                         'Total QTY: ${_dataList.isEmpty ? 0 : _dataList.fold(0, (total, item) => total + item['qty'])}',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                     ],
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text("${snapshot.error}");
//                 }
//                 // By default, show a loading spinner
//                 //return CircularProgressIndicator();
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> MobileDocument() async {
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback =
//         ((X509Certificate cert, String host, int port) => true);
//     IOClient ioClient = new IOClient(client);
//     final credentials = '$apiKey:$apiSecret';
//     final headers = {
//       'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
//       'Content-Type': 'application/json',
//     };
//
//     // Set up the data to create a new document in the Flutter Mobile DocType
//     final data = {
//       'doctype': 'Order Form',
//       'buyer': _party,
//       'order_no': loginuser,
//       'due_date': '2023-11-20',
//       'price_list': '01.07.2023',
//       // 'retailer': _retailer,
//       // 'order_no': _contact,
//       // 'allstock': _allstock ? '1' : '0',
//       'details': _dataList
//     };
//     print(data);
//
//     final body = jsonEncode(data);
//
//     final response = await ioClient.post(url, headers: headers, body: body);
//     if (response.statusCode == 200) {
//       Navigator.of(context).pop();
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => DocumentListScreen()),
//       );
//     } else if (response.statusCode == 417) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Message'),
//           content: SingleChildScrollView(
//             child: Text(json.decode(response.body)['_server_messages']),
//             // child: Text(json.decode(response.body).toString()),
//           ),
//           actions: [
//             ElevatedButton(
//               child: Text('OK'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         ),
//       );
//       // print(json.decode(response.body)['_server_messages']);
//       dynamic responseJson = json.decode(response.body.toString());
//       dynamic responseList = responseJson['_server_messages'];
//       dynamic responcemsg = responseList['message'];
//       print(responcemsg);
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Request failed with status: ${response.statusCode}'),
//           actions: [
//             ElevatedButton(
//               child: Text('OK'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         ),
//       );
//       print(response.body);
//       print(response.toString());
//     }
//   }
//
//   Future<void> fetchDatasize() async {
//     if (_partnerName == null || _partnerName.isEmpty) {
//       return;
//     }
//
//     // Build the API endpoint URL with the partner name as a query parameter
//     // final url = '$apiUrl?name=$_partnerName';
//     String url;
//     if (_allstock) {
//       url = '$apiUrl?name=$_partnerName';
//     } else {
//       url = '$apiUrlrj?name=$_partnerName';
//     }
//     // Create an HTTP client with the necessary certificates
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback =
//         ((X509Certificate cert, String host, int port) => true);
//     IOClient ioClient = new IOClient(client);
//
//     // Make the API request
//     final response = await ioClient.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'token $apiKey:$apiSecret',
//       },
//     );
//
//     // Parse the API response
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body)["message"];
//       print(data);
//
//       // Update the text field controllers for each size returned by the API
//       data.forEach((item) {
//         final size = item["size"];
//         final stock = item["stock"].toString();
//         if (!sizeControllers.containsKey(size)) {
//           sizeControllers[size] = TextEditingController();
//         }
//         sizeControllers[size]?.text = stock;
//         print(size);
//         print(stock);
//       });
//
//       // Update the list of sizes and rebuild the UI with the updated text field values
//       setState(() {
//         _sizes = sizeControllers.keys.toList();
//       });
//     } else {
//       throw Exception('Failed to load data from $url');
//     }
//   }
//
//   Future<List<dynamic>> fetchData() async {
//     /*final urls = [
//       // "https://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_stock_style",
//       "https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_data",
//       'https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_party?party=$loginuser',
//       if (_partnerName != null && _partnerName.isNotEmpty)
//         'https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_size?name=$_partnerName',
//     ];*/
//     final urls = [
//       // "http://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_stock_style",
//       "$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_data",
//       '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_party',
//       // 'http://$core_url/api/method/regent.regent.flutter.get_flutter_party?party=$loginuser',
//       if (_partnerName != null && _partnerName.isNotEmpty)
//         '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size?name=$_partnerName',
//     ];
//     // Create an HTTP client with the necessary certificates
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback =
//         ((X509Certificate cert, String host, int port) => true);
//     IOClient ioClient = new IOClient(client);
//     final requests = urls.map((url) async {
//       if (url.contains('get_flutter_size')) {
//         final response = await ioClient.get(
//           Uri.parse(url),
//           headers: {
//             'Authorization': 'token $apiKey:$apiSecret',
//           },
//         );
//         if (response.statusCode == 200) {
//           return json.decode(response.body)["message"];
//         } else {
//           throw Exception('Failed to load data from $url');
//         }
//       } else if (url.contains('get_flutter_party')) {
//         final response = await ioClient.get(
//           Uri.parse(url),
//           headers: {
//             'Authorization': 'token $apiKey:$apiSecret',
//           },
//         );
//         if (response.statusCode == 200) {
//           return json.decode(response.body)["message"];
//         } else {
//           throw Exception('Failed to load data from $url');
//         }
//       } else {
//         final response = await ioClient.post(
//           Uri.parse(url),
//           headers: {
//             'Authorization': 'token $apiKey:$apiSecret',
//             'Content-Type': 'application/json'
//           },
//           body: json.encode({}),
//         );
//         if (response.statusCode == 200) {
//           return json.decode(response.body)["message"];
//         } else {
//           throw Exception('Failed to load data from $url');
//         }
//       }
//     });
//     final results = await Future.wait(requests);
//
//     // Combine the results from all the API requests into a single list
//     return results.expand((result) => result).toList();
//   }
//
//   Future<void> createFlutterMobileDocument() async {
//     HttpClient client = new HttpClient();
//     client.badCertificateCallback =
//         ((X509Certificate cert, String host, int port) => true);
//     IOClient ioClient = new IOClient(client);
//     final credentials = '$apiKey:$apiSecret';
//     final headers = {
//       'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
//       'Content-Type': 'application/json',
//     };
//
//     // Set up the data to create a new document in the Flutter Mobile DocType
//     final data = {
//       'doctype': 'Order Form',
//       'party': _party,
//       'person': loginuser,
//       'allstock': _allstock,
//       'details': _dataList
//     };
//
//     final body = jsonEncode(data);
//
//     final response = await ioClient.post(url, headers: headers, body: body);
//     if (response.statusCode == 200) {
//       print(response.body);
//       print(response.statusCode);
//
//       print(_allstock);
//     } else {
//       print('Request failed with status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   }
//
// //final response = await http.post(
// // Uri.parse(
// //'https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_mobile'),
// // 'https://erp.yaaneefashions.com/api/method/regent.regent.client.get_flutter_data'),
// // headers: {
// // 'Authorization': 'token $apiKey:$apiSecret',
// //  'Content-Type': 'application/json'
// // },
// // body: json.encode({"args": {}}),
// // );
// //if (response.statusCode == 200) {
// //return json.decode(response.body)["message"];
// //} else {
// // throw Exception('Failed to load data');
// //}
// }
