import 'dart:convert';
import 'package:b2buy/admin_page.dart';
import 'package:b2buy/agent_page.dart';
import 'package:b2buy/agent_regsiter.dart';
import 'package:b2buy/call_notification.dart';
import 'package:b2buy/dash_product.dart';
import 'package:b2buy/sample.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:b2buy/buyer_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:b2buy/home_page.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:b2buy/splash_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'About_drawer.dart';
import 'customer_register_page.dart';
import 'universalkey.dart';
import 'package:google_fonts/google_fonts.dart';

//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.subscribeToTopic('allDevices');
  } catch (e) {
    print('Firebase already initialized: $e');
  }
  runApp(GetMaterialApp(
      title: 'Login',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      // home: DocumentListScreen(),
      // home: MainPage(),
      // home: reportScreen(),
      // home: FrappePDFDownloader(),
      home: const SplashPage()
      // LoginPage(),
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
    return GetMaterialApp(
      // getPages: [
      //   GetPage(name: "/ce", page: () => buyerdashboard()),
      //   GetPage(name: "/pe", page: () => AgentOutStandingReport()),
      //   GetPage(name: "/cuu", page: () => custo()),
      //   GetPage(name: "/pro", page: () => product_page()),
      // ],
      debugShowCheckedModeBanner: false,
      title: Company,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const custo(),
      // home: LoginPage(),
      // home: LoginPage(),
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

  String aboutUs = '';

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
  bool _obscureText = false;
  IconData _eyeIcon = Icons.visibility_off;

  void _togglePasswordVisibility(bool visible) {
    setState(() {
      _obscureText = !visible;
      _eyeIcon = visible ? Icons.visibility : Icons.visibility_off;
    });
  }

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
        } else if (data['message'] == 'Logged In') {
          print('else');

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
                universal_customer = json.decode(response.body)["message"][0]
                    ["universal_customer"];

                if (userType == 'Customer') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const buyerdashboard()),
                  );
                }
                if (userType == 'Admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const adm()),
                  );
                }
                if (userType == 'Agent') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const sale()),
                  );
                }
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

  // About us //
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
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["data"];
        if (responseData.isNotEmpty) {
          var aboutUs = (responseData[0]["custom_about_us"]).toString();
          print(aboutUs);
          // Navigate to About page
          Get.to(About(about_us: aboutUs));
        } else {
          print('Response data is empty');
        }
      } else {
        print('Failed to load company data');
      }
    } catch (e) {
      throw Exception('Failed to load company data: $e');
    }
  }

  // Contact us
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
                  _launchEmail("customer.sbtcc@gmail.com");
                },
                child: const Text(
                  "   📧   customer.sbtcc@gmail.com",
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

  Future<void> _lauchabout(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  int _backButtonPressedCount = 0;

  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
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
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            // color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 80.0, right: 20.0, left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final Uri url =
                                Uri.parse('https://www.frosenfox.com/about');
                            _lauchabout(url);
                          },
                          child: Text(
                            "About Us",
                            style: GoogleFonts.dmSans(
                                textStyle: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showFaqDialog(context);
                          },
                          child: Text(
                            "FAQ",
                            style: GoogleFonts.dmSans(
                                textStyle: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showContactDetailsDialog(context);
                          },
                          child: Text(
                            "Contact",
                            style: GoogleFonts.dmSans(
                                textStyle: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Container(
                      height: height / 8,
                      width: width / 4,
                      decoration: const BoxDecoration(
                          // color: Colors.white,
                          //   shape: BoxShape.circle,
                          image: DecorationImage(
                              // image: NetworkImage(
                              //     "http://sribalajitexknit.regenterp.com/files/logo__1_-1-removebg-preview.png"),
                              image: AssetImage('images/balajilogo29624.PNG'),
                              fit: BoxFit.contain)),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Sri Balaji Texknit",
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Text(
                          " Clothing Co",
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  )),
                  Container(
                    height: height / 6,
                    width: width / 1.2,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Container(
                          height: height / 16,
                          width: width / 1.4,
                          decoration: BoxDecoration(
                              // color: Colors.black,
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 20,
                              ),
                              hintText: "Username",
                              hintStyle: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            onChanged: (text) {
                              setState(() {
                                loginuser = text;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: height / 16,
                            width: width / 1.4,
                            decoration: BoxDecoration(
                                // color: Colors.black,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                hintText: "Password",
                                hintStyle: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              obscureText: _obscureText,
                              onChanged: (text) {
                                setState(() {
                                  _password = text;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleLogin,
                    child: Container(
                      height: height / 18,
                      width: width / 3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text(
                        "Log In",
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Divider(
                  //   height: 10,
                  //   thickness: 1,
                  //   indent: 20,
                  //   endIndent: 20,
                  // ),
                  const SizedBox(
                    height: 120,
                  ),
                  SizedBox(
                    height: 40, // Set your desired height here
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerRegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Customer Register",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 20.0, left: 8.0),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AgentRegister(),
                              ),
                            );
                          },
                          child: Text(
                            "Agent Register",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {
  String _imageUrl = '';
  String _partnerName = '';
  final url = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Order Form'));
  String _party = '';
  final sizesqty = TextEditingController();
  String _retailer = '';
  String _contact = '';
  var qtyController = '';
  final List<Map<String, dynamic>> _dataList = [];
  final qtyreset = TextEditingController();

  final bool _isImageVisible = false;
  // List of sizes returned by the API
  List<String> _sizes = [];
  final Map<String, double> qtyMap = {};

  // Map of size values and their corresponding text field controllers
  final sizeControllers = <String, TextEditingController>{};
  final apiUrl =
      '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size';
  final apiUrlrj =
      '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size';
  final bool _allstock = false;
  double allqty = 0;

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frappe API Demo',
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange[200],
            title: const Text('Order Details'),
            centerTitle: true,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .orange[200], // Set the background color to orange 200
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text('Are you sure you want to Book?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
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
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (_party.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Error'),
                                    content:
                                        const Text('Party cannot be empty!'),
                                    actions: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              20), // set the border radius
                                          color: Colors.orange[
                                              500], // set the background color
                                        ),
                                        child: TextButton(
                                          child: const Text(
                                            'OK',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                    title: const Text('Processing'),
                                    content: const Text('Plz wait'),
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
                                MobileDocument();
                                // createFlutterMobileDocument();
                                // Navigator.of(context).pop();
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           DocumentListScreen()),
                                // );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.send),
              ),
            ]),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<List<dynamic>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      if (_isImageVisible)
                        // print('Image should be visible');
                        if (_imageUrl.isNotEmpty)
                          Image.network(
                            _imageUrl,
                            height: 500,
                            width: 550,
                          ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     SizedBox(width: 170),
                      //     IconButton(
                      //       icon: _isImageVisible
                      //           ? Icon(Icons.arrow_drop_up_outlined)
                      //           : Icon(Icons.image),
                      //       onPressed: () {
                      //         setState(() {
                      //           _isImageVisible = !_isImageVisible;
                      //           print(_isImageVisible);
                      //         });
                      //       },
                      //     ),
                      //     SizedBox(width: 40),
                      //     Checkbox(
                      //       value: _allstock,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           _allstock = value;
                      //         });
                      //         print(_allstock);
                      //       },
                      //     ),
                      //     Text('All Stock'),
                      //   ],
                      // ),
                      const SizedBox(height: 40),

                      Container(
                        width: 500,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: const InputDecoration(
                              labelText: 'Party',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              isDense: true,
                            ),
                            controller: TextEditingController(text: _party),
                          ),
                          suggestionsCallback: (pattern) async {
                            List<String> partyNames = (snapshot.data ?? [])
                                .map((item) => item["buyer"]
                                    ?.toString()) // Use the safe navigation operator to prevent null exceptions
                                .where((party) => party != null)
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
                            setState(() {
                              _party = suggestion;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 500,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Order no',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              _retailer = newValue;
                            });
                            print(_retailer);
                          },
                          // keyboardType: TextInputType.number,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 500,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Contact',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              _contact = newValue;
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      Container(
                        width: 500,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: const InputDecoration(
                              labelText: 'Item',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              isDense: true,
                            ),
                            controller:
                                TextEditingController(text: _partnerName),
                          ),
                          suggestionsCallback: (pattern) async {
                            // Filter the partner names based on the input pattern
                            List<String> partnerNames = (snapshot.data ?? [])
                                .map((item) => item["partner_name"]
                                    ?.toString()) // Use the safe navigation operator to prevent null exceptions
                                .where((partnerName) => partnerName != null)
                                .toList();
                            partnerNames = partnerNames
                                .where((name) => name
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                                .toList();
                            print(partnerNames);
                            // Add a print statement here
                            return partnerNames; // Add a print statement here
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          // onSuggestionSelected: (suggestion) {
                          //   setState(() {
                          //     _partnerName = suggestion;
                          //
                          //     fetchDatasize();
                          //   });
                          //   final partnerData =
                          //       (snapshot.data ?? []).firstWhere(
                          //     (item) =>
                          //         item["partner_name"].toString() == suggestion,
                          //     orElse: () => null,
                          //   );
                          //   if (partnerData != null) {
                          //     final image = partnerData["images"].toString();
                          //     _imageUrl = image;
                          //   }
                          // },
                          onSuggestionSelected: (suggestion) async {
                            setState(() {
                              _partnerName = suggestion;
                            });

                            // Clear the old data and sizes
                            setState(() {
                              // _dataList = [];
                              _sizes = [];
                              qtyMap.clear();
                              sizeControllers.clear();
                              qtyreset.text = '';
                            });
                            allqty = 0;

                            // Fetch new data and sizes
                            await fetchDatasize();

                            final partnerData =
                                (snapshot.data ?? []).firstWhere(
                              (item) =>
                                  item["partner_name"].toString() == suggestion,
                              orElse: () => null,
                            );

                            if (partnerData != null) {
                              final image = partnerData["images"].toString();
                              _imageUrl = image;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // Container(
                      //   width: 500,
                      //   height: 40,
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //       labelText: 'QTY',
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(
                      //           Radius.circular(15),
                      //         ),
                      //       ),
                      //     ),
                      //     controller: qtyreset,
                      //     onChanged: (newValue) {
                      //       setState(() {
                      //         allqty = double.tryParse(newValue) ?? 0;
                      //       });
                      //       print(allqty);
                      //     },
                      //     keyboardType: TextInputType.number,
                      //   ),
                      // ),
                      Container(
                        width: 500,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'QTY',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                ),
                                controller: qtyreset,
                                onChanged: (newValue) {
                                  setState(() {
                                    allqty = double.tryParse(newValue) ?? 0;
                                  });
                                  print(allqty);
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  allqty = (allqty ?? 0) - 1;
                                  qtyreset.text = allqty.toString();
                                });
                              },
                              icon: const Icon(Icons.indeterminate_check_box,
                                  size: 30),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  allqty = (allqty ?? 0) + 1;
                                  qtyreset.text = allqty.toString();
                                });
                              },
                              icon: const Icon(Icons.add_box_sharp, size: 30),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      ..._sizes.map((size) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 35),
                                SizedBox(
                                  width: 111,
                                  height: 35,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      // labelText: 'Size',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      // Align the text at the center
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      // Optionally, you can also set the text alignment directly in the labelStyle
                                      /*labelStyle: TextStyle(
                                        textAlign: TextAlign.center,
                                      ),*/
                                    ),
                                    enabled: false,
                                    controller:
                                        TextEditingController(text: size),
                                    onChanged: (newValue) {
                                      setState(() {
                                        size = newValue;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 30),
                                /*SizedBox(width: 10),
                                Container(
                                  width: 75,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Bls:',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          sizeControllers[size]?.text ?? '',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),*/
                                // SizedBox(width: 10),

                                SizedBox(
                                  width: 170,
                                  height: 35,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            // Decrease the value by 1
                                            qtyMap[size] =
                                                (qtyMap[size] ?? 0) - 1;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 15,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                          controller: TextEditingController(
                                            text:
                                                qtyMap[size]?.toString() ?? '0',
                                          ),
                                          onChanged: (newValue) {
                                            setState(() {
                                              qtyMap[size] =
                                                  double.tryParse(newValue) ??
                                                      0;
                                            });
                                          },
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            // Increase the value by 1
                                            qtyMap[size] =
                                                (qtyMap[size] ?? 0) + 1;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Container(
                                //   width: 111,
                                //   height: 35,
                                //   child: Row(
                                //     children: [
                                //       // IconButton(
                                //       //   onPressed: () {
                                //       //     setState(() {
                                //       //       qtyMap[size] =
                                //       //           double.tryParse("10") - 1;
                                //       //     });
                                //       //   },
                                //       //   icon: Icon(Icons.remove),
                                //       // ),
                                //       Expanded(
                                //         child: TextField(
                                //           decoration: InputDecoration(
                                //             border: OutlineInputBorder(
                                //               borderRadius: BorderRadius.all(
                                //                 Radius.circular(15),
                                //               ),
                                //             ),
                                //           ),
                                //           controller: sizesqty,
                                //           onChanged: (newValue) {
                                //             setState(() {
                                //               qtyMap[size] =
                                //                   double.tryParse(newValue) ??
                                //                       0;
                                //             });
                                //           },
                                //           keyboardType: TextInputType.number,
                                //         ),
                                //       ),
                                //       // IconButton(
                                //       //   onPressed: () {
                                //       //     setState(() {
                                //       //       qtyMap[size] = (100) as double;
                                //       //     });
                                //       //   },
                                //       //   icon: Icon(Icons.add),
                                //       // ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                          ],
                        );
                      }).toList(),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add the entered data to a list
                            for (var size in _sizes) {
                              var qtyController = sizeControllers[size];
                              var stock = qtyController.text.isNotEmpty
                                  ? double.parse(qtyController.text)
                                  : 0;
                              // print(allqty);
                              var qty = 0;
                              print(allqty);
                              // if (allqty != null &&
                              //     allqty != 0 &&
                              //     allqty > 0 &&
                              //     allqty.toString().isNotEmpty) {
                              //   qty = allqty.toInt();
                              // } else {
                              //   qty = qtyMap[size]?.toInt() ?? 0;
                              // }
                              if (qtyMap[size]?.toInt() != null) {
                                qty = qtyMap[size]?.toInt();
                              } else {
                                qty = allqty.toInt();
                              }
                              print(qty);
                              if (qty != null && qty != 0 && qty > 0) {
                                // _dataList.add({
                                //   "item": _partnerName,
                                //   "qty": qty,
                                //   "size": size,
                                //   "stock": stock,
                                // });
                                _dataList.add({
                                  "product": _partnerName,
                                  "qty": qty,
                                  "size": size,
                                  "rate": '1',
                                });
                              }
                            }
                            print(_dataList);
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
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, size: 15),
                              SizedBox(width: 2),
                              Text(
                                'Add',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ), //

                      // ..._sizes.map((size) {
                      //   var qtyController = sizeControllers[size];
                      //
                      //   return Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Container(
                      //             width: 111,
                      //             height: 30,
                      //             child: TextField(
                      //               decoration: InputDecoration(
                      //                 border: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.all(
                      //                     Radius.circular(15),
                      //                   ),
                      //                 ),
                      //               ),
                      //               controller:
                      //                   TextEditingController(text: size),
                      //               onChanged: (newValue) {
                      //                 setState(() {
                      //                   size = newValue;
                      //                 });
                      //               },
                      //             ),
                      //           ),
                      //           SizedBox(width: 10),
                      //           Container(
                      //             width: 111,
                      //             child: SingleChildScrollView(
                      //               scrollDirection: Axis.horizontal,
                      //               child: Row(
                      //                 children: [
                      //                   Text(
                      //                     'Stock: ',
                      //                     style: TextStyle(fontSize: 20),
                      //                   ),
                      //                   Text(
                      //                     sizeControllers[size]?.text ?? '',
                      //                     style: TextStyle(fontSize: 20),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(width: 10),
                      //           Container(
                      //             width: 111,
                      //             height: 30,
                      //             child: TextField(
                      //               decoration: InputDecoration(
                      //                 border: OutlineInputBorder(
                      //                   borderRadius: BorderRadius.all(
                      //                     Radius.circular(15),
                      //                   ),
                      //                 ),
                      //               ),
                      //               // controller:
                      //               // TextEditingController(text: _size1),
                      //               controller: qtyController,
                      //               // keyboardType: TextInputType.number,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   );
                      // }).toList(),
                      SizedBox(
                        height: 310, // Set the height to a fixed value
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _dataList.length,
                          itemBuilder: (context, index) {
                            final data = _dataList[index];
                            return ListTile(
                              title: Text(data["product"]),
                              subtitle: Text(
                                'Size: ${data["size"]}  Qty: ${data["qty"]}',
                              ),
                              trailing: GestureDetector(
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  setState(() {
                                    _dataList.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      //Text( 'Total Amount: ${_amount1 + _amount2 + _amount3}', style: TextStyle(fontSize: 20), ),
                      Text(
                        'Total QTY: ${_dataList.isEmpty ? 0 : _dataList.fold(0, (total, item) => total + item['qty'])}',
                        style: const TextStyle(fontSize: 20),
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
      ),
    );
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

  Future<void> fetchDatasize() async {
    if (_partnerName == null || _partnerName.isEmpty) {
      return;
    }

    // Build the API endpoint URL with the partner name as a query parameter
    // final url = '$apiUrl?name=$_partnerName';
    String url;
    if (_allstock) {
      url = '$apiUrl?name=$_partnerName';
    } else {
      url = '$apiUrlrj?name=$_partnerName';
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
        if (!sizeControllers.containsKey(size)) {
          sizeControllers[size] = TextEditingController();
        }
        sizeControllers[size]?.text = stock;
        print(size);
        print(stock);
      });

      // Update the list of sizes and rebuild the UI with the updated text field values
      setState(() {
        _sizes = sizeControllers.keys.toList();
      });
    } else {
      throw Exception('Failed to load data from $url');
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
      if (_partnerName != null && _partnerName.isNotEmpty)
        '$http_key://$core_url/api/method/regent.regent.flutter.get_flutter_size?name=$_partnerName',
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

  Future<void> createFlutterMobileDocument() async {
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
      'party': _party,
      'person': loginuser,
      'allstock': _allstock,
      'details': _dataList
    };

    final body = jsonEncode(data);

    final response = await ioClient.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);

      print(_allstock);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

//final response = await http.post(
// Uri.parse(
//'https://3pin.glenmargon.com/api/method/regent.regent.client.get_flutter_mobile'),
// 'https://erp.yaaneefashions.com/api/method/regent.regent.client.get_flutter_data'),
// headers: {
// 'Authorization': 'token $apiKey:$apiSecret',
//  'Content-Type': 'application/json'
// },
// body: json.encode({"args": {}}),
// );
//if (response.statusCode == 200) {
//return json.decode(response.body)["message"];
//} else {
// throw Exception('Failed to load data');
//}
}
