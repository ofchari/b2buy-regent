import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    log("Initializing FirebaseNotificationService...");

    // Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    final bool initialized = await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Notification tapped with payload: ${response.payload}");
      },
    );
    if (initialized) {
      log("FlutterLocalNotificationsPlugin successfully initialized.");
    } else {
      log("Failed to initialize FlutterLocalNotificationsPlugin.");
    }

    // Create Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Default Channel',
      description: 'This is the default channel for notifications',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Request Notification Permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("Notification permissions granted.");
    } else {
      log("Notification permissions not granted.");
    }

    // Ensure Foreground Notification Presentation
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle Foreground Notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Foreground message received: ${message.data}");

      if (message.notification != null) {
        log("Notification Title: ${message.notification?.title}");
        log("Notification Body: ${message.notification?.body}");

        await _showNotification(
          message.notification.title ?? "No Title",
          message.notification.body ?? "No Body",
        );
      }
    });

    // Handle Background Notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Handle Notification Taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification clicked: ${message.notification?.title}");
    });
  }

  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    log("Background message received");
    log("Message Data: ${message.data}");
    log("Message Notification Title: ${message.notification?.title}");
    log("Message Notification Body: ${message.notification?.body}");

    if (message.notification != null) {
      await _showNotification(
        message.notification.title ?? "No Title",
        message.notification.body ?? "No Body",
      );
    }
  }

  static Future<void> _showNotification(String title, String body) async {
    log("Showing notification with title: $title, body: $body");

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This is the default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000), // Unique ID
      title,
      body,
      platformDetails,
    );
  }

  static Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken() ?? '';
    log("Firebase Messaging Token: $token");
    return token;
  }
}
