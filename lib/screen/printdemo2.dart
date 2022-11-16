//import 'dart:convert';
//import 'dart:io';
//import 'dart:typed_data';
//
//import 'package:booking_extra/util/qrGenerate.dart';
//import 'package:flutter/material.dart';
//import 'package:sunmi_printer/sunmi_printer.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:screenshot/screenshot.dart';
//
//// import 'package:webview_flutter/webview_flutter.dart';
//// import 'package:image_gallery_saver/image_gallery_saver.dart';
//
//class PrintDemo2Page extends StatefulWidget {
//  @override
//  _PrintDemo2Page createState() => _PrintDemo2Page();
//}
//
//class _PrintDemo2Page extends State<PrintDemo2Page> {
//  //Create an instance of ScreenshotController
//  ScreenshotController screenshotController = ScreenshotController();
//  String _printerStatus = '';
//  @override
//  void initState() {
//    super.initState();
//    _bindingPrinter().then( (binded) async => {
//      _getPrinterStatus(),
//      _getPrinterMode(),
//    });
//  }
//
//  Future<bool> _bindingPrinter() async {
//    final bool result = await SunmiPrinter.bindingPrinter();
//    return result;
//  }
//
//  Future<void> _getPrinterStatus() async {
//    // Possible printer status
//    //  static Map _printerStatus = {
//    //   'ERROR': 'Something went wrong.',
//    //   'NORMAL': 'Works normally',
//    //   'ABNORMAL_COMMUNICATION': 'Abnormal communication',
//    //   'OUT_OF_PAPER': 'Out of paper',
//    //   'PREPARING': 'Preparing printer',
//    //   'OVERHEATED': 'Overheated',
//    //   'OPEN_THE_LID': 'Open the lid',
//    //   'PAPER_CUTTER_ABNORMAL': 'The paper cutter is abnormal',
//    //   'PAPER_CUTTER_RECOVERED': 'The paper cutter has been recovered',
//    //   'NO_BLACK_MARK': 'No black mark had been detected',
//    //   'NO_PRINTER_DETECTED': 'No printer had been detected',
//    //   'FAILED_TO_UPGRADE_FIRMWARE': 'Failed to upgrade firmware',
//    //   'EXCEPTION': 'Unknown Error code',
//    // };
//    final String result = await SunmiPrinter.getPrinterStatus();
//    setState(() {
//      _printerStatus = result;
//    });
//  }
//
//  Future<void> _getPrinterMode() async {
//    // printer mode = [  NORMAL_MODE , BLACK_LABEL_MODE, LABEL_MODE ]
//    final String result = await SunmiPrinter.getPrinterMode();
//    print('printer mode: $result');
//  }
//
//  // Only support Sunmi V2 Pro Label Version. P/s: V2 Pro Standard not supported for label printing
//  Future<void> _printLabel(Uint8List img ) async {
//    if (_printerStatus == 'Works normally') {
//      print('printing..!');
//      try {
//        // start point of label print
//        await SunmiPrinter.startLabelPrint();
//        // alignment , 0 = align left, 1 =  center, 2 = align right.
//        await SunmiPrinter.setAlignment(0);
//        await SunmiPrinter.lineWrap(1);
//        await SunmiPrinter.printText('demo');
//        await SunmiPrinter.printImage(img);
//        await SunmiPrinter.lineWrap(1); // must have for label printing before exitLabelPrint()
//        await SunmiPrinter.exitLabelPrint();
//        // end point of label print
//      } catch(e) {
//        print('error');
//      }
//
//    }
//  }
//
//  Future<void> _printTest(Uint8List img ) async {
//      print('printing..!');
//      try {
//        // start point of label print
//        await SunmiPrinter.startLabelPrint();
//        // alignment , 0 = align left, 1 =  center, 2 = align right.
//        await SunmiPrinter.setAlignment(0);
//        await SunmiPrinter.lineWrap(1);
//        await SunmiPrinter.printText('demo');
//        await SunmiPrinter.printImage(img);
//        await SunmiPrinter.lineWrap(1); // must have for label printing before exitLabelPrint()
//        await SunmiPrinter.exitLabelPrint();
//        // end point of label print
//      } catch(e) {
//        print('error');
//      }
//
//  }
//
//  Future<void> _printTransaction(Uint8List img ) async {
//    if (_printerStatus == 'Works normally') {
//      print('printing..!');
//      try {
//        await SunmiPrinter.startTransactionPrint();
//        await SunmiPrinter.setAlignment(0);
//        await SunmiPrinter.printText('demo');
//        await SunmiPrinter.printImage(img);
//        await SunmiPrinter.submitTransactionPrint();
//        await SunmiPrinter.exitTransactionPrint();
//      } catch(e) {
//        print('error');
//      }
//
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text("Screenshot"),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Screenshot(
//              controller: screenshotController,
//              child: Container(
//                padding: EdgeInsets.all(10),
//                margin: EdgeInsets.only(bottom: 10),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                  border: Border.all(color: Color(0xff134F89)),
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.grey,
//                      spreadRadius: 1,
//                      blurRadius: 2,
//                      offset: Offset(0, 1), // changes position of shadow
//                    ),
//                  ],
//                ),
//                child: Column(
//                    mainAxisSize: MainAxisSize.max,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      SizedBox(height: 15),
//                      SizedBox(
//                        height: 70.0,
//                        width: MediaQuery.of(context).size.width,
//                        child: Image.asset(
//                          "assets/pqe-logo.png",
//                          fit: BoxFit.contain,
//                        ),
//                      ),
//                      SizedBox(height: 15),
//                      QrImage(
//                        version: 6,
//                        backgroundColor: Colors.white,
//                        data: 'HT-PQ*16/10/2021 06:00*TRAN VAN AN*E01*987654321',
//                        size: 150.0,
//                        padding: EdgeInsets.all(5),
//                      ),
//                      Text('20211016HT-PQ0007', style: TextStyle(fontSize: 14, color: Colors.black)),
//
//                      Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//                        Expanded(
//                          flex: 1,
//                          child: Padding(
//                            padding: EdgeInsets.only(left: 20, top: 20),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              children: <Widget>[
//                                Row(
//                                  children: <Widget>[
//                                    Expanded(
//                                        flex: 4,
//                                        child: Text('Tàu:', style: TextStyle(fontSize: 14, color: Colors.black))),
//                                    Expanded(
//                                        flex: 6,
//                                        child: Text('PHÚ QUỐC EXPRESS 5', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black))),
//                                  ],
//                                ),
//                                SizedBox(height: 5),
//
//                                Row(
//                                  children: <Widget>[
//                                    Expanded(
//                                        flex: 4,
//                                        child: Text('Ngày giờ / Date time:', style: TextStyle(fontSize: 14, color: Colors.black))),
//                                    Expanded(
//                                        flex: 6,
//                                        child: Text('16/10/2021 06:00 AM', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black))),
//                                  ],
//                                ),
//                                SizedBox(height: 5),
//                                Row(
//                                  children: <Widget>[
//                                    Expanded(
//                                        flex: 4,
//                                        child: Text('Tuyến / Route:', style: TextStyle(fontSize: 14, color: Colors.black))),
//                                    Expanded(
//                                        flex: 6,
//                                        child: Text('HÀ TIÊN - PHÚ QUỐC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black))),
//                                  ],
//                                ),
//                                SizedBox(height: 5),
//                                Row(
//                                  children: <Widget>[
//                                    Expanded(
//                                        flex: 4,
//                                        child: Text('Họ tên / Name:', style: TextStyle(fontSize: 14, color: Colors.black))),
//                                    Expanded(
//                                        flex: 6,
//                                        child: Text('TRẦN VĂN AN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black))),
//                                  ],
//                                ),
//                                SizedBox(height: 5),
//                                Row(
//                                  children: <Widget>[
//                                    Expanded(
//                                        flex: 4,
//                                        child: Text('Ghế / Seat:', style: TextStyle(fontSize: 14, color: Colors.black))),
//                                    Expanded(
//                                        flex: 6,
//                                        child: Text('A01', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black))),
//                                  ],
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ]),
//                      SizedBox(height: 15),
//                      Text('Vui lòng có mặt 15 phút trước giờ tàu chạy tại CẢNG HÀ TIÊN', style: TextStyle(fontSize: 14)),
//                      Text('Please be presented 30 minutes prior to the depart time at HA TIEN PORT', style: TextStyle(fontSize: 14)),
//                    ]),
//              ),
//            ),
//            SizedBox(
//              height: 25,
//            ),
//            ElevatedButton(
//              child: Text(
//                'Print Transaction',
//              ),
//              onPressed: () {
//                screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
//                  _printTransaction(capturedImage);
//                }).catchError((onError) {
//                  print(onError);
//                });
//              },
//            ),
//            SizedBox(
//              height: 25,
//            ),
//            ElevatedButton(
//              child: Text(
//                'Print Transaction',
//              ),
//              onPressed: () {
//                screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
//                  _printLabel(capturedImage);
//                }).catchError((onError) {
//                  print(onError);
//                });
//              },
//            ),
//            SizedBox(
//              height: 25,
//            ),
//            ElevatedButton(
//              child: Text(
//                'Print without checking',
//              ),
//              onPressed: () {
//                screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
//                  _printTest(capturedImage);
//                }).catchError((onError) {
//                  print(onError);
//                });
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
