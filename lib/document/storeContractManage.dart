import 'dart:convert';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerContract.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerContractAfterSign.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

LoginResponseModel testvalue;
TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.grey);

class StoreContractManage extends StatefulWidget {
  StoreContractManage(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StoreContractManage> {
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

    if (jsonResponse == null) {
      return Scaffold(
        body: Center(
          child: Container(
            child: Text(
              'Loading...',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
        ),
      );
    } else if (jsonResponse.toString() == "[]") {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(100),
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  child: Image.asset(
                    "assets/images/27.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        // appBar: AppBar(
        //     backgroundColor: Colors.white,
        //     title: Container(
        //       margin: const EdgeInsets.all(1.0),
        //       padding: const EdgeInsets.all(1.0),
        //       decoration: BoxDecoration(
        //           border: Border.all(color: Colors.grey, width: 1)),
        //       child: Row(children: <Widget>[
        //         Column(children: <Widget>[
        //           Container(
        //             width: 85,
        //             margin: const EdgeInsets.all(10.0),
        //             padding: const EdgeInsets.all(5.0),
        //             child: Text(
        //               "Title",
        //               style: style,
        //             ),
        //           )
        //         ]),
        //         Column(children: <Widget>[
        //           Container(
        //             width: 90,
        //             margin: const EdgeInsets.all(10.0),
        //             padding: const EdgeInsets.all(5.0),
        //             child: Text(
        //               "Sign",
        //               style: style,
        //             ),
        //           )
        //         ]),
        //         Column(children: <Widget>[
        //           Container(
        //             width: 100,
        //             margin: const EdgeInsets.all(10.0),
        //             padding: const EdgeInsets.all(5.0),
        //             child: Text(
        //               "Date Expire",
        //               style: style,
        //             ),
        //           )
        //         ]),
        //       ]),
        //     )),
        body: ListView.builder(
          itemCount: jsonResponse != null ? jsonResponse.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (jsonResponse[index]["status"].toString() == "2" ||
                    jsonResponse[index]["status"].toString() == "3") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPdfViewerAfterContract(
                          testvalue, jsonResponse[index]["id"]),
                    ),
                  );
                } else {
                  if (jsonResponse[index]["contractSigners"]
                      .toString()
                      .contains("signerId: ${testvalue.id}")) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPdfViewerContract(
                            testvalue, jsonResponse[index]["id"]),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPdfViewerAfterContract(
                            testvalue, jsonResponse[index]["id"]),
                      ),
                    );
                  }
                }
              },
              child: ListTile(
                  title: Container(
                      margin: const EdgeInsets.all(1.0),
                      padding: const EdgeInsets.all(1.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                                  Offset(4, 8), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: <Widget>[
                        Column(children: <Widget>[
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: const EdgeInsets.all(20.0),
                                //padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  jsonResponse[index]["title"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              )
                            ],
                          ),
                          Row(children: <Widget>[
                            if (jsonResponse[index]["status"]
                                .toString()
                                .contains('0'))
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    jsonResponse[index]["dateExpire"]
                                        .toString()
                                        .substring(0, 10),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w800),
                                  )),
                            if (jsonResponse[index]["status"]
                                .toString()
                                .contains('3'))
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    jsonResponse[index]["dateExpire"]
                                        .toString()
                                        .substring(0, 10),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w800),
                                  )),
                            if (jsonResponse[index]["status"]
                                .toString()
                                .contains('1'))
                              if (jsonResponse[index]["signs"]
                                  .toString()
                                  .contains("signerId: ${testvalue.id}"))
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      jsonResponse[index]["dateExpire"]
                                          .toString()
                                          .substring(0, 10),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.w800),
                                    )),
                            if (jsonResponse[index]["status"]
                                .toString()
                                .contains('2'))
                              if (jsonResponse[index]["signs"]
                                  .toString()
                                  .contains("signerId: ${testvalue.id}"))
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      jsonResponse[index]["dateExpire"]
                                          .toString()
                                          .substring(0, 10),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.w800),
                                    )),
                          ]),
                        ]),
                        if (jsonResponse[index]["status"]
                            .toString()
                            .contains('2'))
                          Column(children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.green,
                                    semanticLabel: "Signed",
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.green,
                                    semanticLabel: "Signed",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Signed',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        if (jsonResponse[index]["status"]
                            .toString()
                            .contains('1'))
                          Column(children: <Widget>[
                            if (jsonResponse[index]["signs"].toString() != '[]')
                              if (jsonResponse[index]["signs"].toString().contains(
                                  "signerId: ${jsonResponse[index]["contractSigners"][0]["signerId"]}"))
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(5.0),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.create,
                                        color: Colors.green,
                                        semanticLabel: "You've signed",
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(5.0),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.create,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                            if (jsonResponse[index]["signs"].toString() != '[]')
                              if (jsonResponse[index]["signs"].toString().contains(
                                  "signerId: ${jsonResponse[index]["contractSigners"][1]["signerId"]}"))
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(5.0),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.create,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(5.0),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.create,
                                        color: Colors.green,
                                        semanticLabel: "You've signed",
                                      ),
                                    )
                                  ],
                                ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Pre-Signed',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        if (jsonResponse[index]["status"]
                            .toString()
                            .contains('0'))
                          Column(children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.red,
                                    semanticLabel: "Not Signed",
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.red,
                                    semanticLabel: "Not Signed",
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        if (jsonResponse[index]["status"]
                            .toString()
                            .contains('3'))
                          Column(children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.grey,
                                    semanticLabel: "Not Signed",
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.create,
                                    color: Colors.grey,
                                    semanticLabel: "Not Signed",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Expiration',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                      ]))),
            );
          },
        ),
      );
    }
  }
}
