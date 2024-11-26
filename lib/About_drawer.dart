import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatefulWidget {
  const About({Key key, this.about_us}) : super(key: key);
  final about_us;

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        )),
        title: Text(
          "About us",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        ),
      ),
      body: SizedBox(
        height: height / 1,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                // height: height / 2,
                width: width / 1.3,
                decoration: BoxDecoration(
                    // color: Colors.lime.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: HtmlWidget(widget.about_us.replaceAll('img src="',
                        'img src="http://sribalajitexknit.regenterp.com/') ??
                    ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
