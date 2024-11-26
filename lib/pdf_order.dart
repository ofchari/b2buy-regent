import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class PdfViewerPage extends StatefulWidget {
  final String name;

  const PdfViewerPage({Key key, this.name}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  double height;
  double width;
  String pdfFilePath;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAndLoadPdf();
  }

  /// PDF viewer logics //
  Future<void> _fetchAndLoadPdf() async {
    try {
      String apiUrl =
          "http://sribalajitexknit.regenterp.com/api/method/frappe.utils.print_format.download_pdf?doctype=Order%20Form&name=${widget.name}&format=Order%20Form&no_letterhead=1&letterhead=No%20Letterhead&settings=%7B%7D&_lang=en";

      var headers = {"Authorization": "token 7c7d1bcf720e34d:47a11ff1f30e12c"};

      // Fetch the PDF from the API
      var response = await http.get(Uri.parse(apiUrl), headers: headers);

      print("Response status: ${response.statusCode}");
      print("Response headers: ${response.headers}");

      if (response.statusCode == 200 &&
          response.headers['content-type'] == 'application/pdf') {
        var dir = await getTemporaryDirectory();
        File file = File("${dir.path}/${widget.name}.pdf");

        // Save the fetched PDF
        await file.writeAsBytes(response.bodyBytes);
        if (await file.exists()) {
          print("PDF file exists at: ${file.path}");
          setState(() {
            pdfFilePath = file.path;
            isLoading = false;
          });
        } else {
          throw Exception("Failed to save the PDF file.");
        }
      } else {
        throw Exception("Failed to load PDF, status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching PDF: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  /// Download  logics for PDF//
  Future<void> _downloadPdf() async {
    try {
      /// Directory for app-specific internal storage
      var appDir =
          await getApplicationDocumentsDirectory(); // Internal storage directory
      String filePath = "${appDir.path}/${widget.name}.pdf";

      // Copy PDF to the internal app folder
      File(pdfFilePath).copy(filePath).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("PDF saved to: $filePath"),
          duration: const Duration(seconds: 3),
        ));
      });
    } catch (e) {
      print("Error downloading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to download PDF."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define Sizes //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("PDF Order Viewer"),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          actions: [
            if (!isLoading && pdfFilePath != null)
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: _downloadPdf,
                tooltip: "Download PDF",
              ),
            // const Icon(CupertinoIcons.ant_circle),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? const Center(
                        child: Text(
                          "Failed to load PDF.",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : pdfFilePath != null
                        ? Expanded(
                            child: PDFView(
                              filePath: pdfFilePath,
                            ),
                          )
                        : const Center(
                            child: Text(
                              "Error: PDF not found.",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
          ],
        ));
  }
}
