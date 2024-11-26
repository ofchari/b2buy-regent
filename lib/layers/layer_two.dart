import 'package:flutter/material.dart';

class LayerTwo extends StatelessWidget {
  const LayerTwo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(60.0),
      ),
    );
  }
}
