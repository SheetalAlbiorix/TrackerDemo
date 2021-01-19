import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tap_d/common/Constants.dart';
import 'package:tap_d/model/DefaultLinkVo.dart';

void menuDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'res/cancel.png',
                        height: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

void qrDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'res/cancel.png',
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: QrImage(
                    data: "1234567890",
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Constants.white,
                    gapless: true,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void socialItemDialog(
    context, DefaultLinkVo linksVo, double xPos, double yPos, height, width) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'res/cancel.png',
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(xPos, yPos, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      linksVo.image,
                      height: height,
                      width: width,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
