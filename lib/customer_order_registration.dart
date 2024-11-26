import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';

import 'main.dart';

class CustomerOrder extends StatefulWidget {
  const CustomerOrder({Key key}) : super(key: key);

  @override
  State<CustomerOrder> createState() => _CustomerOrderState();
}

class _CustomerOrderState extends State<CustomerOrder> {
  final TextEditingController type_products = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController sizee = TextEditingController();
  final TextEditingController colors = TextEditingController();
  final TextEditingController quality = TextEditingController();
  final TextEditingController fabric = TextEditingController();
  final TextEditingController gsmm = TextEditingController();
  final TextEditingController designs = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController lastdate = TextEditingController();
  final TextEditingController remark = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> mobileDocument(BuildContext context) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    const credentials =
        '7c7d1bcf720e34d:47a11ff1f30e12c'; // Use your credentials
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-Type': 'application/json',
    };

    // Prepare the data for creating a new document
    final data = {
      'doctype': 'Customized Order Registration',
      'type_of_product': type_products.text,
      'category': category.text,
      'size': sizee.text,
      'color': colors.text,
      'qty': quality.text,
      'fabric_type': fabric.text,
      'gsm': gsmm.text,
      'design': designs.text,
      'price_per_pcs': price.text,
      'delivery_date': lastdate.text,
      'remarks': remark.text,
    };

    final body = jsonEncode(data);
    print(data);

    try {
      final response = await ioClient.post(
        Uri.parse(
            'http://sribalajitexknit.regenterp.com/api/resource/Customized%20Order%20Registration'), // API endpoint URL
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          "Posted Successfully";
        });

        Future.delayed(const Duration(seconds: 3), () {});

        // Navigate to another screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );

        return true;
      } else if (response.statusCode == 417) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Message'),
            content: SingleChildScrollView(
              child: Text(json.decode(response.body)['_server_messages']),
            ),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );

        print(json.decode(response.body)['_server_messages']);
        return false;
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
        return false;
      }
    } catch (e) {
      setState(() {});

      Future.delayed(const Duration(seconds: 3), () {});

      print("Error creating document: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
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
                  "Customized  Registration Form",
                  style: GoogleFonts.dmSans(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ),
                IconButton(
                    onPressed: () {
                      // _showContactDetailsDialog(context);
                    },
                    icon: const Icon(Icons.contact_support))
              ],
            ),
            _buildTextField("Products", type_products),
            _buildTextField("Category", category),
            _buildTextField("Size", sizee),
            _buildTextField("Color", colors),
            _buildTextField("Quality", quality),
            _buildTextField("Fabric", fabric),
            _buildTextField("Gsm", gsmm),
            _buildTextField("Design", designs),
            _buildTextField("Price", price),
            _buildTextField("Delivery Date", lastdate),
            _buildTextField("Remarks", remark),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    mobileDocument(context);
                  }
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    ));
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText is required';
          }
          return null;
        },
      ),
    );
  }
}
