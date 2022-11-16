import 'package:booking_extra/model/Nation.dart';
import 'package:booking_extra/model/Seat.dart';

class Passenger {
  final String id;
  final String name;
  final String pob;
  final String dob;
  final String phone;
  final Nation nationality;
  final String email;
  final Seat voyageSeat;

  Passenger(
      this.id, this.name, this.pob, this.dob, this.phone, this.nationality, this.email, this.voyageSeat,);
}
