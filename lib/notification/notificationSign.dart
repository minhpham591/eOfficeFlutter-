import 'dart:convert';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/model/notificaton_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerContract.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerContractAfterSign.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerInvoice.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerInvoiceAfterSign.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

LoginResponseModel testvalue;
TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey);

class StoreSignerNotification extends StatefulWidget {
  StoreSignerNotification(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StoreSignerNotification> {
  List jsonResponse;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> getContractByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/notifications/getnotificationbysigner?id=${id}";
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

  Future<void> deteleByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/notifications/deletenotification?id=${id}";
    final response = await http.delete(
      url,
      headers: <String, String>{
        "accept": "*/*",
        'Authorization': 'Bearer ${testvalue.token}'
      },
    );
    if (response.statusCode == 200) {
      print('DELETE');
      _showToast(context);
      //Contract.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updatePassword(Status s) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/notifications/changestatus";
    var body = json.encode(s.toJson());
    print(body);
    final response = await http.put(url,
        headers: <String, String>{
          "Accept": "*/*",
          "content-type": "application/json-patch+json",
        },
        body: body);
    print("status code = " + response.statusCode.toString());
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getContractByID(testvalue.id);
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
        key: _scaffoldKey,
        body: ListView.builder(
          itemCount: jsonResponse != null ? jsonResponse.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {},
              child: ListTile(
                  title: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        FlatButton.icon(
                          height: 100,
                          onPressed: () {
                            Status s = new Status();
                            s.id = jsonResponse[index]['id'];
                            s.status = 1;
                            if (jsonResponse[index]['title']
                                .toString()
                                .toLowerCase()
                                .contains('sign')) {
                              if (jsonResponse[index]['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains('contract')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyPdfViewerContract(
                                        testvalue,
                                        jsonResponse[index]["objectId"]),
                                  ),
                                );
                              }
                              if (jsonResponse[index]['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains('invoice')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyPdfViewer(testvalue,
                                        jsonResponse[index]["objectId"]),
                                  ),
                                );
                              }
                            } else {
                              if (jsonResponse[index]['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains('contract')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyPdfViewerAfterContract(testvalue,
                                            jsonResponse[index]["objectId"]),
                                  ),
                                );
                              }
                              if (jsonResponse[index]['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains('invoice')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyPdfViewerAfter(
                                        testvalue,
                                        jsonResponse[index]["objectId"]),
                                  ),
                                );
                              }
                            }
                          },
                          color: Colors.blueAccent,
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.white70,
                          ),
                          label: Text(
                            'OPEN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 8),
                          ),
                        ),
                        FlatButton.icon(
                          height: 100,
                          onPressed: () {
                            deteleByID(jsonResponse[index]['id']);
                          },
                          color: Colors.redAccent,
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white70,
                          ),
                          label: Text(
                            'DELETE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 8),
                          ),
                        ),
                      ],
                      child: Container(
                          margin: const EdgeInsets.all(1.0),
                          padding: const EdgeInsets.all(1.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.grey, width: 0.25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(
                                      4, 8), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: <Widget>[
                            // Column(
                            //   children: <Widget>[
                            //     Container(
                            //       height: 100,
                            //       width: 100,
                            //       child: Image(
                            //         image: NetworkImage(
                            //             jsonResponse[index]["image"]),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Column(children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: const EdgeInsets.all(20.0),
                                    //padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      jsonResponse[index]["content"],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: const EdgeInsets.all(20.0),
                                    child: Text(
                                      jsonResponse[index]["createdDate"]
                                          .toString()
                                          .substring(0, 10),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ])))),
            );
          },
        ),
      );
    }
  }

  void _showToast(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        content: const Text('Delete successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
