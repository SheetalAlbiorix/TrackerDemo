import 'package:flutter/material.dart';
import 'package:tap_d/common/Constants.dart';
import 'package:tap_d/common/xInputPin.dart';

class xPin extends StatefulWidget {
  @override
  _xPinState createState() => _xPinState();
}

class _xPinState extends State<xPin> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          xInputPin(),
          SizedBox(
            width: 30,
          ),
          xInputPin(),
          SizedBox(
            width: 30,
          ),
          xInputPin(),
          SizedBox(
            width: 30,
          ),
          xInputPin(),
        ],
      ),
    );
  }
}
