
import 'package:flutter/material.dart';
import 'package:b2buy/config.dart';
import 'package:b2buy/home_page.dart';

class LayerThree extends StatefulWidget {
  const LayerThree({Key key}) : super(key: key);

  @override
  _LayerThreeState createState() => _LayerThreeState();
}

class _LayerThreeState extends State<LayerThree> {
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  void _handleLogin() {
    if (_email == 'a' && _password == 'a') {
      Navigator.push(
        context,
        //MaterialPageRoute(builder: (context) => MainPage()),
        MaterialPageRoute(builder: (context) => const DocumentListScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;

    return SizedBox(
      height: 584,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: 338,
              height: 330,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
              ),
            ),
            Positioned(
              top: -80,
              left: 13,
              child: Container(
                width: 350,
                height: 200,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Image.asset(
                  'images/pin.jpg',
                  width: 40,
                  height: 49,
                ),
              ),
            ),
            Positioned(
                left: 20,
                top: 80,
                child: SizedBox(
                  width: 280,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter User ID or Email',
                      hintStyle: TextStyle(color: hintText),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _email = text;
                      });
                    },
                  ),
                )),
            Positioned(
                left: 20,
                top: 150,
                child: SizedBox(
                  width: 280,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(color: hintText),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _password = text;
                      });
                    },
                  ),
                )),
            const Positioned(
                right: 30,
                top: 210,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: forgotPasswordText,
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w600),
                )),
            Positioned(
              top: 250,
              right: 95,
              child: GestureDetector(
                onTap: _handleLogin,
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
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
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 85,
              right: 0,
              child: Text(
                _errorMessage,
                style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Poppins-Regular',
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
