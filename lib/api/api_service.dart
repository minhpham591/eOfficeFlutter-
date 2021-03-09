import 'dart:convert';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:http/http.dart' as http;

class APIService {
  int statusCode;
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
      statusCode = response.statusCode;
    }
  }
}
