import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/model/sign_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    String url = "https://datnxeoffice.azurewebsites.net/api/accounts/login";
    var body = json.encode(loginRequestModel.toJson());
    print(body);
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "*/*",
          "content-type": "application/json-patch+json"
        },
        body: body);
    print("status code = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addSign(Sign signModel) async {
    String url = "https://datnxeoffice.azurewebsites.net/api/signs/addsign";
    var body = json.encode(signModel.toJson());
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "text/plain",
          "content-type": "application/json-patch+json"
        },
        body: body);
    print("status code for sign" + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("add sign successful");
    } else {
      throw Exception('Failed to load data');
    }
  }
}
