import 'dart:convert';

import 'package:booking_extra/main.dart';
import 'package:booking_extra/model/User.dart';
import 'package:booking_extra/screen/search.dart';
import 'package:booking_extra/util/constant.dart';
import 'package:booking_extra/util/dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'infoApp.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var userNmController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  login() async {
    var map = new Map<String, dynamic>();
    map["UserNm"] = userNmController.text;
    map["Password"] = passwordController.text;
    print(map);
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);
      print(host + '/Account/Validate');
      Client client = Client();
      var res = await client.post(Uri.parse(host + '/Account/Validate'),
          body: jsonEncode(map), headers: header);
      if (res.statusCode == 200) {
        MyApp.userNm = userNmController.text;
        MyApp.user = User.fromJson(json.decode(res.body));
        print(res.body);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      } else {
        print(res.headers);
        print(res.statusCode);
        throw Exception('Server error');
      }
    } catch (ex) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Dialogs.showMessage(context, "Đăng nhập thất bại",
          "Sai tên đăng nhập, mật khẩu hoặc tình trạng kết nối internet.");
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
//    final printButton1 = Material(
//      elevation: 5.0,
//      borderRadius: BorderRadius.circular(5.0),
//      color: Color(0xff134F89),
//      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width * 1 / 2 - 25,
//        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//        onPressed: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenShotPage()));
//        },
//        child: Text("In vé demo 1", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//      ),
//    );
//
//    final printButton2 = Material(
//      elevation: 5.0,
//      borderRadius: BorderRadius.circular(5.0),
//      color: Color(0xff134F89),
//      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width * 1 / 2 - 25,
//        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//        onPressed: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenShotPage()));
//        },
//        child: Text("In vé demo 2", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//      ),
//    );
//
//    final printButton3 = Material(
//      elevation: 5.0,
//      borderRadius: BorderRadius.circular(5.0),
//      color: Color(0xff134F89),
//      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width * 1 / 2 - 25,
//        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//        onPressed: () {
//          //Navigator.push(context, MaterialPageRoute(builder: (context) => PrintDemo2Page()));
//        },
//        child: Text("In vé demo 3", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//      ),
//    );

    final userNmField = TextField(
      controller: userNmController,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Tên đăng nhập",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mật khẩu",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff134F89),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          login();
        },
        child: Text("Đăng nhập",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final checkUpdateButton = Material(
      child: MaterialButton(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('App version:' + appVersion),
              SizedBox(width: 25.0),
              Icon(Icons.arrow_right, color: Color(0xff134F89)),
            ]),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InfoAppPage()),
          );
        },
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            color: Colors.white,
            height:MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.asset(
                      "assets/pqe-logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  userNmField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButton,
                  SizedBox(
                    height: 150,
                  ),
                  checkUpdateButton,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
