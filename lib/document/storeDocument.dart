import 'dart:ui';

import 'package:EOfficeMobile/document/storeContract.dart';
import 'package:EOfficeMobile/document/storeContractManage.dart';

import 'package:EOfficeMobile/document/storeInvoice.dart';
import 'package:EOfficeMobile/document/storeInvoiceManage.dart';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:flutter/material.dart';

LoginResponseModel testvalue;

class StoreDocument extends StatefulWidget {
  StoreDocument(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

TextStyle style = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.grey,
);

class _MyHomePageState extends State<StoreDocument> {
  @override
  Widget build(BuildContext context) {
    if (testvalue.role.toString() == '1') {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Document",
              style: style,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Contract',
                    style: style,
                  ),
                ),
                Tab(
                  child: Text(
                    'Invoice',
                    style: style,
                  ),
                ),
              ],
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.all(10.0),
              indicatorColor: Colors.red,
            ),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              StoreContractManage(testvalue),
              StoreInvoiceManage(testvalue),
            ],
          ),
        ),
      );
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Document",
              style: style,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Contract',
                    style: style,
                  ),
                ),
                Tab(
                  child: Text(
                    'Invoice',
                    style: style,
                  ),
                ),
              ],
              indicatorWeight: 2,
              indicatorPadding: EdgeInsets.all(10.0),
              indicatorColor: Colors.red,
            ),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              StoreContract(testvalue),
              StoreInvoice(testvalue),
            ],
          ),
        ),
      );
    }
  }
}
