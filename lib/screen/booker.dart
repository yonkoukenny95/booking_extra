import 'dart:convert';

import 'package:booking_extra/main.dart';
import 'package:booking_extra/model/CustomerType.dart';
import 'package:booking_extra/screen/passenger.dart';
import 'package:booking_extra/screen/search.dart';
import 'package:booking_extra/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'cargo.dart';

class BookerPage extends StatefulWidget {
  BookerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BookerPageState createState() => _BookerPageState();
}

class _BookerPageState extends State<BookerPage> {
  CustomerType customerType;
  bool isPassenger = false;
  bool isGetInvoice = false;
  List<CustomerType> listCustomerType = new List<CustomerType>();
  var bookerNameController = new TextEditingController();
  var bookerPhoneController = new TextEditingController();
  var numberPassengersController = TextEditingController();
  var invoiceBookerNameController = new TextEditingController();
  var invoiceCompanyNameController = new TextEditingController();
  var invoiceAddressController = new TextEditingController();
  var invoiceEmailController = new TextEditingController();
  var invoiceMSTController = new TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getCustomerTypes();
  }

  _getCustomerTypes() async {
    try {
      print('$host/CustomerType/GetCustomerTypes');
      Client client = Client();
      var res = await client.get(Uri.parse('$host/CustomerType/GetCustomerTypes'), headers: header);
      if (res.statusCode == 200) {
        if (res.contentLength != 0) {
          var resultJson = json.decode(res.body);
          for (var element in resultJson) {
            listCustomerType.add(CustomerType.fromJson(element));
          }
          customerType = listCustomerType[0];
          setState(() {});
        } else {
          print(res);
        }
      } else {
        throw Exception('Không lấy được danh sách loại khách');
      }
    } catch (ex) {
      print(ex);
    }
  }

  _saveOrder() {
    if (formKey.currentState.validate()) {
      MyApp.order.bookerName = bookerNameController.text;
      MyApp.order.bookerPhone = bookerPhoneController.text;
      MyApp.order.numberPassengers = int.parse(numberPassengersController.text);
      MyApp.order.customerType = customerType;
      MyApp.order.invoiceBookerName = invoiceBookerNameController.text;
      MyApp.order.invoiceCompanyName = invoiceCompanyNameController.text;
      MyApp.order.invoiceAddress = invoiceAddressController.text;
      MyApp.order.invoiceEmail = invoiceEmailController.text;
      MyApp.order.invoiceMST = invoiceMSTController.text;
      Navigator.push(context, MaterialPageRoute(builder: (context) => PassengerPage(isPassenger: isPassenger)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: bookerNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nhập tên người mua";
        }
        return null;
      },
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Tên người mua",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final numberField = TextFormField(
      controller: bookerPhoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nhập số điện thoại người mua";
        }
        return null;
      },
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Số điện thoại",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final typeCustomer = InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CustomerType>(
          hint: Text("Chọn tuyến"),
          value: customerType,
          isDense: true,
          isExpanded: true,
          items: listCustomerType.map((CustomerType element) => DropdownMenuItem(child: Text(element.cusTypeNm), value: element)).toList(),
          onChanged: (newValue) {
            setState(() {
              customerType = newValue;
            });
          },
        ),
      ),
    );

    final nameInvoiceField = TextField(
      controller: invoiceBookerNameController,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Tên người đặt",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final companyField = TextField(
      controller: invoiceCompanyNameController,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Tên công ty",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final addressField = TextField(
      controller: invoiceAddressController,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Địa chỉ",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final emailField = TextField(
      controller: invoiceEmailController,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final mstField = TextField(
      controller: invoiceMSTController,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mã số thuế",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final numberPassengersField = TextFormField(
      controller: numberPassengersController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nhập số lượng hành khách";
        }
        return null;
      },
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Số lượng hành khách",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );

    final nextButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff134F89),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _saveOrder();
        },
        child: Text("Kế tiếp", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: Text('Thông tin đặt vé'),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          /*Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CargoPage()));
                },
                child: Icon(
                  Icons.featured_play_list_rounded  ,
                  size: 26.0,
                ),
              )),*/
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),

        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('THÔNG TIN NGƯỜI ĐẶT VÉ'),
                  SizedBox(height: 15.0),
                  nameField,
                  SizedBox(height: 15.0),
                  numberField,
                  SizedBox(height: 15.0),
//                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                    Expanded(child: typeCustomer),
//                    SizedBox(width: 15.0),
//                    Expanded(child: numberPassengersField),
//                  ]),
                  typeCustomer,
                  SizedBox(height: 15.0),
                  numberPassengersField,
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                          value: isPassenger,
                          visualDensity: VisualDensity.compact,
                          onChanged: (newValue) => setState(() {
                                isPassenger = newValue;
                              })),
                      SizedBox(width: 0),
                      Flexible(
                        child: Text('Hành khách chính', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                          value: isGetInvoice,
                          visualDensity: VisualDensity.compact,
                          onChanged: (newValue) => setState(() {
                                isGetInvoice = newValue;
                              })),
                      SizedBox(width: 0),
                      Flexible(
                        child: Text('Xuất hóa đơn', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  (isGetInvoice == true)
                      ? (new Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 15.0),
                              Text('THÔNG TIN XUẤT HÓA ĐƠN'),
                              SizedBox(height: 15.0),
                              nameInvoiceField,
                              SizedBox(height: 15.0),
                              companyField,
                              SizedBox(height: 15.0),
                              addressField,
                              SizedBox(height: 15.0),
                              emailField,
                              SizedBox(height: 15.0),
                              mstField,
                              SizedBox(height: 15.0),
                            ],
                          ),
                        ))
                      : SizedBox(height: 15.0),
                  nextButton,
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
