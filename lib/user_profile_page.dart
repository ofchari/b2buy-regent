import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:b2buy/main.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'universalkey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  final String sessionId;
  final String username;

  const UserProfilePage({Key key, this.sessionId, this.username}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic> _userProfile;
  bool _isLoading = true;
  String user_type = '';
  String email = '';
  String name = '';
  bool isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    /* HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);

    final response = await ioClient.get(
        Uri.parse('https://3pin.glenmargon.com/api/resource/User/adminstrator'),
        headers: {
          'Authorization': 'token $apiKey:$apiSecret',
        });

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final userProfile = responseJson['data'];
      print(response.body);
      // setState(() {
      //   _userProfile = userProfile;
      //   _isLoading = false;
      // });
    } else {
      // Retrieving user profile failed, handle error
      setState(() {
        _isLoading = false;
      });
    }*/

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
        _isLoading = false;
        setState(() {
          user_type = json.decode(response.body)["message"][0]["user_type"];
          email = json.decode(response.body)["message"][0]["user_name"];
          name = json.decode(response.body)["message"][0]["user_id"];
          print(user_type);

          // universal_customer = json.decode(response.body)["message"][0]
          // ["universal_customer"];
        });
      } else {
        // Handle error
        print('Failed to load invoice data');
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*ClipOval(
                    child: CircleAvatar(
                      radius: 100.0,
                      child: Icon(
                        Icons.person,
                        size: 100.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),*/
                  Text(
                    // _userProfile['full_name'] ?? '',
                    email,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    user_type,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDialogShown = false;
                        });
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.clear();
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Container(
                        width: 100,
                        alignment: AlignmentDirectional.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(Icons.logout),
                            Text('   Log Out'),
                          ],
                        ),
                      ))
                  /* SizedBox(height: 16.0),
                  Text(
                    'hi',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),*/
                ],
              ),
            ),
    );
  }
}
