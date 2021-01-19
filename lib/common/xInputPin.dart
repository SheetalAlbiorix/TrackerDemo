import 'package:flutter/material.dart';
import 'package:tap_d/common/Constants.dart';

class xInputPin extends StatefulWidget {
  @override
  _xInputPinState createState() => _xInputPinState();
}

class _xInputPinState extends State<xInputPin> {
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Container(
      width: 50,
      height: 50,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        gradient: new LinearGradient(
            colors: [
              Constants.red,
              Constants.redEnd,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.5),
        child: TextField(
          maxLength: 1,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          cursorColor: Constants.red,
          decoration: InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(0),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                const Radius.circular(0),
              ),
              borderSide: const BorderSide(color: Colors.white, width: 0.0),
            ),
            hintText: '⬤',
            counterText: "",
            hintStyle: TextStyle(color: Color(0x25000000)),
            focusColor: Constants.red,
            filled: true,
            fillColor: Constants.white,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                const Radius.circular(0),
              ),
              borderSide: const BorderSide(color: Colors.white, width: 0.0),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          onChanged: (text) {
            print("First text field: $text");
            if (text.isNotEmpty) {
              node.nextFocus();
            } else {
              node.previousFocus();
            }
          },
        ),
      ),
    );
  }
}
