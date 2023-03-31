class TicketPrice{
  double _originalPrice;
  double _priceWithVAT;
  int _routeId;
  int _seatId;
  String _ticketClass;
  int _ticketPriceId;
  int _ticketTypeId;
  String _ticketTypeLabel;
  String _tmpltNo;
  String _series;
  DateTime _departDateBegin;
  DateTime _departDateEnd;

  TicketPrice.fromJson(Map<String, dynamic> parsedJson){
    _originalPrice=parsedJson['OriginalPrice'];
    _priceWithVAT=parsedJson['PriceWithVAT'];
    _routeId=parsedJson['RouteId'];
    _seatId=parsedJson['SeatId'];
    _ticketClass=parsedJson['TicketClass'];
    _ticketPriceId=parsedJson['TicketPriceId'];
    _ticketTypeId=parsedJson['TicketTypeId'];
    _ticketTypeLabel=parsedJson['TicketTypeLabel'];
    _tmpltNo=parsedJson['TmpltNo'];
    _series=parsedJson['Series'];
    _departDateBegin=parsedJson['DepartDateBegin'];
    _departDateEnd=parsedJson['DepartDateEnd'];
  }

  TicketPrice(this._originalPrice, this._priceWithVAT, this._routeId, this._seatId, this._ticketClass, this._ticketPriceId, this._ticketTypeId,
      this._ticketTypeLabel, this._tmpltNo, this._series, this._departDateBegin, this._departDateEnd);

  String get series => _series;

  String get tmpltNo => _tmpltNo;

  String get ticketTypeLabel => _ticketTypeLabel;

  int get ticketTypeId => _ticketTypeId;

  int get ticketPriceId => _ticketPriceId;

  String get ticketClass => _ticketClass;

  int get seatId => _seatId;

  int get routeId => _routeId;

  double get priceWithVAT => _priceWithVAT;

  double get originalPrice => _originalPrice;
  DateTime get departDateBegin => _departDateBegin;
  DateTime get departDateEnd => _departDateEnd;
}
