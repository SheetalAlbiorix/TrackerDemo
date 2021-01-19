import 'package:flutter/material.dart';

class DefaultLinkVo {
  String image;
  String defaultLink;
  String title;
  String bgImage;
  num pos;
  String id;
  GlobalKey key = new GlobalKey();
  TextEditingController controller = new TextEditingController();

  DefaultLinkVo(
      {this.image,
      this.defaultLink,
      this.title,
      this.key,
      this.bgImage,
      this.pos});

  DefaultLinkVo.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    defaultLink = json['defaultLink'];
    title = json['title'];
    bgImage = json['bgImage'];
    pos = json['pos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['defaultLink'] = this.defaultLink;
    data['title'] = this.title;
    data['bgImage'] = this.bgImage;
    data['pos'] = this.pos;
    return data;
  }
}
