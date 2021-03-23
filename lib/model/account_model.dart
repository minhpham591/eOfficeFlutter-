import 'dart:convert';

import 'package:crypto/crypto.dart';

class AccountResponseModel {
  int id;
  String name;
  String email;
  String avatar;
  String password;
  String phone;
  String address;
  int subDepartmentId;
  int departmentId;
  int status;

  String company;

  AccountResponseModel(
      {this.id,
      this.avatar,
      this.password,
      this.phone,
      this.address,
      this.departmentId,
      this.subDepartmentId,
      this.status,
      this.name,
      this.company});
  factory AccountResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountResponseModel(
      id: json["id"] != null ? json["id"] : "",
      avatar: json["avatar"] != null ? json["avatar"] : "",
      password: json["password"] != null ? json["password"] : "",
      phone: json["phone"] != null ? json["phone"] : "",
      address: json["address"] != null ? json["address"] : "",
      subDepartmentId:
          json["subDepartmentId"] != null ? json["subDepartmentId"] : "",
      departmentId: json["departmentId"] != null ? json["departmentId"] : "",
      status: json["status"] != null ? json["status"] : "",
      name: json["name"] != null ? json["name"] : "",
      company: json["company"] != null ? json["company"] : "",
    );
  }
}

class AccountRequestModel {
  int id;

  String newPassword;
  String oldPassword;

  AccountRequestModel({
    this.id,
    this.newPassword,
    this.oldPassword,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "newPassword": md5.convert(utf8.encode(newPassword.trim())).toString(),
      "oldPassword": md5.convert(utf8.encode(oldPassword.trim())).toString(),
    };
    return map;
  }
}

class ForgotPasswordRequestModel {
  String email;
  String newPassword;

  ForgotPasswordRequestModel({
    this.email,
    this.newPassword,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "email": email,
      "newPassword": md5.convert(utf8.encode(newPassword.trim())).toString(),
    };
    return map;
  }
}

class LogoutRequestModel {
  int id;
  String device;
  LogoutRequestModel({
    this.id,
    this.device,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "device": device,
    };
    return map;
  }
}

class ChangeAccount {
  int id;
  String email;
  String avatar;
  String password;
  String phone;
  String address;
  int subDepartmentId;
  int departmentId;
  int status;

  ChangeAccount(
      {this.id,
      this.address,
      this.avatar,
      this.departmentId,
      this.email,
      this.password,
      this.phone,
      this.status,
      this.subDepartmentId});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "avatar": avatar,
      "password": password,
      "phone": phone,
      "address": address,
      "subDepartmentId": subDepartmentId,
      "departmentId": departmentId,
      "status": status,
    };
    return map;
  }
}
