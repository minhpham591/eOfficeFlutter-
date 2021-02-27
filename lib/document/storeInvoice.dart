import 'dart:convert';
import 'package:EOfficeMobile/api/api_service.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;

LoginResponseModel testvalue;

class StoreInvoice extends StatefulWidget {
  StoreInvoice(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StoreInvoice> {
  List jsonResponse;
  Future<void> getContractByID() async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/invoices/getbysignerid?id=${testvalue.id}";
    final response = await http.get(
      url,
      headers: <String, String>{
        "accept": "*/*",
      },
    );
    print("status code for list = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    this.getContractByID();
  }

  @override
  Widget build(BuildContext context) {
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
                //return new ListTile(
                onTap: null,
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
