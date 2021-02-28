import 'dart:convert';
import 'package:EOfficeMobile/api/api_service.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
      setState(() {
        jsonResponse = json.decode(response.body);
        print(jsonResponse);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    this.getContractByID(testvalue.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int notSigned = 0;
    int signed = 1;
    return Scaffold(
      body: ListView.builder(
        itemCount: jsonResponse != null ? jsonResponse.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (jsonResponse[index]["signs"].toString() == "[]") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPdfViewer(
                        testvalue,
                        jsonResponse[index]["contractUrl"],
                        jsonResponse[index]["id"],
                        notSigned),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPdfViewer(
                        testvalue,
                        jsonResponse[index]["contractUrl"],
                        jsonResponse[index]["id"],
                        signed),
                  ),
                );
              }
            },
            child: ListTile(
                title: Container(
                    margin: const EdgeInsets.all(1.0),
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.25)),
                    child: Row(children: <Widget>[
                      Column(children: <Widget>[
                        Container(
                          width: 100,
                          margin: const EdgeInsets.all(20.0),
                          //padding: const EdgeInsets.all(5.0),
                          child: Text(jsonResponse[index]["description"]),
                        )
                      ]),
                      if (jsonResponse[index]["signs"].toString() != "[]")
                        Column(children: <Widget>[
                          Container(
                            width: 100,
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green, width: 5.0)),
                            child: Text("Signed"),
                          )
                        ]),
                      if (jsonResponse[index]["signs"].toString() == "[]")
                        Column(children: <Widget>[
                          Container(
                            width: 100,
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.red, width: 5.0)),
                            child: Text(
                              "Not Signed",
                            ),
                          )
                        ]),
                      Column(children: <Widget>[
                        Container(
                          width: 100,
                          margin: const EdgeInsets.all(15.0),
                          //padding: const EdgeInsets.all(5.0),
                          child: Text(jsonResponse[index]["dateExpire"]),
                        )
                      ]),
                    ]))),
          );
        },
      ),
    );
  }
}
