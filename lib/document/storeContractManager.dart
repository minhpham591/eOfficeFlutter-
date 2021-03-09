import 'dart:convert';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerContract.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

LoginResponseModel testvalue;
TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey);

class StoreContractByCompanyId extends StatefulWidget {
  StoreContractByCompanyId(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StoreContractByCompanyId> {
  List jsonResponse;
  Future<void> getContractByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/contracts/getbycompany?id=${id}";
    final response = await http.get(
      url,
      headers: <String, String>{
        "accept": "*/*",
        'Authorization': 'Bearer ${testvalue.token}'
      },
    );
    if (response.statusCode == 200) {
      //Contract.fromJson(json.decode(response.body));
      setState(() {
        jsonResponse = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getContractByID(testvalue.companyId);
    });
    int notSigned = 0;
    int signed = 1;
    int notAssign = 2;

    if (jsonResponse == null) {
      return Scaffold(
        body: Container(
          child: Text('Loading...'),
        ),
      );
    } else if (jsonResponse.toString() == "[]") {
      return Scaffold(
        body: Container(
          child: Text('Not contract yet'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Container(
              margin: const EdgeInsets.all(1.0),
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1)),
              child: Row(children: <Widget>[
                Column(children: <Widget>[
                  Container(
                    width: 100,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Title",
                      style: style,
                    ),
                  )
                ]),
                Column(children: <Widget>[
                  Container(
                    width: 100,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Sign",
                      style: style,
                    ),
                  )
                ]),
                Column(children: <Widget>[
                  Container(
                    width: 100,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Date Expire",
                      style: style,
                    ),
                  )
                ]),
              ]),
            )),
        body: ListView.builder(
          itemCount: jsonResponse != null ? jsonResponse.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (jsonResponse[index]["contractSigners"]
                    .toString()
                    .contains("signerId: ${testvalue.id}")) {
                  if (jsonResponse[index]["signs"]
                      .toString()
                      .contains("signerId: ${testvalue.id}")) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPdfViewer(
                            testvalue, jsonResponse[index]["id"], signed),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPdfViewer(
                            testvalue, jsonResponse[index]["id"], notSigned),
                      ),
                    );
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPdfViewer(
                          testvalue, jsonResponse[index]["id"], notAssign),
                    ),
                  );
                }
              },
              child: ListTile(
                  title: Container(
                      margin: const EdgeInsets.all(1.0),
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.25)),
                      child: Row(children: <Widget>[
                        Column(children: <Widget>[
                          Container(
                            width: 100,
                            margin: const EdgeInsets.all(20.0),
                            //padding: const EdgeInsets.all(10.0),
                            child: Text(jsonResponse[index]["description"]),
                          )
                        ]),
                        if (jsonResponse[index]["signs"]
                            .toString()
                            .contains("signerId: ${testvalue.id}"))
                          Column(children: <Widget>[
                            Container(
                              width: 100,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.yellow, width: 10.0)),
                              child: Text("Have been Signed"),
                            )
                          ]),
                        if (!jsonResponse[index]["signs"]
                            .toString()
                            .contains("signerId: ${testvalue.id}"))
                          Column(children: <Widget>[
                            Container(
                              width: 100,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.red, width: 10.0)),
                              child: Text(
                                "Have not been Signed",
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
}