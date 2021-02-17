import 'package:EOfficeMobile/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:EOfficeMobile/model/upload_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/accounts/loginstaff";
    var body = json.encode(loginRequestModel.toJson());
    print(body);
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    print("status code = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future upload(UploadRequestModel uploadRequestModel) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/Accounts/testUpload";
    var body = json.encode(uploadRequestModel.toJson());
    print(body);
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    print("status code = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("success");
    } else {
      throw Exception('Failed to load data');
    }
  }
}
