import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tap_d/common/Constants.dart';
import 'package:tap_d/common/xInputField.dart';
import 'package:tap_d/common/xPin.dart';

// ignore: camel_case_types
class forgotPasswordPage extends StatefulWidget {
  @override
  _forgotPasswordPageState createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<forgotPasswordPage> {
  String btnText = 'GET OTP';
  bool isMobile = true;
  bool isOtp = false;
  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
    ));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Constants.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image(
                  image: AssetImage('res/logo.png'),
                  height: size.height * .28,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Forgot Password',
              style: TextStyle(
                  color: Constants.red, fontSize: 20, fontFamily: 'pSemiBold'),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Visibility(
                  visible: isMobile,
                  child: xInputField(
                    placeHolder: 'Email or Mobile',
                    icon: Icons.person,
                    textInputType: TextInputType.text,
                    isPassword: false,
                  ),
                ),
                Visibility(
                  visible: isOtp,
                  child: xPin(),
                ),
                Visibility(
                    visible: isPassword,
                    child: Column(
                      children: [
                        xInputField(
                          placeHolder: 'Password',
                          icon: Icons.lock,
                          textInputType: TextInputType.visiblePassword,
                          isPassword: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        xInputField(
                          placeHolder: 'Confirm Password',
                          icon: Icons.lock,
                          textInputType: TextInputType.visiblePassword,
                          isPassword: true,
                        ),
                      ],
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {
                onButtonClick();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  btnText,
                  style: TextStyle(
                      color: Constants.white,
                      fontSize: 16,
                      fontFamily: 'pMedium'),
                ),
              ),
              color: Constants.red,
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Constants.red),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: RichText(
                        text: TextSpan(
                            text: 'Back to   ',
                            style: TextStyle(
                                color: Constants.white,
                                fontSize: 14,
                                fontFamily: 'pRegular'),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                    color: Constants.white,
                                    fontSize: 14,
                                    fontFamily: 'pSemiBold'),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void onButtonClick() {
    setState(() {
      if (btnText == 'GET OTP') {
        isMobile = false;
        isOtp = true;
        btnText = 'VERIFY OTP';
      } else if (btnText == 'VERIFY OTP') {
        isOtp = false;
        isPassword = true;
        btnText = 'UPDATE PASSWORD';
      } else {
        Navigator.of(context).pop();
      }
    });
  }
}
