import 'dart:convert';
import 'dart:io';
import 'package:b2buy/universalkey.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:b2buy/main.dart';
import 'package:b2buy/user_profile_page.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class outstandData {
  String buyer;
  double amount;
  String ttype;
  double totCredit;
  double totDebit;

  outstandData({
    this.buyer,
    this.amount,
    this.ttype,
    this.totCredit,
    this.totDebit,
  });

  factory outstandData.fromJson(Map<String, dynamic> jsonData) {
    return outstandData(
      buyer: jsonData['buyer'],
      amount: jsonData['amount'].toDouble(),
      ttype: jsonData['ttype'],
      totCredit: jsonData['tot_credit'].toDouble(),
      totDebit: jsonData['tot_debit'].toDouble(),
    );
  }
}

class ledgervalue extends StatefulWidget {
  const ledgervalue({Key key}) : super(key: key);

  @override
  State<ledgervalue> createState() => _ledgervalueState();
}

class _ledgervalueState extends State<ledgervalue> {
  Map<String, dynamic> invoiceData;
  double outstanding = 0;
  double credit = 0;
  double debit = 0;
  double balance = 0;
  String buyer_name = universal_customer;

  DateTime fromDate; // Nullable for null safety
  DateTime toDate; // Nullable for null safety

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    _getUserProfile();
    print(buyer_name);

    await Future.delayed(const Duration(seconds: 2));
    fetchbuyer();
    print(buyer_name);

    await Future.delayed(const Duration(seconds: 2));
    fetchData(); // Fetch data for the logged-in user
    print(buyer_name);
  }

  Future<void> _getUserProfile() async {
    final adopturl =
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
        });
      } else {
        print('Failed to load user profile data');
      }
    } catch (e) {
      throw Exception('Failed to load user profile data: $e');
    }
  }

  Future<void> fetchbuyer() async {
    final url =
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
        setState(() {
          outstanding = json.decode(response.body)["message"][0]["amount"];
          credit = json.decode(response.body)["message"][0]["tot_credit"];
          debit = json.decode(response.body)["message"][0]["tot_debit"];
          print(outstanding);
        });
      } else {
        print('Failed to load customer summary');
      }
    } catch (e) {
      throw Exception('Failed to load customer summary: $e');
    }
  }

  Future<void> fetchData() async {
    // Modify the API call to use the login user to filter the data
    final url =
        '$http_key://$core_url/api/method/regent.sales.client.customer_ledger?buyer=$buyer_name';
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
        setState(() {
          invoiceData = json
              .decode(response.body); // Update invoiceData with filtered data
          invoiceData["message"] = invoiceData["message"]
              .where((item) => item["buyer"] == buyer_name)
              .toList(); // Filter data by login user
        });
      } else {
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load ledger data: $e');
    }
  }

  // Method to show the date picker and set the "from" date
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  // Method to show the date picker and set the "to" date
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != toDate)
      setState(() {
        toDate = picked;
      });
  }

  // Filtering function based on selected date range
  bool _filterBySelectedDate(String formattedDate) {
    if (fromDate == null && toDate == null) {
      return true; // No date range selected, show all data
    }
    DateTime itemDate = DateFormat('dd-MM-yyyy').parse(formattedDate);
    if (fromDate != null && toDate != null) {
      return itemDate.isAfter(fromDate.subtract(Duration(days: 1))) &&
          itemDate.isBefore(toDate.add(Duration(days: 1)));
    } else if (fromDate != null) {
      return itemDate.isAfter(fromDate.subtract(Duration(days: 1)));
    } else if (toDate != null) {
      return itemDate.isBefore(toDate.add(Duration(days: 1)));
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height / 6.8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserProfilePage(),
                            ),
                          );
                        },
                        child: Text(
                          'Hello, $loginuser 👋',
                          style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _selectFromDate(context);
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    fromDate != null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(fromDate)
                                        : 'From Date',
                                    style: GoogleFonts.dmSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                await _selectToDate(context);
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    toDate != null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(toDate)
                                        : 'To Date',
                                    style: GoogleFonts.dmSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Current Outstanding - ',
                        style: GoogleFonts.dmSans(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 17.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '₹$outstanding',
                        style: GoogleFonts.dmSans(
                          textStyle: const TextStyle(
                            color: Colors.black45,
                            fontSize: 17.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      GestureDetector(
                        onTap: () async {
                          await _generatePdfAndDownload();
                        },
                        child: const Icon(Icons.download),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  'Reference No',
                  style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  'Debit',
                  style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  'Credit',
                  style: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: invoiceData == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: invoiceData["message"].length,
                      itemBuilder: (context, index) {
                        var item = invoiceData["message"][index];
                        List<String> dateParts = item["date"].split('-');
                        String formattedDate =
                            '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';

                        if (_filterBySelectedDate(formattedDate)) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        formattedDate,
                                        style: GoogleFonts.dmSans(
                                          textStyle: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item["name"].replaceAll('ACC-', ''),
                                        style: GoogleFonts.dmSans(
                                          textStyle: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item["debit"] == 0
                                            ? ""
                                            : "₹${item["debit"]}",
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: item["debit"] == 0
                                                ? Colors.transparent
                                                : Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item["credit"] == 0
                                            ? ""
                                            : "₹${item["credit"]}",
                                        style: GoogleFonts.dmSans(
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            color: item["credit"] == 0
                                                ? Colors.transparent
                                                : Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(); // If date doesn't match, return empty container
                        }
                      },
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: height / 13.4,
                  width: width / 3.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Credit',
                          style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                              color: Colors.green,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            ' $credit',
                            style: GoogleFonts.dmSans(
                              textStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height / 14,
                  width: width / 3.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Debit',
                          style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          ' $debit',
                          style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height / 14,
                  width: width / 3.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Text(
                          'Balance',
                          style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          ' $outstanding',
                          style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _generatePdfAndDownload() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice Details', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Buyer: $buyer_name'),
              pw.Text('Outstanding: ₹$outstanding'),
              pw.Text('Total Credit: ₹$credit'),
              pw.Text('Total Debit: ₹$debit'),
              pw.SizedBox(height: 20),
              pw.Text('Ledger Details:', style: pw.TextStyle(fontSize: 18)),
              pw.ListView.builder(
                itemCount: invoiceData["message"].length,
                itemBuilder: (context, index) {
                  var item = invoiceData["message"][index];
                  List<String> dateParts = item["date"].split('-');
                  String formattedDate =
                      '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(formattedDate),
                      pw.Text(item["name"].replaceAll('ACC-', '')),
                      pw.Text(item["debit"] == 0 ? '' : '₹${item["debit"]}'),
                      pw.Text(item["credit"] == 0 ? '' : '₹${item["credit"]}'),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF to a file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    // Share the PDF using the Printing package
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
  }
}
