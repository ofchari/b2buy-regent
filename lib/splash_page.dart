import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'main.dart'; // Import the correct login page file

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Lock device orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Initialize the video controller
    _controller = VideoPlayerController.asset("assets/balaji.mp4")
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
          _visible = true;
        });
      }).catchError((error) {
        print("Error initializing video: $error");
      });

    // Delay for 5 seconds (or adjust as needed) and then navigate to the login page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _getVideoBackground() {
    return _controller.value.isInitialized
        ? AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500), // Faster fade-in
            child: Center(
              child: SizedBox(
                height: 650, // Set the height of the video here
                width: 370,
                child: AspectRatio(
                  aspectRatio:
                      _controller.value.aspectRatio, // Maintain aspect ratio
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          )
        : const Center(
            child:
                CircularProgressIndicator(), // Show loading indicator while the video is being loaded
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _getVideoBackground(),
        ],
      ),
    );
  }
}
