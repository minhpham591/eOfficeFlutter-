import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json["token"] != null ? json["token"] : "",
        error: json["error"] != null ? json["error"] : "");
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
