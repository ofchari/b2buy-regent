import 'package:b2buy/push_notify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _token;

  @override
  void initState() {
    super.initState();
    FirebaseNotificationService.initialize();
    _getToken();
  }

  Future<void> _getToken() async {
    final token = await FirebaseNotificationService.getToken();
    setState(() {
      _token = token;
    });
    print("FCM Token: $_token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Push Notifications")),
      body: Center(
        child: Text("FCM Token:\n${_token ?? 'Loading...'}"),
      ),
    );
  }
}

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: "AIzaSyALcplQT_FmfXDtTCCk_wBFTwcVbG2hMvY",
    appId: "1:227354894875:android:3cdae40da88ff1cb594ebe",
    messagingSenderId: "227354894875",
    projectId: "sribalajipush",
  );
}
