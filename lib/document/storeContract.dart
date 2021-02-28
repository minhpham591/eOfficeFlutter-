import 'dart:convert';
import 'package:EOfficeMobile/api/api_service.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;

LoginResponseModel testvalue;

class StoreContract extends StatefulWidget {
  StoreContract(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StoreContract> {
  List jsonResponse;
  Future<void> getContractByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/contracts/getcontractsbysignerid?id=${id}";
    final response = await http.get(
      url,
      headers: <String, String>{
        "accept": "*/*",
      },
    );
    print("status code for list = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print('load success');
      //Contract.fromJson(json.decode(response.body));
      jsonResponse = json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // @override
  // void initState() {
  //   this.getContractByID(testvalue.id);
  // }

  @override
  Widget build(BuildContext context) {
    getContractByID(testvalue.id);
    print(jsonResponse);
    return new Scaffold(
      body: new ListView.builder(
        itemCount: jsonResponse == null ? 0 : jsonResponse.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPdfViewer(
                        testvalue,
                        jsonResponse[index]["contractUrl"],
                        jsonResponse[index]["id"])),
              );
            },
            child: ListTile(
                title: Row(children: <Widget>[
              Expanded(child: Text(jsonResponse[index]["description"])),
              if (jsonResponse[index]["sign"] == null)
                Expanded(child: Text("Not signed")),
              if (jsonResponse[index]["sign"] != null)
                Expanded(child: Text("Signed")),
              Expanded(child: Text(jsonResponse[index]["dateExpire"])),
            ])),
          );
        },
      ),
    );
  }
}
