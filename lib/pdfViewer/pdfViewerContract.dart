import 'dart:convert';
import 'dart:io';

import 'package:EOfficeMobile/model/document_model.dart';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/signScreen/signScreenContract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

LoginResponseModel testvalue;
int contractId;
int status;
String _url = "";

class MyPdfViewer extends StatefulWidget {
  MyPdfViewer(LoginResponseModel _value, int contractID, int statusSign) {
    testvalue = _value;
    contractId = contractID;
    status = statusSign;
  }
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyPdfViewer> {
  Future<void> getContractByID() async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/contracts/$contractId";
    final response = await http.get(
      url,
      headers: <String, String>{
        "accept": "text/plain",
        'Authorization': 'Bearer ${testvalue.token}'
      },
    );
    if (response.statusCode == 200) {
      //Contract.fromJson(json.decode(response.body));

      _url = DocContractResponseModel.fromJson(json.decode(response.body)).url;
      getFileFromUrl(_url).then(
        (value) => {
          setState(() {
            if (value != null) {
              urlPDFPath = value.path;
              loaded = true;
              exists = true;
            } else {
              exists = false;
            }
          })
        },
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      File urlFile = await file.writeAsBytes(bytes);

      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      requestPersmission();
      getContractByID();
    });
    if (loaded) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(''),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_box),
              color: Colors.grey,
              iconSize: 35,
              onPressed: () {
                if (status == 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MySignScreen(testvalue, contractId)),
                  );
                } else if (status == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      content: new Text('You have been already sign'),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: new Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else if (status == 2) {
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      content: new Text('You have been assign to view'),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: new Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
                //_showToast(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              color: Colors.grey,
              iconSize: 35,
              onPressed: () {
                Navigator.pop(context);

                //_showToast(context);
              },
            ),
          ],
        ),
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          nightMode: false,
          onError: (e) {
            //Show some error message or UI
          },
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (int page, int total) {
            setState(() {
              _currentPage = page;
            });
          },
          onPageError: (page, e) {},
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage > 0) {
                    _currentPage--;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
            Text(
              "${_currentPage + 1}/$_totalPages",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage < _totalPages - 1) {
                    _currentPage++;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
          ],
        ),
      );
    } else {
      if (exists) {
        //Replace with your loading UI
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("PDF Viewer"),
          ),
          body: Text(
            "Loading..",
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        //Replace Error UI
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("PDF Viewer"),
          ),
          body: Text(
            "PDF Not Available",
            style: TextStyle(fontSize: 20),
          ),
        );
      }
    }
  }
}
