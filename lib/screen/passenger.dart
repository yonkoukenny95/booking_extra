import 'dart:convert';
import 'dart:developer';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:booking_extra/model/Nation.dart';
import 'package:booking_extra/model/Passenger.dart';
import 'package:booking_extra/model/Seat.dart';
import 'package:booking_extra/model/TicketInformation.dart';
import 'package:booking_extra/model/TicketPrice.dart';
import 'package:booking_extra/model/TicketType.dart';
import 'package:booking_extra/screen/nation.dart';
import 'package:booking_extra/screen/search.dart';
import 'package:booking_extra/screen/ticket.dart';
import 'package:booking_extra/util/constant.dart';
import 'package:booking_extra/util/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/date_formatter.dart';

import '../main.dart';

class PassengerPage extends StatefulWidget {
  PassengerPage({Key key, this.title, this.isPassenger}) : super(key: key);

  final String title;
  final bool isPassenger;

  @override
  _PassengerPageState createState() => _PassengerPageState();
}

class _PassengerPageState extends State<PassengerPage> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var listWidgetPassengers = new List<Widget>();
  List<TicketType> listTicketTypes = new List<TicketType>();
  List<Seat> listSeatEmpty = new List<Seat>();
  List<TicketPrice> listTicketPrices = new List<TicketPrice>();
  TicketType _defaultType;
  final formKeyList = List<GlobalKey<FormState>>();
  var idTECs = <TextEditingController>[];
  var nameTECs = <TextEditingController>[];
  var pobTECs = <TextEditingController>[];
  var dobTECs = <TextEditingController>[];
  var phoneTECs = <TextEditingController>[];
  var nationalityTECs = <TextEditingController>[];
  var ticketTypeTECs = <TextEditingController>[];
  var listTypes = <TicketType>[];
  var listNationId = <Nation>[];
  var listSeats = <Seat>[];
  var listPrices = <TicketPrice>[];
  var emailTECs = <TextEditingController>[];

  initValue() async {
    await _getSeatEmpty();
    await _getTicketTypes();
    await _getTicketPrices();
    setState(() {
      listWidgetPassengers.clear();
      for (int i = 0; i < MyApp.order.numberPassengers; i++) {
        listPrices
            .add(listTicketPrices.firstWhere((item) => item.ticketClass == listSeats[i].ticketClass && item.ticketTypeId == _defaultType.typeID));
        listWidgetPassengers.add(createPassengerForm(i));
      }
    });
  }

  _getTicketTypes() async {
    try {
      print('$host/TicketType/GetTicketTypes');
      Client client = Client();
      var res = await client.get(Uri.parse('$host/TicketType/GetTicketTypes'), headers: header);
      if (res.statusCode == 200) {
        if (res.contentLength != 0) {
          var resultJson = json.decode(res.body);
          for (var element in resultJson) {
            listTicketTypes.add(TicketType.fromJson(element));
          }
          print(listTicketTypes.length);
          _defaultType = listTicketTypes[0];
        } else {
          print(res);
        }
      } else {
        throw Exception('Kh??ng l???y ???????c danh s??ch lo???i kh??ch');
      }
    } catch (ex) {
      print(ex);
    }
  }

  _getTicketPrices() async {
    try {
      print('$host/TicketPrice/GetTicketPriceByRouteId?routeId=${MyApp.order.routeId}&boatTypeId=${MyApp.order.voyage.boatTypeId}');
      Client client = Client();
      var res = await client.get(
          Uri.parse('$host/TicketPrice/GetTicketPriceByRouteId?routeId=${MyApp.order.routeId}&boatTypeId=${MyApp.order.voyage.boatTypeId}'),
          headers: header);
      if (res.statusCode == 200) {
        if (res.contentLength != 0) {
          var resultJson = json.decode(res.body);
          for (var element in resultJson) {
            listTicketPrices.add(TicketPrice.fromJson(element));
          }
          print(listTicketPrices.length);
        } else {
          print(res);
        }
      } else {
        throw Exception('Kh??ng l???y ???????c danh s??ch gi?? v??');
      }
    } catch (ex) {
      print(ex);
    }
  }

  _getSeatEmpty() async {
    try {
      print('$host/Voyage/GetSeatsEmpty?VoyageId=${MyApp.order.voyage.voyageId}&DepartDate=${MyApp.order.voyage.departDate}');
      Client client = Client();
      var res = await client.get(
          Uri.parse('$urlBookingTicket/Voyage/GetSeatsEmpty?VoyageId=${MyApp.order.voyage.voyageId}&DepartDate=${MyApp.order.voyage.departDate}'),
          headers: header);
      if (res.statusCode == 200) {
        if (res.contentLength != 0) {
          var resultJson = json.decode(res.body);
          for (var element in resultJson) {
            listSeatEmpty.add(Seat.fromJson(element));
          }
          for (int i = 0; i < MyApp.order.numberPassengers; i++) {
            listSeats.add(listSeatEmpty[i]);
          }
        } else {
          print(res.body);
        }
      } else {
        throw Exception('Kh??ng l???y ???????c danh s??ch gh??? ng???i');
      }
    } catch (ex) {
      print(ex);
    }
  }

  createOrder() async {
    bool validate = true;
    for (int i = 0; i < formKeyList.length; i++) {
      var check = formKeyList[i].currentState.validate();
      if (!check) {
        validate = false;
      }
    }
    if (validate) {
      Dialogs.showLoadingDialog(context, _keyLoader);
      try {
        List passengers = [];

        for (int i = 0; i < MyApp.order.numberPassengers; i++) {
          MyApp.listPassenger.add(new Passenger(
            idTECs[i].text,
            nameTECs[i].text,
            pobTECs[i].text,
            dobTECs[i].text,
            phoneTECs[i].text,
            listNationId[i],
            emailTECs[i].text,
            listSeats[i],
          ));

          passengers.add({
            "TicketPriceId": listPrices[i].ticketPriceId.toString(),
            "DiscountAmount": "0",
            "PositionId": listSeats[i].positionID.toString(),
            "PassId": "1",
            "IdNo": idTECs[i].text,
            "FullNm": nameTECs[i].text,
            "YOB": dobTECs[i].text,
            "POB": pobTECs[i].text,
            "NationId": listNationId[i].id,
            "PhoneNo": phoneTECs[i].text,
            "Email": emailTECs[i].text,
            "Price": listPrices[i].priceWithVAT.toInt().toString(),
            "RefundInvoice": "false",
            "CreatedById": MyApp.userNm,
            "CreatedDate": MyApp.order.departDate,
            "IsCancelled": "false",
            "CancelledById": null,
            "CancelledDate": null
          });
        }

        print('$host/Order/CreateOrder');
        var map = new Map<String, dynamic>();
        map = {
          "VoyageId": MyApp.order.voyage.voyageId.toString(),
          "ScheduleId": MyApp.order.voyage.scheduleId.toString(),
          "RouteId": MyApp.order.routeId.toString(),
          "AgentId": null,
          "CustomerId": null,
          "Booker": MyApp.order.bookerName,
          "ContactNo": MyApp.order.bookerPhone,
          "Email": MyApp.order.invoiceEmail,
          "TotalAmount": listPrices.fold(0, (value, element) => value + element.priceWithVAT.toInt()).toString(),
          "PaidAmount": listPrices.fold(0, (value, element) => value + element.priceWithVAT.toInt()).toString(),
          "IsComplete": "true",
          "TotalNumber": MyApp.order.numberPassengers.toString(),
          "PublishedNumber": MyApp.order.numberPassengers.toString(),
          "Buyer": MyApp.order.invoiceBookerName,
          "Taxcode": MyApp.order.invoiceMST.toString(),
          "CompNm": MyApp.order.invoiceCompanyName,
          "CompAddress": MyApp.order.invoiceAddress,
          "CreatedDate": MyApp.order.departDate,
          "CreatedById": MyApp.userNm,
          "PublishedById": MyApp.userNm,
          "PublishedDate": MyApp.order.departDate,
          "PublishedAtId": "2",
          "CusTypeId": "2",
          "CurrentUserNm": MyApp.userNm,
          "CurrentOfficeId": "2",
          "CurrentAgentId": null,
          "LinkOrderNo": "",
        };
        map['TicketOrder'] = passengers;
        map['CashPayment'] = {
          "Amount": listPrices.fold(0, (value, element) => value + element.priceWithVAT.toInt()).toString(),
          "PaidById": MyApp.userNm,
          "PaidDate": MyApp.order.departDate,
          "PaidAtId": "2",
          "PayTypeId": "2",
          "Note": "",
          "IsTransfer": false,
          "BankAccountId": null,
          "TransactionId": null,
          "IsPaid": false
        };

        Client client = Client();
        var res = await client.post(Uri.parse('$host/Order/CreateOrder'), headers: header, body: jsonEncode(map));
        if (res.statusCode == 200) {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          var resultJson = json.decode(res.body);
          log(res.body);
          print(resultJson['Status']);
          if (!resultJson['Status'])
            Dialogs.showMessage(context, "Th???t b???i", resultJson['Message'].toString());
          else getTicketQR(resultJson['Data']['OrderNo'], resultJson['Data']['PublishedDate']);
        } else {
          throw Exception('Kh??ng t???o ???????c ????n h??ng');
        }
      } catch (ex) {
        print(ex);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Dialogs.showMessage(context, "Th???t b???i", "Ki???m tra t??nh tr???ng k???t n???i internet.");
      }
    }
  }

  getTicketQR(orderNo, publishedDate) async {
    try {
      List<TicketInformation> listTickets = new List<TicketInformation>();
      print('$host/Order/GetBoardingPassByOrderNo?orderNo=${orderNo}&username=sysadmin');
      Client client = Client();
      var res = await client.get(Uri.parse('$host/Order/GetBoardingPassByOrderNo?orderNo=${orderNo}&username=sysadmin'), headers: header);
      if (res.statusCode == 200) {
        var resultJson = json.decode(res.body);
        listTickets.clear();
        for (var element in resultJson) {
          listTickets.add(TicketInformation.fromJson(element));
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TicketPage(
                    orderNo: orderNo,
                    publishedDate : publishedDate,
                    listTickets: listTickets,
                )));
      } else {
        throw Exception('Kh??ng l???y ???????c danh s??ch lo???i kh??ch');
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  void initState() {
    super.initState();
    initValue();
  }

  Widget createPassengerForm(int index) {
    var formKey = GlobalKey<FormState>();
    var idController = TextEditingController();
    var nameController = TextEditingController();
    var pobController = TextEditingController();
    var dobController = TextEditingController();
    var phoneController = TextEditingController();
    var nationalityController = TextEditingController();
    var emailController = TextEditingController();
    var ticketTypeController = TextEditingController();
    TicketType ticketTypeChosen = _defaultType;

    formKeyList.add(formKey);
    idTECs.add(idController);
    nameTECs.add(nameController);
    pobTECs.add(pobController);
    dobTECs.add(dobController);
    phoneTECs.add(phoneController);
    emailTECs.add(emailController);
    nationalityTECs.add(nationalityController);

    ticketTypeController.text = "V?? ng?????i l???n";
    ticketTypeTECs.add(ticketTypeController);
    listTypes.add(ticketTypeChosen);

    nationalityController.text = "Vi???t Nam";
    listNationId.add(new Nation(1, 'Vi???t Nam'));
    String messageQR = "Vui l??ng scan m?? QR c???a h??nh kh??ch!";
    String resultQR = "";

    final oCcy = new NumberFormat("#,##0", "en_US");

    Future _scanQR() async {
      try {
        String qrResult = await BarcodeScanner.scan();
        setState(() async {
          resultQR = qrResult;
          phoneController.text = qrResult;
          messageQR = "";
        });
      } on PlatformException catch (ex) {
        if (ex.code == BarcodeScanner.CameraAccessDenied) {
          setState(() {
            messageQR = "Ch??a c???p quy???n truy c???p camera";
          });
        } else {
          setState(() {
            messageQR = "L???i b???t ng??? $ex";
          });
        }
      } on FormatException {
        setState(() {
          messageQR = "B???n ch??a scan m?? QR";
        });
      } catch (ex) {
        setState(() {
          messageQR = "L???i kh??ng x??c ?????nh $ex";
        });
      }
    }

    final nameField = TextFormField(
      controller: nameController,
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (index == 0 && nameController.text != "") return null;
          return "Nh???p t??n h??nh kh??ch";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "T??n h??nh kh??ch",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
      ),
    );
    final idNoField = TextFormField(
      controller: idController,
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nh???p CMND/CCCD/PASSPORT/TE (N???u l?? tr??? em)";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "S??? CMND/CCCD/PASSPORT/TE",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
      ),
    );

    final dobField = TextFormField(
        controller: dobController,
        obscureText: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Nh???p ng??y sinh h??nh kh??ch";
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Ng??y sinh",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade500),
            )),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter(RegExp(r'\d+|-|/')), DateInputFormatter()],
        onEditingComplete: () {
          print(dobController.text);
          if (DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(dobController.text)).toString().compareTo(dobController.text) == 0) {
            var age = calculateAge(dobController.text);
            print(age);
            if (age < 12) {
              idController.text = 'TE';
              TicketType newValue = listTicketTypes.firstWhere((element) => element.text == "V?? tr??? em");
              listTypes[index] = newValue;
              ticketTypeTECs[index].text = newValue.text;
            }
          }
          if (dobController.text.compareTo('--/--/----') == 0) {
            dobController.text = "";
          }
        });

    final pobField = TextFormField(
      controller: pobController,
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nh???p n??i sinh h??nh kh??ch";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "N??i sinh",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
      ),
    );

    final numberField = TextField(
      controller: phoneController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        hintText: "S??? ??i???n tho???i",
      ),
    );

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        hintText: "Email",
      ),
    );

    final nationField = TextField(
      readOnly: true,
      controller: nationalityController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500),
        ),
        hintText: "Qu???c t???ch",
      ),
      onTap: () async {
        var nation = await Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseNationScreen(context))) as Nation;
        setState(() {
          nationalityTECs[index].text = nation.name;
          listNationId[index] = nation;
        });
      },
    );

    final typesTicket = Stack(
      children: <Widget>[
        TextField(
          readOnly: true,
          controller: ticketTypeController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 0.0),
          ),
        ),
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              isExpanded: true,
              items: listTicketTypes.map((TicketType element) => DropdownMenuItem(child: Text(element.text), value: element)).toList(),
              onChanged: (newValue) {
                setState(() {
                  listTypes[index] = newValue;
                  ticketTypeTECs[index].text = newValue.text;
                });
              },
            ),
          ),
        )
      ],
    );

    final typeTicket = InputDecorator(
      decoration: InputDecoration(
        fillColor: Colors.grey[300],
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TicketType>(
          value: ticketTypeChosen,
          isDense: true,
          isExpanded: true,
          items: listTicketTypes.map((TicketType element) => DropdownMenuItem(child: Text(element.text), value: element)).toList(),
          onChanged: (newValue) {
            print(newValue.text);
            setState(() {
              listTypes[index] = newValue;
            });
            print(listTypes[index].text);
          },
        ),
      ),
    );

    final scanButton = Container(
      decoration: const ShapeDecoration(
        color: Colors.grey,
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: () {
          _scanQR();
        },
        icon: Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        iconSize: 30.0,
      ),
    );

    if (index == 0 && widget.isPassenger == true) {
      nameController.text = MyApp.order.bookerName;
      phoneController.text = MyApp.order.bookerPhone;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
            ),
            border: Border.all(color: Color(0xff134F89)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
              child: Text(listSeats[index].seatNm), // <-- Wrapped in Expanded.
            ),
            SizedBox(width: 15.0),
            Expanded(child: Text("Gi??: " + oCcy.format(listPrices[index].priceWithVAT.round()).toString() + " VND") // <-- Wrapped in Expanded.
                )
          ]),
        ),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
            border: Border.all(color: Color(0xff134F89)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: nameField, // <-- Wrapped in Expanded.
                  ),
                  Expanded(
                    flex: 2,
                    child: scanButton, // <-- Wrapped in Expanded.
                  )
                ]),
                SizedBox(height: 15.0),
                idNoField,
                SizedBox(height: 15.0),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                    child: dobField, // <-- Wrapped in Expanded.
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: pobField, // <-- Wrapped in Expanded.
                  )
                ]),
                SizedBox(height: 15.0),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                    child: numberField, // <-- Wrapped in Expanded.
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: emailField, // <-- Wrapped in Expanded.
                  )
                ]),
                SizedBox(height: 15.0),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Expanded(
                    child: nationField, // <-- Wrapped in Expanded.
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: typesTicket, // <-- Wrapped in Expanded.
                  )
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff134F89),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          createOrder();
        },
        child: Text("Xu???t v??", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: Text('Th??ng tin h??nh kh??ch'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(children: listWidgetPassengers),
                SizedBox(height: 15.0),
                nextButton,
                SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
