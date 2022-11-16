import 'package:booking_extra/model/CustomerType.dart';
import 'package:booking_extra/model/Passenger.dart';
import 'package:booking_extra/model/Voyage.dart';

class Order {
  String bookerName;
  String bookerPhone;
  int numberPassengers;
  CustomerType customerType;
  String invoiceBookerName;
  String invoiceCompanyName;
  String invoiceAddress;
  String invoiceEmail;
  String invoiceMST;
  int routeId;
  String routeText;
  Voyage voyage;
  String departDate;
  Order();


}
