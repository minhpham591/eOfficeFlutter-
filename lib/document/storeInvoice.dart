import 'dart:convert';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerInvoice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

LoginResponseModel testvalue;
TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey);

class StoreInvoice extends StatefulWidget {
  StoreInvoice(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StoreInvoice> {
  List jsonResponse;
  Future<void> getInvoiceByID() async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/invoices/getbysignerid?signerId=${testvalue.id}";
    final response = await http.get(
      url,
      headers: <String, String>{
        "accept": "*/*",
      },
    );
    if (response.statusCode == 200) {
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
      getInvoiceByID();
    });
    int notSigned = 0;
    int signed = 1;
    if (jsonResponse == null) {
      return Scaffold(
        body: Container(
          child: Text('Loading...'),
        ),
      );
    } else if (jsonResponse.toString() == "[]") {
      return Scaffold(
        body: Container(
          child: Text('Not invoice yet'),
        ),
      );
    } else {
      return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Container(
              margin: const EdgeInsets.all(1.0),
              padding: const EdgeInsets.all(1.0),
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
                    margin: const EdgeInsets.all(20.0),
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
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Date Expire",
                      style: style,
                    ),
                  )
                ]),
              ]),
            )),
        body: new ListView.builder(
          itemCount: jsonResponse == null ? 0 : jsonResponse.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if (jsonResponse[index]["status"].toString() == '3') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPdfViewer(
                          testvalue,
                          jsonResponse[index]["invoiceURL"],
                          jsonResponse[index]["id"],
                          signed),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPdfViewer(
                          testvalue,
                          jsonResponse[index]["invoiceURL"],
                          jsonResponse[index]["id"],
                          notSigned),
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
                        if (jsonResponse[index]["status"].toString() == '3')
                          Column(children: <Widget>[
                            Container(
                              width: 100,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 10.0)),
                              child: Text("Signed"),
                            )
                          ]),
                        if (jsonResponse[index]["status"].toString() != '3')
                          Column(children: <Widget>[
                            Container(
                              width: 100,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.red, width: 10.0)),
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
}
