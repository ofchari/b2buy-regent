import 'package:flutter/material.dart';

class LayerOne extends StatelessWidget {
  const LayerOne({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 654,
        height: 654,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(60.0),
          border: Border.all(
              color: Colors.transparent,
              width: 4.0), // optional: add a white border
        ),
      ),
    );
  }
}
