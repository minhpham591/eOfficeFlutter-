import 'package:EOfficeMobile/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    String url = "https://datnxeoffice.azurewebsites.net/api/Admins";
    var body = json.encode(loginRequestModel.toJson());
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
