import 'package:intl/intl.dart';

//const String host = 'http://datve.phuquocexpress.com/BookingOT';
//const String host = 'http://192.168.1.29/BookingOverTime/Api';
const String host = 'http://brightbrain.ddns.net:5000/bookingovertime';
const String urlBookingTicket = host +'';
const String urlDataSource = host + '';
const Map<String, String> header = {"Content-Type": "application/json", "PQE-ApiKey": "PQE/API", "Authorization": "Basic "
    "QXV0aGVudGljYXRlZEFwaVVzZXI6MTIzQGJjIUAj"};
calculateAge(String str) {
  DateTime birthDate = DateFormat('dd/MM/yyyy').parse(str);
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}


