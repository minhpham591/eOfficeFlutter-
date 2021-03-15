import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/model/sign_model.dart';
import 'package:EOfficeMobile/pdfViewer/pdfViewerInvoiceAfterSign.dart';
import 'package:EOfficeMobile/signScreen/signOTPResendInvoice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

LoginResponseModel testvalue;
int contractId;
String phone;
String verificationId;
Uint8List png;
int countResend;

class EnterOTPToSignInvoice extends StatelessWidget {
  EnterOTPToSignInvoice(String _phone, String _vertificationId, Uint8List _png,
      LoginResponseModel _value, int id, int _countResend) {
    phone = _phone;
    verificationId = _vertificationId;
    png = _png;
    testvalue = _value;
    contractId = id;
    countResend = _countResend;
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  String pin = null;
  RegExp regexPin = new RegExp(r'(^(?:[+0]9)?[0-9]{6,6}$)');
  Future<void> addSignToContract(
      SignToInvoice signModel, BuildContext context) async {
    String url =
        "https://datnxeoffice.azurewebsites.net/api/invoices/addsigntoinvoice";
    var body = json.encode(signModel.toJson());
    final response = await http.put(url,
        headers: <String, String>{
          "Accept": "text/plain",
          "content-type": "application/json-patch+json",
          'Authorization': 'Bearer ${testvalue.token}'
        },
        body: body);
    print("status code for sign to contract" + response.statusCode.toString());
    if (response.statusCode == 200) {
      _showToastSuccess(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

  _verifyPhone(
      Uint8List png,
      BuildContext context,
      int count,
      String phone,
      String verificationId,
      LoginResponseModel testvalue,
      int contractId) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          verificationId = verficationID;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => EnterOTPResendToSignInvoice(
                    phone, verificationId, png, testvalue, contractId, count)),
            ModalRoute.withName('/'),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: Duration(seconds: 120));
  }

  SignToInvoice adSign = SignToInvoice();

  DateTime now = DateTime.now();
  Future<void> _createFileFromString(
      Uint8List png, BuildContext context) async {
    String dir = (await getTemporaryDirectory()).path;
    String fullPath = '$dir/temp$now.png';
    print("local file full path $fullPath");
    File file = File(fullPath);
    await file.writeAsBytes(png);
    print(file.path);
    String fileName = basename(file.path);
    print(fileName);
    dio.FormData formData = dio.FormData.fromMap({
      "Id": 0,
      "SignerId": testvalue.id,
      "SignUrl":
          await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "DateCreate": now,
      "InvoiceId": contractId,
    });
    dio.Dio d = new dio.Dio();

    d.options.headers["Authorization"] = "Bearer ${testvalue.token}";
    var response = await d.post(
        "https://datnxeoffice.azurewebsites.net/api/invoicesigns/addinvoicesign",
        data: formData);
    print(response.data['id']);
    print(response.data);
    adSign.invoiceId = contractId;
    adSign.signId = response.data['id'];
    addSignToContract(adSign, context);
  }

  @override
  Widget build(BuildContext context) {
    final OTPtextField = OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width,
      fieldWidth: 50,
      style: TextStyle(fontSize: 14),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.box,
      onCompleted: (value) {
        pin = value;
      },
      onChanged: (value) {
        pin = value;
      },
    );
    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          try {
            FirebaseAuth.instance
                .signInWithCredential(PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: pin))
                .then((value) async {
              if (value.user != null) {
                _createFileFromString(png, context);
              }
            });
          } on FirebaseAuthException catch (_) {
            _showToast(context);
          }
        },
        child: Text(
          "Verifying",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final resendButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          if (countResend <= 3) {
            countResend++;
            _verifyPhone(png, context, countResend, phone, verificationId,
                testvalue, contractId);
          }
        },
        child: Text(
          "Resend $countResend /3",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(''),
        actions: <Widget>[
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
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 110,
                  child: Image.asset(
                    "assets/images/17.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Confirm OTP",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 45),
                OTPtextField,
                SizedBox(height: 25),
                nextButton,
                SizedBox(
                  height: 5,
                ),
                resendButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 45),
        content: const Text('OTP is wrong!!!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        action: SnackBarAction(
            label: "",
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }

  void _showToastSuccess(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(minutes: 1, seconds: 45),
        content: const Text('Signed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        action: SnackBarAction(
            label: "OK",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPdfViewer(testvalue, contractId)),
                ModalRoute.withName('/'),
              );
            }),
      ),
    );
  }
}
