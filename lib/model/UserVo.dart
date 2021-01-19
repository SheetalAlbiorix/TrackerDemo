class UserVo {
  String image;
  String password;
  String phone;
  String name;
  String email;
  String username;

  UserVo(
      {this.image,
      this.password,
      this.phone,
      this.name,
      this.email,
      this.username});

  UserVo.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    password = json['password'];
    phone = json['phone'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['email'] = this.email;
    data['username'] = this.username;
    return data;
  }
}
