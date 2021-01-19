import 'package:flutter/material.dart';
import 'package:tap_d/common/Constants.dart';

// ignore: camel_case_types
class xInputField extends StatefulWidget {
  xInputField(
      {this.title,
      this.placeHolder,
      this.icon,
      this.textInputType,
      this.isPassword,
      this.id,
      this.validator,
      this.onSaved,
      this.maxLength});

  final String title;
  final String placeHolder;
  final IconData icon;
  final TextInputType textInputType;
  bool isPassword = false;
  bool isPassToogle = false;
  GlobalKey id;
  FormFieldValidator<String> validator;
  FormFieldSetter<String> onSaved;
  int maxLength = 100;

  @override
  _xInputFieldState createState() => _xInputFieldState();
}

class _xInputFieldState extends State<xInputField> {
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Container(
      key: widget.id,
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: new LinearGradient(
              colors: [
                Constants.red,
                Constants.redEnd,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
          boxShadow: [
            BoxShadow(
              color: Constants.placeHolder,
              blurRadius: 1.0,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.5),
        child: TextFormField(
          obscureText: widget.isPassword ? !widget.isPassToogle : false,
          keyboardType: widget.textInputType,
          maxLength: widget.maxLength,
          cursorColor: Constants.red,
          decoration: InputDecoration(
            counterText: "",
            errorStyle: TextStyle(color: Colors.white),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 0.0),
            ),
            hintText: widget.placeHolder,
            hintStyle: TextStyle(color: Color(0x25000000)),
            prefixIcon: Icon(
              widget.icon,
              color: Constants.red,
            ),
            focusColor: Constants.red,
            filled: true,
            fillColor: Constants.white,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 0.0),
            ),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      widget.isPassToogle
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Constants.red,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        widget.isPassToogle = !widget.isPassToogle;
                      });
                    },
                  )
                : null,
          ),
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}
