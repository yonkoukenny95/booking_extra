import 'dart:async';
import 'dart:convert';

import 'package:booking_extra/main.dart';
import 'package:booking_extra/model/Route.dart';
import 'package:booking_extra/model/Voyage.dart';
import 'package:booking_extra/screen/booker.dart';
import 'package:booking_extra/util/constant.dart';
import 'package:booking_extra/util/qrGenerate.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:booking_extra/util/dialog.dart';

class CargoPage extends StatefulWidget {
  CargoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CargoPageState createState() => _CargoPageState();
}

class _CargoPageState extends State<CargoPage> {
  String dataCode = "";
  double id = 123;
  int voyageId = MyApp.order.voyage.scheduleId;
  int amount = 0;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  NumberFormat formatterID = new NumberFormat("000");
  NumberFormat formatterVoyageID = new NumberFormat("0000");
  final oCcy = new NumberFormat("#,##0", "en_US");
  var noteFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  createCargoExtra() async {
    var map = new Map<String, dynamic>();
    map["VoyageId"] = MyApp.order.voyage.voyageId;
    map["Code"] = dataCode;
    map["Amount"] = amount;
    map["CreatedBy"] = MyApp.userNm;
    print(map);
    try {
      Dialogs.showLoadingDialog(context, _keyLoader);
      Client client = Client();
      var res =
          await client.post(Uri.parse('http://192.168.1.29/BookingOverTime/Api/CargoExtra/CreateCargoExtra'), body: jsonEncode(map), headers: header);
      if (res.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        print(res.body);
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

  formatDate(input) {
    print(input);
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(input.replaceFirst("T00:00:00", " ")); // <-- dd/MM 24H format
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
    return outputDate;
  }

  generateBarCodeData(value) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(MyApp.order.voyage.departDate);
    var outputFormat = DateFormat('yyyyMMdd');
    var outputDate = outputFormat.format(inputDate);
    dataCode =  outputDate + value.toString() + formatterID.format(id).toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final noteField = TextField(
      minLines: 5,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      controller: noteFieldController,
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
        child: Text("In mã vạch", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Text("Chọn loại phiếu để in", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.orange,
                      child: InkWell(
                        splashColor: Colors.orange.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 50k.');
                          amount = 50000;
                          generateBarCodeData(5);
                        },
                        child: const SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                '50.000VNĐ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.green,
                      child: InkWell(
                        splashColor: Colors.green.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 40k.');
                          amount = 40000;
                          generateBarCodeData(4);
                        },
                        child: const SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                '40.000VNĐ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.red,
                      child: InkWell(
                        splashColor: Colors.red.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 30k.');
                          amount = 30000;
                          generateBarCodeData(3);
                        },
                        child: const SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                '30.000VNĐ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.blue,
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(50),
                        onTap: () {
                          print('Chọn phiếu 20k.');
                          amount = 20000;
                          generateBarCodeData(2);
                        },
                        child: const SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                '20.000VNĐ',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                ]),
                Text("Ghi chú (nếu có)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                noteField,
                (dataCode == "")
                    ? SizedBox()
                    : Column(children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blueAccent)),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80.0,
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
                                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
                                      padding: EdgeInsets.all(10),
                                      height: 150,
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(vertical: 15,horizontal:35 ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(MyApp.order.voyage.boatNm, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                          Text(formatDate(MyApp.order.voyage.departDate + MyApp.order.voyage.departTime),
                                              style: TextStyle(height: 1.5, fontSize: 14, fontWeight: FontWeight.bold)),
                                          Text(oCcy.format(amount) + " VNĐ", style: TextStyle(height: 2,fontSize: 18, fontWeight: FontWeight.bold)),
                                          Text("Ghi chú: " + noteFieldController.text, style: TextStyle(height: 2, fontSize: 14, fontStyle: FontStyle.italic)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Center(
                                  child: BarCodeImage(
                                    params: Code128BarCodeParams(
                                      dataCode,
                                      lineWidth: 2.0, // width for a single black/white bar (default: 2.0)
                                      barHeight: 80.0, // height for the entire widget (default: 100.0)
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
