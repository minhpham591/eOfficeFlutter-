import 'dart:convert';
import 'dart:ui';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

LoginResponseModel testvalue;

class dashboard extends StatefulWidget {
  dashboard(LoginResponseModel _value) {
    testvalue = _value;
  }
  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<dashboard> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  String numberContractSigned;
  String numberInvoiceSigned;
  String numberContractNotSigned;
  String numberInvoiceNotSigned;
  Future<void> getNumberContractSignedByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/contracts/getnumberofcontractsigned?id=$id";
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
        numberContractSigned = json.decode(response.body).toString();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getNumberContractNotSignedByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/contracts/getnumberofcontractnotsign?id=$id";
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
        numberContractNotSigned = json.decode(response.body).toString();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getNumberInvoiceSignedByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/invoices/getnumberofinvoicesigned?id=$id";
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
        numberInvoiceSigned = json.decode(response.body).toString();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getNumberInvoiceNotSignedByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/invoices/getnumberofinvoicenotsign?id=$id";
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
        numberInvoiceNotSigned = json.decode(response.body).toString();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getNumberContractSignedByID(testvalue.id);
      getNumberContractNotSignedByID(testvalue.id);
      getNumberInvoiceSignedByID(testvalue.id);
      getNumberInvoiceNotSignedByID(testvalue.id);
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 350,
                child: Image.asset(
                  "assets/images/7.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          Container(
            height: 150,
          ),
          Container(
            margin: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                color: Colors.blue[800],
                border: Border.all(color: Colors.grey, width: 0.25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(4, 8), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(children: [
                      Container(
                        width: 10,
                      ),
                    ]),
                    Column(children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(testvalue.avatar),
                        radius: 25,
                      ),
                    ]),
                    Column(children: [
                      Container(
                        width: 25,
                      ),
                    ]),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              testvalue.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              testvalue.company,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 50,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 130,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Amount",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    Container(
                      width: 75,
                    ),
                    Column(
                      children: [
                        Text(
                          "Signed",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    Container(
                      width: 75,
                    ),
                    Column(
                      children: [
                        Text(
                          "Not signed yet",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Contract",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          ],
                        ),
                        Container(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text(
                              "Invoice",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      width: 15,
                    ),
                    Column(
                      children: [
                        new Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          child: Text("\n\n\n\n\n\n\n"),
                        )
                      ],
                    ),
                    Container(
                      width: 35,
                    ),
                    Column(
                      children: [
                        Text(
                          "Amount",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Container(
                          height: 30,
                        ),
                        Text(
                          "Amount",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    Container(
                      width: 100,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (numberContractSigned != null)
                          Text(
                            numberContractSigned,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        Container(
                          height: 30,
                        ),
                        if (numberInvoiceSigned != null)
                          Text(
                            numberInvoiceSigned,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                      ],
                    ),
                    Container(
                      width: 100,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (numberContractNotSigned != null)
                          Text(
                            numberContractNotSigned,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        Container(
                          height: 30,
                        ),
                        if (numberInvoiceNotSigned != null)
                          Text(
                            numberInvoiceNotSigned,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
