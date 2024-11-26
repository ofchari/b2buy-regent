import 'package:flutter/material.dart';
import 'package:b2buy/main.dart';
import 'package:b2buy/doctype.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  //const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x80FFFFFF), Color(0xFF8F96B4)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 150,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Booking',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.add, size: 50),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const doctype()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 150,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Doctype',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(Icons.document_scanner_sharp, size: 50),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//GestureDetector(
//onTap: () {//
//Navigator.push(
//context,
//MaterialPageRoute(builder: (context) => LoginPage()),
//);
//},
//child: Container(
//decoration: BoxDecoration(
//color: Colors.white,
//borderRadius: BorderRadius.circular(20),
//),
//width: 150,
//height: 200,
//child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
//children: [
//Text(
//'Update',
//style: TextStyle(fontSize: 20),
//),
//Icon(Icons.update, size: 50),
//SizedBox(height: 10),
//],
//),
//),
//),
