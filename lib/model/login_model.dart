import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginResponseModel {
  final String token;
  final String error;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final String password;
  LoginResponseModel(
      {this.token,
      this.error,
      this.avatar,
      this.email,
      this.name,
      this.password,
      this.phone});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
      name: json["name"] != null ? json["name"] : "",
      email: json["email"] != null ? json["email"] : "",
      avatar: json["avatar"] != null ? json["avatar"] : "",
      phone: json["phone"] != null ? json["phone"] : "",
      password: json["password"] != null ? json["password"] : "",
    );
  }
}

class LoginRequestModel {
  String userName;
  String password;

  LoginRequestModel({
    this.userName,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': userName.trim(),
      'password': md5.convert(utf8.encode(password.trim())).toString(),
    };

    return map;
  }
}
