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
  int numberContractSigned;
  int numberInvoiceSigned;
  int numberContractNotSigned;
  int numberInvoiceNotSigned;
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
        numberContractSigned = json.decode(response.body);
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
        numberContractNotSigned = json.decode(response.body);
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
        numberInvoiceSigned = json.decode(response.body);
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
        numberInvoiceNotSigned = json.decode(response.body);
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
      body: Container(
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(1.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Image.asset(
                    "assets/images/7.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              margin: const EdgeInsets.all(1.0),
              padding: const EdgeInsets.all(1.0),
              width: MediaQuery.of(context).size.width * 0.75,
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
                          width: MediaQuery.of(context).size.width * 0.01,
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
                          width: MediaQuery.of(context).size.width * 0.025,
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
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Amounts",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.075,
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
                        width: MediaQuery.of(context).size.width * 0.075,
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
                        width: MediaQuery.of(context).size.width * 0.02,
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
                            height: MediaQuery.of(context).size.height * 0.03,
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
                        width: MediaQuery.of(context).size.width * 0.015,
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
                        width: MediaQuery.of(context).size.width * 0.035,
                      ),
                      Column(
                        children: [
                          if (numberContractSigned != null &&
                              numberContractNotSigned != null)
                            Text(
                              (numberContractSigned + numberContractNotSigned)
                                  .toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          if (numberInvoiceSigned != null &&
                              numberInvoiceNotSigned != null)
                            Text(
                              (numberInvoiceNotSigned + numberInvoiceSigned)
                                  .toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (numberContractSigned != null)
                            Text(
                              numberContractSigned.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          if (numberInvoiceSigned != null)
                            Text(
                              numberInvoiceSigned.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (numberContractNotSigned != null)
                            Text(
                              numberContractNotSigned.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          if (numberInvoiceNotSigned != null)
                            Text(
                              numberInvoiceNotSigned.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
