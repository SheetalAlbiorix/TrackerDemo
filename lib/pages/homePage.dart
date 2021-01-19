import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share/share.dart';
import 'package:tap_d/common/Constants.dart';
import 'package:tap_d/common/Dialogs.dart';
import 'package:tap_d/model/AllLinksVo.dart';
import 'package:tap_d/model/DefaultLinkVo.dart';
import 'package:tap_d/model/UserLinkVo.dart';

String userId;

// ignore: camel_case_types
class home extends StatefulWidget {
  List<DefaultLinkVo> defaultLinksVos = new List<DefaultLinkVo>();
  List<UserLinkVo> userLinksVos = new List<UserLinkVo>();
  List<AllLinksVo> allLinksVos = new List<AllLinksVo>();

  String userName = "", userFullName = "", userImage = "";

  @override
  _homeState createState() => _homeState();
}

// ignore: camel_case_types
class _homeState extends State<home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference defaultLinks =
      FirebaseFirestore.instance.collection('defaultLinks');
  CollectionReference userLink =
      FirebaseFirestore.instance.collection('userLinks');

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      //adUnitId: "ca-app-pub-6404923415520673/1912430438",
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  /*InterstitialAd createRewardedAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }*/

  void getData() async {
    EasyLoading.show(status: 'loading...');
    List<AllLinksVo> links = new List<AllLinksVo>();
    widget.userLinksVos = new List<UserLinkVo>();
    widget.defaultLinksVos = new List<DefaultLinkVo>();

    userId = await Constants.getSF(Constants.userId);

    await userLink
        .where("userId", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var userLinksVo = UserLinkVo.fromJson(result.data());

        userLinksVo.id = result.id;
        widget.userLinksVos.add(userLinksVo);

        AllLinksVo linksVo = AllLinksVo();
        linksVo.isUserLink = true;
        linksVo.subPos = widget.userLinksVos.length - 1;
        linksVo.userLinkVo = userLinksVo;

        links.add(linksVo);
      });
    });

    await defaultLinks.orderBy('pos').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var defaultLinkVo = DefaultLinkVo.fromJson(result.data());

        defaultLinkVo.id = result.id;
        widget.defaultLinksVos.add(defaultLinkVo);

        AllLinksVo linksVo = AllLinksVo();
        linksVo.isUserLink = false;
        linksVo.subPos = widget.defaultLinksVos.length - 1;
        linksVo.defaultLinkVo = defaultLinkVo;

        links.add(linksVo);
      });
    });

    setState(() {
      widget.allLinksVos = links;
    });
    EasyLoading.dismiss();
  }

  void checkValue() async {
    widget.userName = await Constants.getSF(Constants.userName);
    widget.userFullName = await Constants.getSF(Constants.userFullName);
    widget.userImage = await Constants.getSF(Constants.userImage);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState

    checkValue();
    getData();

    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    createBannerAd()
      ..load()
      ..show();

    /*FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    createInterstitialAd()
      ..load()
      ..show();*/

    RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId);

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          print(rewardAmount);
        });
      } else if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.black,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.light, //navigation bar icons' color
    ));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              margin: EdgeInsets.only(top: 60),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                color: Constants.lightGray,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: FractionalOffset.topRight,
                    child: Container(
                      height: 115,
                      margin: EdgeInsets.only(right: 50),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          color: Constants.lightWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 0.2,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              'QR',
                              style: TextStyle(
                                  fontFamily: 'pBold',
                                  color: Constants.textDark,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                qrDialog(context);
                              },
                              child: Image.asset(
                                'res/qr.png',
                                height: 30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: SizedBox(
                                height: 0.2,
                                width: 20,
                                child: Container(
                                  color: Constants.textDark,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Share.share(
                                    'check out my website https://google.com');
                              },
                              child: Image.asset(
                                'res/share.png',
                                height: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                              fontFamily: 'pLight',
                              color: Constants.textDark,
                              fontSize: 16,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          widget.userFullName,
                          style: TextStyle(
                              fontFamily: 'pRegular',
                              color: Constants.textDark,
                              fontSize: 18,
                              letterSpacing: 0.5),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'res/at.png',
                              height: 12,
                            ),
                            Text(
                              widget.userName,
                              style: TextStyle(
                                  fontFamily: 'pLight',
                                  color: Constants.textDark,
                                  fontSize: 12,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: size.height - 200,
              width: size.width,
              margin: EdgeInsets.only(top: 200),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)),
                color: Constants.lightWhite,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: widget.allLinksVos.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Column(
                              children: [
                                widget.allLinksVos[index].isUserLink
                                    ? Container(
                                        padding: EdgeInsets.only(right: 10),
                                        decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(20.0)),
                                          color: Constants.lightGray,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20.0)),
                                                  child: Stack(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: widget
                                                            .userLinksVos[widget
                                                                .allLinksVos[
                                                                    index]
                                                                .subPos]
                                                            .bgImage,
                                                      ),
                                                      Center(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: widget
                                                              .userLinksVos[widget
                                                                  .allLinksVos[
                                                                      index]
                                                                  .subPos]
                                                              .image,
                                                          height: 30,
                                                          color:
                                                              Constants.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: TextField(
                                                controller: widget
                                                    .userLinksVos[widget
                                                        .allLinksVos[index]
                                                        .subPos]
                                                    .controller,
                                                style: TextStyle(
                                                    fontFamily: 'pSemiBold',
                                                    fontSize: 14),
                                                keyboardType:
                                                    TextInputType.text,
                                                cursorColor: Constants.black,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 0.0),
                                                  ),
                                                  hintText: '@username',
                                                  hintStyle: TextStyle(
                                                      color: Color(0x25000000)),
                                                  focusColor: Constants.black,
                                                  filled: true,
                                                  fillColor:
                                                      Constants.transparent,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 0.0),
                                                  ),
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                                textInputAction:
                                                    TextInputAction.done,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                EasyLoading.show(
                                                    status: 'loading...');

                                                for (int i = 0;
                                                    i <
                                                        widget.userLinksVos
                                                            .length;
                                                    i++) {
                                                  if (widget.userLinksVos[i]
                                                      .isDefault) {
                                                    userLink
                                                        .doc(widget
                                                            .userLinksVos[i].id)
                                                        .update({
                                                          'isDefault': false
                                                        })
                                                        .then((value) => print(
                                                            "User Updated"))
                                                        .catchError((error) =>
                                                            print(
                                                                "Failed to update user: $error"));
                                                  }
                                                }
                                                userLink
                                                    .doc(widget
                                                        .userLinksVos[widget
                                                            .allLinksVos[index]
                                                            .subPos]
                                                        .id)
                                                    .update({
                                                      'isDefault': !widget
                                                          .userLinksVos[widget
                                                              .allLinksVos[
                                                                  index]
                                                              .subPos]
                                                          .isDefault
                                                    })
                                                    .then((value) =>
                                                        print("User Updated"))
                                                    .catchError((error) => print(
                                                        "Failed to update user: $error"));

                                                setState(() {
                                                  getData();
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Image.asset(
                                                  widget
                                                          .userLinksVos[widget
                                                              .allLinksVos[
                                                                  index]
                                                              .subPos]
                                                          .isDefault
                                                      ? 'res/instantSelected.png'
                                                      : 'res/instant.png',
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Widget cancelButton =
                                                    FlatButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                                Widget continueButton =
                                                    FlatButton(
                                                  child: Text("Yes"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    userLink
                                                        .doc(widget
                                                            .userLinksVos[widget
                                                                .allLinksVos[
                                                                    index]
                                                                .subPos]
                                                            .id)
                                                        .delete()
                                                        .then((value) => print(
                                                            "User Deleted"))
                                                        .catchError((error) =>
                                                            print(
                                                                "Failed to delete user: $error"));

                                                    setState(() {
                                                      getData();
                                                    });
                                                  },
                                                );
                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  title: Text("Delete"),
                                                  content: Text(
                                                      "Are you sure you want to delete?"),
                                                  actions: [
                                                    cancelButton,
                                                    continueButton,
                                                  ],
                                                );

                                                // show the dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Constants.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.only(right: 10),
                                        decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(20.0)),
                                            color: Constants.lightGray,
                                            border: Border.all(
                                                color: Constants.placeHolder)),
                                        key: widget
                                            .defaultLinksVos[widget
                                                .allLinksVos[index].subPos]
                                            .key,
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 80,
                                                height: 80,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20.0)),
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: widget
                                                              .defaultLinksVos[
                                                                  widget
                                                                      .allLinksVos[
                                                                          index]
                                                                      .subPos]
                                                              .image,
                                                          height: 30,
                                                          color: Constants
                                                              .textDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 40,
                                              width: 1,
                                              child: Container(
                                                color: Constants.placeHolder,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                style: TextStyle(
                                                    fontFamily: 'pSemiBold',
                                                    fontSize: 14),
                                                keyboardType:
                                                    TextInputType.text,
                                                cursorColor: Constants.black,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 0.0),
                                                  ),
                                                  hintText: '@username',
                                                  hintStyle: TextStyle(
                                                      color: Color(0x25000000)),
                                                  focusColor: Constants.black,
                                                  filled: true,
                                                  fillColor:
                                                      Constants.transparent,
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 0.0),
                                                  ),
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller: widget
                                                    .defaultLinksVos[widget
                                                        .allLinksVos[index]
                                                        .subPos]
                                                    .controller,
                                                onFieldSubmitted: (term) {
                                                  userLink
                                                      .add({
                                                        'username': widget
                                                            .defaultLinksVos[
                                                                widget
                                                                    .allLinksVos[
                                                                        index]
                                                                    .subPos]
                                                            .controller
                                                            .text,
                                                        'image': widget
                                                            .defaultLinksVos[
                                                                widget
                                                                    .allLinksVos[
                                                                        index]
                                                                    .subPos]
                                                            .image,
                                                        'defaultLink': widget
                                                            .defaultLinksVos[
                                                                widget
                                                                    .allLinksVos[
                                                                        index]
                                                                    .subPos]
                                                            .defaultLink,
                                                        'title': widget
                                                            .defaultLinksVos[
                                                                widget
                                                                    .allLinksVos[
                                                                        index]
                                                                    .subPos]
                                                            .title,
                                                        'defaultId': widget
                                                            .defaultLinksVos[
                                                                widget
                                                                    .allLinksVos[
                                                                        index]
                                                                    .subPos]
                                                            .id,
                                                        'bgImage': widget
                                                            .defaultLinksVos[
                                                                widget
                                                                    .allLinksVos[
                                                                        index]
                                                                    .subPos]
                                                            .bgImage,
                                                        'isDefault': false,
                                                        'createdAt':
                                                            DateTime.now(),
                                                        'userId': userId
                                                      })
                                                      .then((value) =>
                                                          print("User Added"))
                                                      .catchError((error) => print(
                                                          "Failed to add user: $error"));

                                                  getData();
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                    border: new Border.all(
                      color: Constants.lightGray,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ]),
                child: CircleAvatar(
                  radius: 50.0,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          Image.asset('res/user_placeholder.png'),
                      imageUrl: widget.userImage,
                    ),
                  ),
                  backgroundColor: Constants.lightGray,
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15, top: 10),
                child: GestureDetector(
                  onTap: () {
                    menuDialog(context);
                  },
                  child: Image.asset(
                    'res/menu.png',
                    height: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
