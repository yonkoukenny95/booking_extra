
class Voyage{
  int _voyageId;
  int _scheduleId;
  int _boatId;
  String _boatNm;
  int routeId;
  String _departDate;
  String _departTime;
  int _totalSeat;
  int _rowNumber;
  int _bookedNo;
  int _publishedNo;
  int _boatTypeId;
  int _noOfRemain;
  String _boatTypeNm;

  Voyage.fromJson(Map<String, dynamic> parsedJson){
    _voyageId=parsedJson['VoyageId'];
    _scheduleId=parsedJson['ScheduleId'];
    _boatId=parsedJson['BoatId'];
    _boatNm=parsedJson['BoatNm'];
    _departDate=parsedJson['DepartDate'];
    _departTime=parsedJson['DepartTime'];
    _totalSeat=parsedJson['TotalSeat'];
    _rowNumber=parsedJson['RowNumber'];
    _bookedNo=parsedJson['BookedNo'];
    _publishedNo=parsedJson['PublishedNo'];
    _noOfRemain=parsedJson['RemainingNo'];
    _boatTypeId = parsedJson['BoatTypeId'];
    _boatTypeNm = parsedJson['BoatTypeNm'];
  }

  Voyage(this._voyageId, this._scheduleId, this._boatId, this._boatNm, this._departDate, this._departTime, this._totalSeat,
      this._rowNumber, this._bookedNo, this._publishedNo, this._boatTypeId, this._noOfRemain, this._boatTypeNm);

  String get boatTypeNm => _boatTypeNm;

  int get noOfRemain => _noOfRemain;

  int get boatTypeId => _boatTypeId;

  int get publishedNo => _publishedNo;

  int get bookedNo => _bookedNo;

  int get rowNumber => _rowNumber;

  int get totalSeat => _totalSeat;

  String get departTime => _departTime;

  String get departDate => _departDate;

  String get boatNm => _boatNm;

  int get boatId => _boatId;

  int get scheduleId => _scheduleId;

  int get voyageId => _voyageId;
}