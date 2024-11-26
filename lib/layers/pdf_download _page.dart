import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

import 'package:share_plus/share_plus.dart';

class PDFDownloader extends StatefulWidget {
  const PDFDownloader({Key key}) : super(key: key);

  @override
  _PDFDownloaderState createState() => _PDFDownloaderState();
}

class _PDFDownloaderState extends State<PDFDownloader> {
  String url =
      'https://erp.wellknownssyndicate.com/api/method/frappe.utils.print_format.download_pdf';
  String doctype = 'Item';
  String name = 'INK ROLL';
  String format = 'Item%20Template';
  String authToken = 'c5a479b60dd48ad:d8413be73e709b6';
  String localPath = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'token $authToken';

      var dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/$name.pdf';

      // Construct the URL with query parameters
      String fullUrl = '$url?doctype=$doctype&name=$name&format=$format';

      Response response = await dio.get(
        fullUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        File file = File(filePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();

        setState(() {
          localPath = filePath;
          isLoading = false;
        });
      } else {
        print(
            'Failed to download PDF: ${response.statusCode} ${response.statusMessage}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void sharePDF() {
    if (localPath != null) {
      Share.shareFiles([localPath], text: 'Here is the PDF file: $name.pdf');
    } else {
      print('PDF file is not available to share');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Downloader'),
        actions: [
          if (localPath != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: sharePDF,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath != null
              ? Column(
                  children: [
                    Expanded(child: PDFView(filePath: localPath)),
                    ElevatedButton(
                      onPressed: sharePDF,
                      child: const Text('Share PDF'),
                    ),
                  ],
                )
              : const Center(child: Text('Error loading PDF')),
    );
  }
}
