import 'dart:convert';
import 'dart:io';

import 'package:b2buy/universalkey.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

class AgentRegister extends StatefulWidget {
  const AgentRegister({Key key}) : super(key: key);

  @override
  State<AgentRegister> createState() => _AgentRegisterState();
}

class _AgentRegisterState extends State<AgentRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  String nameag = '';
  String agency = '';
  String mobileNo = '';
  String _address = '';
  String email = '';
  String gstNo = '';
  String regioncovered = '';
  String refredbys = '';
  final url = Uri.parse(
      Uri.encodeFull('$http_key://$core_url/api/resource/Agent Registration'));

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

    // Set up the data to create a new document in the Flutter Mobile DocType
    final data = {
      'doctype': 'Agent Registration',
      'name__of_the_agent': nameag,
      'agency_name': agency,
      'address': _address,
      'gst': gstNo,
      'mobile_number': mobileNo,
      'email': email,
      'region_covered': regioncovered,
      'referred_by': refredbys,
    };
    print(data);

    final body = jsonEncode(data);

    final response = await ioClient.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back)),
                    Text(
                      "Agent Registration Form",
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                    ),
                    IconButton(
                        onPressed: () {
                          _showContactDetailsDialog(context);
                        },
                        icon: const Icon(Icons.contact_support))
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                _buildTextFormField(
                  hintText: "Name of the Agent",
                  onSaved: (value) => nameag = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: "Agency Name",
                  onSaved: (value) => agency = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: "Mobile No",
                  onSaved: (value) => mobileNo = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: "Address",
                  onSaved: (value) => _address = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: "Email Id",
                  onSaved: (value) => email = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Email id';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: "Gst ",
                  onSaved: (value) => gstNo = value,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter your GST number';
                  //   }
                  //   return null;
                  // },
                ),
                _buildTextFormField(
                  hintText: "Region Covered",
                  onSaved: (value) => regioncovered = value,
                  // validator: (value) {
                  //   if (value.isEmpty) {
                  //     return 'Please enter your Preferred Transport';
                  //   }
                  //   return null;
                  // },
                ),
                _buildTextFormField(
                  hintText: "Referred by",
                  onSaved: (value) => refredbys = value,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70.0),
                  child: Row(
                    children: [
                      Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value;
                            });
                          }),
                      Text(
                        "Terms and conditions",
                        style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: height / 18,
                  width: width / 2,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextButton(
                    onPressed: _submitForm,
                    child: Text(
                      "Submit",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    String hintText,
    Function(String) onSaved,
    String Function(String) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Colors.black), // Change this color as needed
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      MobileDocument(context);
      // Here you can do whatever you want with the form data
      // For example, you can send it to an API or process it further
      print('Name: $nameag');
      print('Address: $_address');
      print('Gst No: $gstNo');
      print('Contact No: $mobileNo');
      print('Agent Name: $agency');
      print('Email: $email');
      print('Region covered: $regioncovered');
      print('Refered by: $refredbys');
    }
  }
}
