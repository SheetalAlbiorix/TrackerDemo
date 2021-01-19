import 'package:flutter/material.dart';

class UserLinkVo {
  String image;
  String defaultLink;
  String title;
  String defaultId;
  String username;
  String bgImage;
  bool isDefault;

  String id;
  TextEditingController controller = new TextEditingController();
  GlobalKey key = new GlobalKey();

  UserLinkVo(
      {this.image,
      this.defaultLink,
      this.title,
      this.bgImage,
      this.isDefault,
      this.controller,
      this.key,
      this.id});

  UserLinkVo.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    defaultLink = json['defaultLink'];
    title = json['title'];
    defaultId = json['defaultId'];
    username = json['username'];
    bgImage = json['bgImage'];
    isDefault = json['isDefault'];
    controller.text = '@' + username;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['defaultLink'] = this.defaultLink;
    data['title'] = this.title;
    data['defaultId'] = this.defaultId;
    data['username'] = this.username;
    data['bgImage'] = this.bgImage;
    data['isDeafult'] = this.isDefault;
    return data;
  }
}
