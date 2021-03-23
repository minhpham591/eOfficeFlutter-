import 'dart:convert';
import 'dart:io';
import 'package:EOfficeMobile/model/account_model.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

LoginResponseModel value;
ChangeAccount change = new ChangeAccount();
final _scaffoldKey = GlobalKey<ScaffoldState>();

class ImageUpload extends StatefulWidget {
  ImageUpload(LoginResponseModel _value) {
    value = _value;
  }
  @override
  State<StatefulWidget> createState() {
    return _ImageUpload();
  }
}

Future<void> getContractByID() async {
  String url =
      "https://datnxeoffice.azurewebsites.net/api/accounts/${value.id}";
  final response = await http.get(
    url,
    headers: <String, String>{
      "accept": "text/plain",
      'Authorization': 'Bearer ${value.token}'
    },
  );
  if (response.statusCode == 200) {
    change.password =
        AccountResponseModel.fromJson(json.decode(response.body)).password;
    change.phone =
        AccountResponseModel.fromJson(json.decode(response.body)).phone;
    change.address =
        AccountResponseModel.fromJson(json.decode(response.body)).address;
    change.subDepartmentId =
        AccountResponseModel.fromJson(json.decode(response.body))
            .subDepartmentId;
    change.departmentId =
        AccountResponseModel.fromJson(json.decode(response.body)).departmentId;
    change.status =
        AccountResponseModel.fromJson(json.decode(response.body)).status;
  } else {
    throw Exception('Failed to load data');
  }
}

class _ImageUpload extends State<ImageUpload> {
  File uploadimage;

  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      uploadimage = choosedimage;
    });
  }

  Future<void> uploadImage(BuildContext context) async {
    String uploadurl =
        "https://datnxeoffice.azurewebsites.net/api/accounts/updateaccount";
    List<int> imageBytes = uploadimage.readAsBytesSync();
    String baseimage = base64Encode(imageBytes);
    change.avatar = baseimage;
    change.id = value.id;
    var body = json.encode(change.toJson());
    var response = await http.put(uploadurl,
        headers: <String, String>{
          "accept": "text/plain",
          "content-type": "application/json-patch+json",
          'Authorization': 'Bearer ${value.token}'
        },
        body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      _showToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(''),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel),
            color: Colors.grey,
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);

              //_showToast(context);
            },
          ),
        ],
      ),
      body: Container(
        height: 300,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: uploadimage == null
                    ? Container()
                    : Container(
                        child: SizedBox(
                            height: 150, child: Image.file(uploadimage)))),
            Container(
                child: uploadimage == null
                    ? Container()
                    : Container(
                        child: RaisedButton.icon(
                        onPressed: () {
                          uploadImage(context);
                        },
                        icon: Icon(Icons.file_upload),
                        label: Text("UPLOAD IMAGE"),
                        color: Colors.blue,
                        colorBrightness: Brightness.dark,
                      ))),
            Container(
              child: RaisedButton.icon(
                onPressed: () {
                  getContractByID();
                  chooseImage();
                },
                icon: Icon(Icons.folder_open),
                label: Text("CHOOSE IMAGE"),
                color: Colors.blue,
                colorBrightness: Brightness.dark,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 10),
        content: const Text('Change avatar successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
