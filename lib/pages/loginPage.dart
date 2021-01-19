import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tap_d/common/Constants.dart';
import 'package:tap_d/common/xInputField.dart';
import 'package:tap_d/model/UserVo.dart';
import 'package:tap_d/pages/forgotPasswordPage.dart';
import 'package:tap_d/pages/homePage.dart';
import 'package:tap_d/pages/signUpPage.dart';

String username, password;
final _formKey = GlobalKey<FormState>();
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatelessWidget {
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

    final GoogleSignIn googleSignIn = GoogleSignIn();

    Future<void> signInWithGoogle() async {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        print('signInWithGoogle succeeded: $user');

        EasyLoading.show(status: 'loading...');

        FirebaseFirestore.instance
            .collection("users")
            .where("username", isEqualTo: user.uid)
            .get()
            .then((QuerySnapshot querySnapshot) => {
                  if (querySnapshot.docs.isNotEmpty)
                    {
                      querySnapshot.docs.forEach((result) {
                        print(result.data());
                        var userVo = UserVo.fromJson(result.data());
                        print(userVo.name);

                        Constants.saveSF(Constants.isLogin, "true");
                        Constants.saveSF(Constants.userName, userVo.username);
                        Constants.saveSF(Constants.userImage, userVo.image);
                        Constants.saveSF(Constants.userFullName, userVo.name);
                        Constants.saveSF(Constants.userEmail, userVo.email);
                        Constants.saveSF(Constants.userPhone, userVo.phone);
                        Constants.saveSF(Constants.userId, result.id);

                        EasyLoading.dismiss();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => home(),
                          ),
                          (route) => false,
                        );
                      })
                    }
                  else
                    {
                      EasyLoading.dismiss(),
                      Constants.errorToast('invalid credentials', context)
                    }
                })
            .catchError((e) => {
                  EasyLoading.dismiss(),
                  print("Error=> " + e.toString()),
                  Constants.errorToast(e.toString(), context)
                });
        //return '$user';
      } else {
        Constants.errorToast('no user exists, please sign up', context);
      }
    }

    Future<void> signInWithFacebook() async {
      try {
        // by default the login method has the next permissions ['email','public_profile']
        AccessToken accessToken = await FacebookAuth.instance.login();
        print(accessToken.toJson());
        // get the user data
        final userData = await FacebookAuth.instance.getUserData();
        print(userData);

        print("name is : " + userData['name']);
        print("url is : " + userData['picture']['data']['url']);
      } on FacebookAuthException catch (e) {
        switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            print("You have a previous login operation in progress");
            break;
          case FacebookAuthErrorCode.CANCELLED:
            print("login cancelled");
            break;
          case FacebookAuthErrorCode.FAILED:
            print("login failed");
            break;
        }
      }
    }

    Future<void> signInWithFacebook1() async {
      try {
        // Trigger the sign-in flow
        final AccessToken result = await FacebookAuth.instance.login();

        // Create a credential from the access token
        final FacebookAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.token);

        UserCredential credential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        // Once signed in, return the UserCredential
        print(credential);
        final User user = credential.user;

        //user.uid
        //user.name

        if (user != null) {
          Constants.successToast(user.displayName, context);
        }
      } on FacebookAuthException catch (e) {
        switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            print("You have a previous login operation in progress");
            break;
          case FacebookAuthErrorCode.CANCELLED:
            print("login cancelled");
            break;
          case FacebookAuthErrorCode.FAILED:
            print("login failed");
            break;
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Constants.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image(
                    image: AssetImage('res/logo.png'),
                    height: size.height * .15,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Log In',
                style: TextStyle(
                    color: Constants.red,
                    fontSize: 20,
                    fontFamily: 'pSemiBold'),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  xInputField(
                    placeHolder: 'Username',
                    icon: Icons.person,
                    textInputType: TextInputType.text,
                    isPassword: false,
                    validator: (name) {
                      if (name.isEmpty)
                        return 'username can not be blank';
                      else
                        return null;
                    },
                    onSaved: (name) => username = name,
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
                      else
                        return null;
                    },
                    onSaved: (name) => password = name,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => forgotPasswordPage()));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Constants.red,
                        fontSize: 16,
                        fontFamily: 'pMedium'),
                  ),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.red)),
                onPressed: () {
                  checkUser(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'LOG IN',
                    style: TextStyle(
                        color: Constants.white,
                        fontSize: 16,
                        fontFamily: 'pMedium'),
                  ),
                ),
                color: Constants.red,
              ),
              RaisedButton.icon(
                icon: Image.asset(
                  "res/google.png",
                  height: 30,
                ),
                label: Text("Google"),
                onPressed: () {
                  signInWithGoogle();
                },
              ),
              RaisedButton.icon(
                icon: Image.asset(
                  "res/facebook.png",
                  height: 30,
                ),
                label: Text("Facebook"),
                onPressed: () {
                  signInWithFacebook1();
                },
              ),
              RaisedButton.icon(
                icon: Image.asset(
                  "res/facebook.png",
                  height: 30,
                ),
                label: Text("Logout"),
                onPressed: () {
                  Constants.signOut();
                },
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpPage()));
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
                              text: 'New to Tap\'D?   ',
                              style: TextStyle(
                                  color: Constants.white,
                                  fontSize: 14,
                                  fontFamily: 'pRegular'),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Join Now',
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
        ),
      )),
    );
  }
}

Future<void> checkUser(BuildContext context) async {
  if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
  } else {
    return;
  }

  if (!await Constants.isOnline()) {
    Constants.errorToast(Constants.no_internet, context);
    return;
  }

  EasyLoading.show(status: 'loading...');

  FirebaseFirestore.instance
      .collection("users")
      .where("username", isEqualTo: username)
      .where("password", isEqualTo: Constants.encryptString(password))
      .get()
      .then((QuerySnapshot querySnapshot) => {
            if (querySnapshot.docs.isNotEmpty)
              {
                querySnapshot.docs.forEach((result) {
                  print(result.data());
                  var userVo = UserVo.fromJson(result.data());
                  print(userVo.name);

                  Constants.saveSF(Constants.isLogin, "true");
                  Constants.saveSF(Constants.userName, userVo.username);
                  Constants.saveSF(Constants.userImage, userVo.image);
                  Constants.saveSF(Constants.userFullName, userVo.name);
                  Constants.saveSF(Constants.userEmail, userVo.email);
                  Constants.saveSF(Constants.userPhone, userVo.phone);
                  Constants.saveSF(Constants.userId, result.id);

                  EasyLoading.dismiss();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => home(),
                    ),
                    (route) => false,
                  );
                })
              }
            else
              {
                EasyLoading.dismiss(),
                Constants.errorToast('invalid credentials', context)
              }
          })
      .catchError((e) => {
            EasyLoading.dismiss(),
            print("Error=> " + e.toString()),
            Constants.errorToast(e.toString(), context)
          });
}
