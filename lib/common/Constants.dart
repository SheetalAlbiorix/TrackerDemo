import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static Color red = Color(0xFFE81919);
  static Color green = Color(0xFF4CAF50);
  static Color redEnd = Color(0xFF740D0D);
  static Color placeHolder = Color(0x25000000);
  static Color white = Color(0xFFFFFFFF);
  static Color black = Color(0xFF000000);
  static Color lightGray = Colors.grey[100];
  static Color lightWhite = Color(0xFFF9F9F9);
  static Color textDark = Color(0xFF575757);
  static Color transparent = Color(0x00000000);

  static String encryptKey = "sd@fgG#%r45&6KGeiI93D1qAzXsW3F4_";

  static String isLogin = "isLogin";
  static String userName = "userName";
  static String userPhone = "userPhone";
  static String userImage = "userImage";
  static String userFullName = "userFullName";
  static String userEmail = "userEmail";
  static String userId = "userId";

  static String no_internet = "No Internet Connection!";

  static void successToast(String message, BuildContext context) {
    /*showToastWidget(IconToastWidget.success(msg: message, backgroundColor: green),
        context: context,
        position: StyledToastPosition.bottom,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear);*/
  }

  static void errorToast(String message, BuildContext context) {
    /*showToastWidget(IconToastWidget.fail(msg: message, backgroundColor: red,),
        context: context,
        position: StyledToastPosition.top,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear
    );*/
  }

  static String encryptString(String str) {
    final key = encrypt.Key.fromUtf8(encryptKey);
    final iv = encrypt.IV.fromLength(16);

    final encrypts = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypts.encrypt(str, iv: iv);

    return encrypted.base64.toString();
  }

  static void saveSF(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  static Future<String> getSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  static Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return false;
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((_) {
        GoogleSignIn().signOut();
        FacebookAuth.instance.logOut();
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
