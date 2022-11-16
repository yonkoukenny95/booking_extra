import 'package:booking_extra/model/Order.dart';
import 'package:booking_extra/model/Passenger.dart';
import 'package:booking_extra/screen/login.dart';
import 'package:booking_extra/screen/webview.dart';
import 'package:flutter/material.dart';

import 'model/User.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String tokenSession = "";
  setTokenSession(String cookie){
    tokenSession = cookie;
  }

  String getTokenSession(){
    return tokenSession;
  }

  static String userNm = "";
  static User user = new User();
  static Order order = new Order();
  static List<Passenger> listPassenger = new List<Passenger>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đặt Vé Giờ Chót',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}


