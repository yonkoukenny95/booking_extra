import 'dart:convert';
import 'dart:developer';

import 'package:booking_extra/main.dart';
import 'package:booking_extra/model/Passenger.dart';
import 'package:booking_extra/model/TicketInformation.dart';
import 'package:booking_extra/screen/booker.dart';
import 'package:booking_extra/screen/screenshot.dart';
import 'package:booking_extra/util/constant.dart';
import 'package:booking_extra/util/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class TicketPage extends StatefulWidget {
  TicketPage({Key key, this.title, this.orderNo, this.publishedDate, this.listTickets}) : super(key: key);

  final String title;
  final String orderNo;
  final String publishedDate;
  final List<TicketInformation> listTickets;

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String orderNumber, boatNm, ticketID, price, discount;
  List<Passenger> listPassenger = new List<Passenger>();
  List<TicketInformation> listTickets = new List<TicketInformation>();
  final oCcy = new NumberFormat("#,##0", "en_US");

  @override
  initState() {
    super.initState();
    listTickets = widget.listTickets;
    //initValue();
  }

  initValue() async {
    await getTicketQR();
  }

  formatDate(input) {
    print(input);
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(input.replaceFirst("T", " ")); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
    return outputDate;
  }

  getTicketQR() async {
    try {
      print('$host/Order/GetBoardingPassByOrderNo?orderNo=${widget.orderNo}&username=sysadmin');
      Client client = Client();
      var res = await client.get(Uri.parse('$host/Order/GetBoardingPassByOrderNo?orderNo=${widget.orderNo}&username=sysadmin'), headers: header);
      if (res.statusCode == 200) {
        var resultJson = json.decode(res.body);
        listTickets.clear();
        for (var element in resultJson) {
          listTickets.add(TicketInformation.fromJson(element));
        }
        setState(() {});
      } else {
        throw Exception('Không lấy được danh sách loại khách');
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final printButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff134F89),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 1 / 2 - 25,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenShotPage(listTickets: listTickets)));
        },
        child: Text("In vé", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final rebookButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff134F89),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 1 / 2 - 25,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BookerPage()),
            (route) => false,
          );
        },
        child: Text("Đặt vé khác", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                SizedBox(
                  height: 70.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/pqe-logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                Text("Đặt vé thành công", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(oCcy.format(listTickets.fold(0, (value, element) => value + element.price.toInt())) + " VND",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(height: 5),
                Text(widget.publishedDate.substring(0, 19).replaceFirst("T", " "), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                SizedBox(height: 20),
                Container(
                  height: 160,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Color(0xff134F89)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Mã đơn hàng"), // <-- Wrapped in Expanded.,
                          Text(listTickets[0].orderNo) // <-- Wrapped in Expanded.
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Tuyến"), // <-- Wrapped in Expanded.,
                          Text(listTickets[0].fromPlace + " - " + listTickets[0].toPlace) // <-- Wrapped in Expanded.
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Ngày, giờ "), // <-- Wrapped in Expanded.,
                          Text(formatDate(listTickets[0].departDateTime))
                          // <--
                          // Wrapped in Expanded.
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Tàu"), // <-- Wrapped in Expanded.,
                          Text(listTickets[0].boatNm) // <-- Wrapped in Expanded.
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    itemCount: listTickets.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      TicketInformation ticket = listTickets[index];
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(color: Color(0xff134F89)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: QrImage(
                              version: 5,
                              backgroundColor: Colors.white,
                              data: ticket.qRCode,
                              size: 110.0,
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(ticket.passengerNm.toUpperCase(),
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                                  Text(ticket.idNo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                                  SizedBox(
                                    height: (ticket.passengerNm.length < 15) ? 30 : 20,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 5,
                                          child: Text('Ghế', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black))),
                                      Expanded(
                                          flex: 5,
                                          child: Text('Loại vé', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black))),


                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 5,
                                          child: Text(ticket.seatNm,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent))),
                                      Expanded(
                                          flex: 5,
                                          child: Text(ticket.ticketClass,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      );
                    }),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    printButton,
                    SizedBox(width: 10),
                    rebookButton,
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
