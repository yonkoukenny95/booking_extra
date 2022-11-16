import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:booking_extra/main.dart';
import 'package:booking_extra/model/Route.dart';
import 'package:booking_extra/model/Voyage.dart';
import 'package:booking_extra/screen/booker.dart';
import 'package:booking_extra/util/constant.dart';
import 'package:booking_extra/util/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:booking_extra/util/dialog.dart';
import 'package:screenshot/screenshot.dart';

class CargoPage extends StatefulWidget {
  CargoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CargoPageState createState() => _CargoPageState();
}

class _CargoPageState extends State<CargoPage> {
  String dataCode = "";
  String id = "";
  int voyageId = MyApp.order.voyage.scheduleId;
  int routeId = MyApp.order.routeId;
  int boatId=MyApp.order.voyage.boatId;
  String departTime=MyApp.order.voyage.departTime;
  int amount = 0;
  int isVehicle = 0;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  NumberFormat formatterID = new NumberFormat("000");
  NumberFormat formatterVoyageID = new NumberFormat("0000");
  final oCcy = new NumberFormat("#,##0", "en_US");
  var noteFieldController = TextEditingController();
  var focusNode = FocusNode();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }
  _getCargoID() async {
    try {
      Client client = Client();
      var res = await client.get(Uri.parse('$host/Cargo/GetLastNumberOrderNo?isVehicle=${isVehicle == 0 ? false : true}&routeId=$routeId&BoatId=$boatId&DepartTime=$departTime'), headers: header);
      if (res.statusCode == 200) {
        print(res.body);
        if (res.contentLength != 0) {
          var resultJson = json.decode(res.body);
          id=resultJson['Data'].toString().substring(1,4);
        } else {
          print(res);
        }
      } else {
        throw Exception('Không lấy được ID.');
      }
    } catch (ex) {
      print(ex);
    }
  }
  createCargoExtra() async {
    if(noteFieldController.text.isEmpty||noteFieldController.text.length==0||noteFieldController.text==""){
      Dialogs.showMessage(context, "Thông báo", "Nhập thông tin hàng hoặc biển số xe.");
    }else{
      List package = [];
      package.add({
        "Name": dataCode.toString(),
        "Amount": amount,
      });
      var map = new Map<String, dynamic>();
      map["RouteId"] = MyApp.order.routeId;
      map["TotalAmt"] = amount;
      map["Note"]= noteFieldController.text;
      map["CreatedAtId"]= MyApp.user.officeId;
      map["CreatedById"]= MyApp.user.uerNm;
      map["CargoDetail"]= package;
      //param for vehicle
      map['DepartDate']=MyApp.order.voyage.departDate.substring(0,10);
      map['DepartTime']=MyApp.order.voyage.departTime;
      map['BoatId']=MyApp.order.voyage.boatId;


      print(map);
      try {
        Dialogs.showLoadingDialog(context, _keyLoader);
        Client client = Client();
        String url = isVehicle==0?"/Cargo/CreateCargo":"/Vehicle/CreateVehicleOrder";
        var res =
        await client.post(Uri.parse('${host+url}'), body: jsonEncode(map), headers: header);

        print("Cargo Url: " + res.request.url.toString());

        if (res.statusCode == 200) {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          print(res.body);
          var jsonResult = json.decode(res.body);
          if(jsonResult['Message']=="duplicate"){
            Dialogs.showMessage(context, "Thông báo", "Biển số xe bị trùng.");
            FocusScope.of(context).requestFocus(focusNode);
          }else if(jsonResult['Message']=="success"){

            await screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
              _print(capturedImage);
            }).catchError((onError) {
              print(onError);
            });

            Dialogs.showMessageAuto(context, "Thông báo", "Tạo thành công.");

            noteFieldController.clear();
            dataCode="";

            setState(() {});
          }
        } else {
          print(res.headers);
          print(res.statusCode);
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          throw Exception('Server error');
        }
      } catch (ex) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Dialogs.showMessage(context, "Thông báo", "Xử lý thất bại.");
        print(ex);
      }
    }

  }

  formatDate(input) {
    print(input);
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(input.replaceFirst("T00:00:00", " ")); // <-- dd/MM 24H format
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
    return outputDate;
  }

  generateBarCodeData(value) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(MyApp.order.voyage.departDate);
    var outputFormat = DateFormat('yyyyMMdd');
    var outputDate = outputFormat.format(inputDate);
    await _getCargoID();
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
    dataCode = (isVehicle==0?"H":"X") + outputDate.substring(2,outputDate.length) + value + id;
    setState(() {});
  }

  void _print(Uint8List capturedImage) async {
    //final imgData = base64.encode(MemoryImage(capturedImage, scale: 1.5).bytes);
    final imgData = base64.encode(capturedImage);
    SunmiPrinter.image(imgData);
    SunmiPrinter.emptyLines(3);
  }

  @override
  Widget build(BuildContext context) {
    //variable for each box
    final double boxHeight  = MediaQuery.of(context).size.width*0.17;
    final double boxFontSize = 20;

    final noteField = TextField(
      minLines: 2,
      maxLines: 2,
      keyboardType: TextInputType.multiline,
      controller: noteFieldController,
      focusNode: focusNode,
      obscureText: false,
      decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Ghi chú ",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final printButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff134F89),
      child: MaterialButton(
        minWidth: 200,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          //_saveOrder();
          createCargoExtra();
        },
        child: Text("Gửi thông tin", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Vận chuyển hàng hóa'),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                // phieu hang
                Text("Nhập biển số xe/Người nhận - số điện thoại", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                noteField,
                Container(height: 10),
                Text("Chọn mệnh giá để in (Hàng - Xe)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.lightBlueAccent,
                      // color: Colors.blue.shade400,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 20k.');
                          amount = 20000;
                          isVehicle=0;
                          generateBarCodeData("02");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '20K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.redAccent,
                      child: InkWell(
                        splashColor: Colors.red.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 30k.');
                          amount = 30000;
                          isVehicle=0;
                          generateBarCodeData("03");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '30K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.blue.shade600,
                      child: InkWell(
                        splashColor: Colors.green.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 40k.');
                          amount = 40000;
                          isVehicle=0;
                          generateBarCodeData("04");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '40K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.orange,
                      child: InkWell(
                        splashColor: Colors.orange.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 50k.');
                          amount = 50000;
                          isVehicle=0;
                          generateBarCodeData("05");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '50K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                ]),
                //phieu xe
                Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.orangeAccent.shade100,
                      child: InkWell(
                        splashColor: Colors.orange.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 100k.');
                          amount = 100000;
                          isVehicle=1;
                          generateBarCodeData("10");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '100K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.lightGreenAccent.shade100,
                      child: InkWell(
                        splashColor: Colors.green.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 110k.');
                          amount = 110000;
                          isVehicle=1;
                          generateBarCodeData("11");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '110K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.lightBlueAccent.shade100,
                      child: InkWell(
                        splashColor: Colors.red.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 150k.');
                          amount = 150000;
                          isVehicle=1;
                          generateBarCodeData("15");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '150K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.pinkAccent.shade100,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 250k.');
                          amount = 250000;
                          isVehicle=1;
                          generateBarCodeData("25");
                          FocusScope.of(context).unfocus();
                        },
                        child: SizedBox(
                            height: boxHeight,
                            child: Center(
                              child: Text(
                                '250K',
                                style: TextStyle(fontSize: boxFontSize, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                ]),
                (dataCode == "")
                    ? SizedBox()
                    : Column(children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blueAccent)),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Screenshot(
                            controller: screenshotController,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60.0,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset(
                                      "assets/pqe-bg.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(vertical: 8,horizontal:3 ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(MyApp.order.routeText.toString().toUpperCase(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                              Text(MyApp.order.voyage.boatNm, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                              Text(formatDate(MyApp.order.voyage.departDate + MyApp.order.voyage.departTime),
                                                  style: TextStyle(height: 1.5, fontSize: 20, fontWeight: FontWeight.bold)),
                                              Text(oCcy.format(amount) + " VNĐ", style: TextStyle(height: 2,fontSize: 20, fontWeight: FontWeight.bold)),
                                              Text("Ghi chú: " + noteFieldController.text, style: TextStyle(height: 2, fontSize: 20, fontStyle: FontStyle.italic)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Center(
                                      child: BarCodeImage(
                                        params: Code128BarCodeParams(
                                          dataCode,
                                          lineWidth: 1.8, // width for a single black/white bar (default: 2.0)
                                          barHeight: 60.0, // height for the entire widget (default: 100.0)
                                          withText: true, // Render with text label or not (default: false)
                                        ),
                                        onError: (error) {
                                          // Error handler
                                          print('error = $error');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(child: printButton)
                      ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
