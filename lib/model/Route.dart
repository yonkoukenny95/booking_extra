class RouteTrip {
  String _text;
  int _value;

  RouteTrip.fromJson(Map<String, dynamic> parsedJson){
    _text = parsedJson['Label'];
    _value = parsedJson['RouteId'];
  }

  RouteTrip(this._text, this._value);

  int get value => _value;

  String get text => _text;

}
