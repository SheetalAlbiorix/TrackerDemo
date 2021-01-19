import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:tap_d/common/Constants.dart';
import 'package:tap_d/common/xInputField.dart';
import 'package:tap_d/pages/homePage.dart';

String fullName,
    userName,
    number,
    userEmail,
    password,
    confirmPassword,
    countryCode;
var focusNodeNumber = FocusNode();

final _formKey = GlobalKey<FormState>();

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  bool checkValue = false;
  String defaultCountryCode;
  List<Media> _listImagePaths = List();

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  void checkValue() async {
    widget.defaultCountryCode = await FlutterSimCountryCode.simCountryCode;
    print("Country Code : " + widget.defaultCountryCode);

    setState(() {});
  }

  @override
  initState() {
    // TODO: implement initState
    checkValue();
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

    Future selectImages() async {
      List<Media> _listImagePaths1 = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 1,
          showGif: true,
          showCamera: true,
          compressSize: 50,
          uiConfig: UIConfig(uiThemeColor: Constants.black),
          cropConfig: CropConfig(enableCrop: true, width: 1, height: 1));

      setState(() {
        widget._listImagePaths = _listImagePaths1;
      });
    }

    void _onCountryChange(CountryCode cCode) {
      //TODO : manipulate the selected country code here
      countryCode = cCode.toString();
      print("New Country selected: " + cCode.toString());
    }

    Widget showImage() {
      return widget._listImagePaths.length > 0
          ? ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.file(
                File(
                  widget._listImagePaths[0].path,
                ),
                width: 120,
                height: 120,
                fit: BoxFit.fitHeight,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(60)),
              width: 120,
              height: 120,
              child: Icon(
                Icons.add_photo_alternate_rounded,
                color: Colors.grey[800],
                size: 40,
              ),
            );
    }

    return Scaffold(
      backgroundColor: Constants.white,
      appBar: AppBar(
        backgroundColor: Constants.white,
        title:
            const Text('Sign Up', style: TextStyle(color: Color(0xFFE81919))),
        iconTheme: IconThemeData(color: Constants.red),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: GestureDetector(
                        onTap: () {
                          selectImages();
                        },
                        child: showImage())),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      xInputField(
                        placeHolder: 'Full Name',
                        icon: Icons.assignment_ind,
                        textInputType: TextInputType.text,
                        isPassword: false,
                        validator: (name) {
                          if (name.isEmpty)
                            return 'Full name can not be blank';
                          else
                            return null;
                        },
                        onSaved: (name) => fullName = name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      xInputField(
                        placeHolder: 'Username',
                        icon: Icons.person,
                        textInputType: TextInputType.text,
                        isPassword: false,
                        validator: (name) {
                          if (name.isEmpty)
                            return 'username can not be blank';
                          else if (name.length < 6)
                            return 'username must contain at least 6 characters';
                          else
                            return null;
                        },
                        onSaved: (name) => userName = name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
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
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1.5),
                            decoration: new BoxDecoration(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(5)),
                                color: Constants.white),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.phone,
                                  color: Constants.red,
                                  size: 23,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 40,
                                  child: CountryCodePicker(
                                    onChanged: _onCountryChange,
                                    onInit: _onCountryChange,
                                    showCountryOnly: true,
                                    showOnlyCountryWhenClosed: false,
                                    showFlagMain: false,
                                    alignLeft: false,
                                    initialSelection: widget.defaultCountryCode,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    focusNode: focusNodeNumber,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      errorStyle: TextStyle(color: Colors.red),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      hintText: 'Mobile Number',
                                      hintStyle:
                                          TextStyle(color: Color(0x25000000)),
                                      focusColor: Constants.red,
                                      filled: true,
                                      fillColor: Constants.white,
                                      border: InputBorder.none,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 0.0),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    /*validator: (name) {
                                      if (name.isEmpty)
                                        return 'mobile number can not be blank';
                                      else if (name.length < 10)
                                        return 'invalid mobile number';
                                      else
                                        return null;
                                    },*/
                                    onSaved: (name) => number = name,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      xInputField(
                        placeHolder: 'Email',
                        icon: Icons.email_outlined,
                        textInputType: TextInputType.emailAddress,
                        isPassword: false,
                        validator: (name) {
                          if (name.isEmpty)
                            return 'email can not be blank';
                          else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(name))
                            return 'invalid email';
                          else
                            return null;
                        },
                        onSaved: (name) => userEmail = name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      xInputField(
                        placeHolder: 'Password',
                        icon: Icons.lock,
                        textInputType: TextInputType.visiblePassword,
                        isPassword: true,
                        validator: (name) {
                          if (name.isEmpty)
                            return 'password can not be blank';
                          else if (name.length < 8) {
                            return 'password must contain min 8 characters';
                          } else
                            return null;
                        },
                        onSaved: (name) => password = name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      xInputField(
                        placeHolder: 'Confirm Password',
                        icon: Icons.lock,
                        textInputType: TextInputType.visiblePassword,
                        isPassword: true,
                        validator: (name) {
                          if (name.isEmpty)
                            return 'confirm password can not be blank';
                          /*else if (name != password) {
                            return 'password does not match';
                          }*/
                          else
                            return null;
                        },
                        onSaved: (name) => confirmPassword = name,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Constants.red),
                        child: Checkbox(
                          checkColor: Constants.white,
                          activeColor: Constants.red,
                          value: widget.checkValue,
                          onChanged: (bool value) {
                            setState(() {
                              widget.checkValue = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'I accept Terms & Condition and Privacy Policy',
                        style: TextStyle(
                            color: Color(0x35000000),
                            fontSize: 11,
                            fontFamily: 'pSemiBold'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    checkUser(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Constants.white,
                          fontSize: 16,
                          fontFamily: 'pMedium'),
                    ),
                  ),
                  color: Constants.red,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      return;
    }

    if (number.length != 10) {
      Constants.errorToast('please enter correct number', context);
      focusNodeNumber.requestFocus();
      return;
    }
    if (password != confirmPassword) {
      Constants.errorToast('confirm password does not match', context);
      return;
    }

    if (!await Constants.isOnline()) {
      Constants.errorToast(Constants.no_internet, context);
      return;
    }
    EasyLoading.show(status: 'loading...');
    if (widget._listImagePaths.length > 0) {
      uploadFile();
    } else {
      createUser("");
    }
  }

  Future uploadFile() async {
    File file = File(widget._listImagePaths.first.path);

    String name = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    try {
      await firebaseStorage.FirebaseStorage.instance
          .ref('/images/users/' + name)
          .putFile(file);
      String uri = await firebaseStorage.FirebaseStorage.instance
          .ref('/images/users/' + name)
          .getDownloadURL();
      print(uri);

      createUser(uri);
    } on firebaseStorage.FirebaseException catch (e) {
      EasyLoading.dismiss();
      print(e.toString());
    }
  }

  void createUser(String imgUri) {
    try {
      user
          .add({
            'email': userEmail,
            'image': imgUri,
            'name': fullName,
            'password': Constants.encryptString(password),
            'phone': countryCode + number,
            'username': userName,
            'createdAt': DateTime.now(),
            'updatedAt': DateTime.now(),
          })
          .then((value) => saveUser(imgUri, value.id))
          .catchError((error) => EasyLoading.dismiss());
    } catch (e) {
      print(e);
    }
  }

  void saveUser(String imgUri, String id) {
    Constants.saveSF(Constants.isLogin, "true");
    Constants.saveSF(Constants.userName, userName);
    Constants.saveSF(Constants.userImage, imgUri);
    Constants.saveSF(Constants.userFullName, fullName);
    Constants.saveSF(Constants.userEmail, userEmail);
    Constants.saveSF(Constants.userPhone, countryCode + number);
    Constants.saveSF(Constants.userId, id);

    EasyLoading.dismiss();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => home(),
      ),
      (route) => false,
    );
  }
}
