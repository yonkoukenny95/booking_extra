import 'dart:convert';
import 'dart:typed_data';

import 'package:booking_extra/model/TicketInformation.dart';
import 'package:booking_extra/util/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

class ScreenShotPage extends StatefulWidget {
  ScreenShotPage({Key key, this.listTickets}) : super(key: key);
  final List<TicketInformation> listTickets;

  @override
  _ScreenShotPage createState() => _ScreenShotPage();
}

class _ScreenShotPage extends State<ScreenShotPage> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
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

  Widget listTicket(listTickets) {
    return ListView.builder(
        itemCount: listTickets.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          TicketInformation ticket = listTickets[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            margin: EdgeInsets.only(bottom: 0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 15),
                  SizedBox(
                    height: 120.0,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/pqe-logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 15),
                  QrImage(
                    version: 5,
                    backgroundColor: Colors.white,
                    data: ticket.qRCode,
                    size: 280.0,
                    padding: EdgeInsets.all(5),
                  ),
                  SizedBox(height: 5),
                  Text(ticket.orderNo, style: TextStyle(fontSize: 16, color: Colors.black)),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(flex: 5, child: Text('Tàu/ Ship:', style: TextStyle(fontSize: 16, color: Colors.black))),
                                Expanded(
                                    flex: 5,
                                    child:
                                        Text(ticket.boatNm, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(flex: 5, child: Text('Ngày giờ / Date time:', style: TextStyle(fontSize: 16, color: Colors.black))),
                                Expanded(
                                    flex: 5,
                                    child: Text(formatDate(ticket.departDateTime),
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(flex: 5, child: Text('Tuyến / Route:', style: TextStyle(fontSize: 16, color: Colors.black))),
                                Expanded(
                                    flex: 5,
                                    child:
                                        Text(listTickets[0].fromPlace.toUpperCase() + " - " + listTickets[0].toPlace.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(flex: 5, child: Text('Họ tên / Name:', style: TextStyle(fontSize: 16, color: Colors.black))),
                                Expanded(
                                    flex: 5,
                                    child: Text(ticket.passengerNm.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Expanded(flex: 5, child: Text('Ghế / Seat:', style: TextStyle(fontSize: 16, color: Colors.black))),
                                Expanded(
                                    flex: 5, child: Text(ticket.seatNm.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 20),
                  //Text('Vui lòng có mặt 15 phút trước giờ tàu chạy tại '+ticket.harbor, style: TextStyle(fontSize: 15)),
                  //Text('Please be presented 30 minutes prior to the depart time at '+ticket.harbor, style: TextStyle(fontSize: 15)),
                ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Screenshot"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.download,
                color: Colors.white,
              ),
              onPressed: () {
                screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
                  _saved(capturedImage);
                }).catchError((onError) {
                  print(onError);
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.print,
                color: Colors.white,
              ),
              onPressed: () {
                screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
                  _print(capturedImage);
                }).catchError((onError) {
                  print(onError);
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Screenshot(
                    controller: screenshotController,
                    child: listTicket(widget.listTickets),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _print(Uint8List capturedImage) async {
    final imgData = base64.encode(capturedImage);
    SunmiPrinter.image(imgData);
    SunmiPrinter.emptyLines(3);
  }

  Future<dynamic> showCapturedWidget(BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: capturedImage != null ? Image.memory(capturedImage) : Container()),
      ),
    );
  }

  void _saved(Uint8List capturedImage) async {
    final result = await ImageGallerySaver.saveImage(capturedImage);
    print("File Saved to Gallery");
  }
}
