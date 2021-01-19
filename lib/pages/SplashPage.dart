import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_d/common/Constants.dart';
import 'package:tap_d/pages/homePage.dart';
import 'package:tap_d/pages/loginPage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void checkDetail() {
    Future.delayed(const Duration(milliseconds: 3000), () async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String isLogin = prefs.getString(Constants.isLogin);

      if (isLogin != null && isLogin == "true") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => home(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
    ));

    return Scaffold(
      backgroundColor: Constants.white,
      body: Center(
        child: Image(
          image: AssetImage('res/logo.png'),
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
