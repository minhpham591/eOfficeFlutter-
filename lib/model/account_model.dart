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
  int companyId;
  String role;
  String company;

  AccountResponseModel(
      {this.id,
      this.avatar,
      this.password,
      this.phone,
      this.address,
      this.companyId,
      this.departmentId,
      this.subDepartmentId,
      this.status,
      this.role,
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
      companyId: json["companyId"] != null ? json["companyId"] : "",
      role: json["role"] != null ? json["role"] : "",
      name: json["name"] != null ? json["name"] : "",
      company: json["company"] != null ? json["company"] : "",
    );
  }
}

class AccountRequestModel {
  int id;
  String avatar;
  String password;
  String phone;
  String address;
  int subDepartmentId;
  int departmentId;
  int status;
  int companyId;
  String role;

  AccountRequestModel(
      {this.id,
      this.avatar,
      this.password,
      this.phone,
      this.address,
      this.companyId,
      this.departmentId,
      this.subDepartmentId,
      this.status,
      this.role});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "avatar": avatar,
      "password": md5.convert(utf8.encode(password.trim())).toString(),
      "phone": phone,
      "address": address,
      "subDepartmentId": subDepartmentId,
      "departmentId": departmentId,
      "companyId": companyId,
      "status": status,
      "role": role,
    };
    return map;
  }
}
