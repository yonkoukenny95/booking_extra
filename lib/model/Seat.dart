class Seat {
  int _seatID;
  int _positionID;
  String _seatNm;
  double _priceAdult;
  String _idPriceAdult;
  double _priceChild;
  String _idPriceChild;
  String _ticketClass;

  Seat(this._seatID, this._positionID, this._seatNm, this._priceAdult, this._idPriceAdult, this._priceChild, this._idPriceChild, this._ticketClass);

  Seat.fromJson(Map<String, dynamic> json) {
    _seatID = json['SeatId'];
    _positionID = json['PositionId'];
    _seatNm = json['SeatNm'];
    _ticketClass = json['TicketClass'];
  }

  String get seatNm => _seatNm;

  int get positionID => _positionID;

  int get seatID => _seatID;

  String get ticketClass => _ticketClass;

  String get idPriceChild => _idPriceChild;

  double get priceChild => _priceChild;

  String get idPriceAdult => _idPriceAdult;

  double get priceAdult => _priceAdult;

}
