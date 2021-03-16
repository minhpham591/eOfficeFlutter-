import 'dart:convert';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

LoginResponseModel testvalue;
TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey);

class StoreAllNotification extends StatefulWidget {
  StoreAllNotification(LoginResponseModel _value) {
    testvalue = _value;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<StoreAllNotification> {
  List jsonResponse;
  Future<void> getContractByID(int id) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/notifications/getnotificationbyaccountid?id=${id}";
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
      getContractByID(testvalue.id);
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
          child: Text('Not notification yet'),
        ),
      );
    } else {
      return Scaffold(
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
                            print('ok');
                          },
                          icon: Icon(
                            Icons.read_more,
                            color: Colors.blue,
                          ),
                          label: Text('OPEN'),
                        ),
                        FlatButton.icon(
                          height: 100,
                          onPressed: () {
                            print('delete');
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          label: Text(
                            'DELETE',
                          ),
                        ),
                      ],
                      child: Container(
                          margin: const EdgeInsets.all(1.0),
                          padding: const EdgeInsets.all(1.0),
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
                            Column(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image(
                                    image: NetworkImage(
                                        jsonResponse[index]["image"]),
                                  ),
                                ),
                              ],
                            ),
                            Column(children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(20.0),
                                //padding: const EdgeInsets.all(10.0),
                                child: Text(jsonResponse[index]["title"]),
                              ),
                              Container(
                                margin: const EdgeInsets.all(20.0),
                                //padding: const EdgeInsets.all(10.0),
                                child: Text(jsonResponse[index]["createdDate"]),
                              ),
                            ]),
                          ])))),
            );
          },
        ),
      );
    }
  }
}
