import 'dart:math';
import 'dart:ui';
import 'package:EOfficeMobile/model/login_model.dart';
import 'package:EOfficeMobile/search/result_contract.dart';
import 'package:EOfficeMobile/search/result_invoice.dart';
import 'package:flutter/material.dart';

LoginResponseModel testvalue;
String content = searchController.text;
TextEditingController searchController = new TextEditingController();

class Search extends StatefulWidget {
  Search(LoginResponseModel _value) {
    testvalue = _value;
  }
  @override
  _MyAppPageState createState() => _MyAppPageState();
}

enum SingingCharacter { contract, invoice }

class _MyAppPageState extends State<Search> {
  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: Colors.grey);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SingingCharacter _character = SingingCharacter.contract;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // set up the AlertDialog

  @override
  Widget build(BuildContext context) {
    final searchField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Please enter name of contract or invoice",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      controller: searchController,
    );
    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          print(content);
          if (_character.toString() == "SingingCharacter.contract") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultContract(testvalue, content),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultInvoice(testvalue, content),
              ),
            );
          }
        },
        child: Text(
          "Search",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: Image.asset(
                "assets/images/8.png",
                fit: BoxFit.contain,
              ),
            ),
            searchField,
            ListTile(
              title: const Text('Contract'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.contract,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Invoice'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.invoice,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            nextButton,
          ],
        ),
      ),
    );
  }
}
