import 'dart:convert';

import 'package:booking_extra/main.dart';
import 'package:booking_extra/model/Route.dart';
import 'package:booking_extra/model/Voyage.dart';
import 'package:booking_extra/screen/booker.dart';
import 'package:booking_extra/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  RouteTrip routeId;
  List<RouteTrip> listRoute = [];
  final dateController = TextEditingController();
  List<Voyage> listVoyage = [];
  DateTime selectedDate;

  _searchVoyage() async {
    try {
      MyApp.order.routeId = routeId.value;
      MyApp.order.routeText = routeId.text;
      MyApp.order.departDate = dateController.text;
      print('$host/BookTicket/SearchVoyage?RouteId=${routeId.value}&DepartDate=${dateController.text}');
      Client client = Client();
      var res =
          await client.get(Uri.parse('$host/BookTicket/SearchVoyage?RouteId=${routeId.value}&DepartDate=${dateController.text}'), headers: header);
      if (res.statusCode == 200) {
        if (res.contentLength != 0) {
          var resultJson = json.decode(res.body);
          for (var voyage in resultJson) {
            listVoyage.add(Voyage.fromJson(voyage));
          }
          setState(() {});
        } else {
          print(res);
        }
      } else {
        throw Exception('Server error');
      }
    } catch (ex) {
      print(ex);
    }
  }

  _getRoutes() async {
    try {
      print('$host/Route/GetRoutes');
      Client client = Client();
      var res = await client.get(Uri.parse('$host/Route/GetRoutes'), headers: header);
      if (res.statusCode == 200) {
        print(res.body);
        if (res.contentLength != 0) {
          var resultJson = json.decode(res.body);
          for (var route in resultJson) {
            listRoute.add(RouteTrip.fromJson(route));
          }
          setState(() {
            routeId = listRoute[0];
          });
        } else {
          print(res);
        }
      } else {
        throw Exception('Không lấy được tuyến');
      }
    } catch (ex) {
      print(ex);
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  Widget searchVoyageArea() {
    if (listVoyage.length > 0) {
      return ListView.separated(
        itemCount: listVoyage.length,
        itemBuilder: (BuildContext context, int index) {
          Voyage voyage = listVoyage[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Material(
              color: Colors.transparent,
              elevation: 30,
              child: InkWell(
                onTap: () {
                  MyApp.order.voyage = voyage;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookerPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 45,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xff134F89)),
                        ),
                        child: Icon(
                          Icons.directions_boat,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 5),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("Tàu ${voyage.boatNm}", style: TextStyle(color: Colors.white, fontSize: 12)),
                        SizedBox(height: 5),
                        Row(children: [
                          Text("Vé còn lại: ${voyage.noOfRemain}", style: TextStyle(color: Colors.white, fontSize: 10)),
                          SizedBox(width: 70),
                          Text("Giờ khởi hành: ${voyage.departTime.substring(0, 5)}", style: TextStyle(color: Colors.white, fontSize: 10)),
                        ])
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    } else
      return Center(child: Text("Chọn ngày khởi hành và tuyến"));
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dateController.text = selectedDate.toLocal().toString().split(' ')[0];
    _getRoutes();
  }

  @override
  Widget build(BuildContext context) {
    final searchBtn = Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff134F89),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {

            listVoyage.clear();
            _searchVoyage();
          },
          child: Text("Tìm chuyến", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ));

    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Container(
          /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("./assets/pqe-bg.png"),
              fit: BoxFit.contain,
              alignment: Alignment.topRight,
            ),
          ),*/
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SizedBox(
                height: 70.0,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/pqe-logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              Text('Tuyến:'),
              InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<RouteTrip>(
                    hint: Text("Chọn tuyến"),
                    value: routeId,
                    isDense: true,
                    isExpanded: true,
                    items: listRoute.map((RouteTrip route) => DropdownMenuItem(child: Text(route.text), value: route)).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        routeId = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text('Ngày khởi hành:'),
              TextField(
                controller: dateController,
                readOnly: true,
                obscureText: false,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: DateTime.now().toLocal().toString().split(' ')[0],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(
                height: 25.0,
              ),
              searchBtn,
              SizedBox(height: MediaQuery.of(context).size.height * 0.5, child: searchVoyageArea())
            ]),
          ),
        ),
      ),
    ));
  }
}

class BoatCard extends StatelessWidget {
  final Voyage voyage;

  BoatCard({Key key, this.voyage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        margin: EdgeInsets.all(10.0),
        width: constraint.maxWidth,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.red,
              blurRadius: 4,
              offset: Offset(4, 8), // Shadow position
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 30,
          child: InkWell(
            onTap: () {
              MyApp.order.voyage = this.voyage;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookerPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xff134F89)),
                    ),
                    child: Icon(
                      Icons.directions_boat,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Tàu ${voyage.boatNm}", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: 5),
                    Row(children: [
                      Text("Vé còn lại: ${voyage.noOfRemain}", style: TextStyle(color: Colors.white, fontSize: 10)),
                      SizedBox(width: 70),
                      Text("Giờ khởi hành: ${voyage.departTime.substring(0, 5)}", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ])
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
