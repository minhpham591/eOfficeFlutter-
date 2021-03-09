import 'dart:convert';

import 'package:crypto/crypto.dart';

class LoginResponseModel {
  final String token;
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final String role;
  final int companyId;
  final String company;
  final String address;
  LoginResponseModel(
      {this.token,
      this.avatar,
      this.email,
      this.name,
      this.phone,
      this.id,
      this.role,
      this.companyId,
      this.company,
      this.address});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return new LoginResponseModel(
      token: json["IdToken"] != null ? json["IdToken"] : "",
      name: json["Name"] != null ? json["Name"] : "",
      email: json["Email"] != null ? json["Email"] : "",
      avatar: json["Avatar"] != null ? json["Avatar"] : "",
      phone: json["Phone"] != null ? json["Phone"] : "",
      id: json["Id"] != null ? json["Id"] : "",
      role: json["Role"] != null ? json["Role"] : "",
      companyId: json["CompanyId"] != null ? json["CompanyId"] : "",
      company: json["company"] != null ? json["company"] : "",
      address: json["address"] != null ? json["address"] : "",
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
