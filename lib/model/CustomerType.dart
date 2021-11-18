class CustomerType{
  String _cusTypeNm;
  int _cusTypeId;
  double _requireDeposit;
  bool _displayDiscountOnInvoice;
  bool _isTourPassenger;

  CustomerType.fromJson(Map<String, dynamic> parsedJson){
    _cusTypeNm=parsedJson['CusTypeNm'];
    _cusTypeId= parsedJson['CusTypeId'];
    _displayDiscountOnInvoice=parsedJson['DisplayDiscountOnInvoice'];
    _requireDeposit= parsedJson['RequireDeposit'];
    _isTourPassenger=parsedJson['IsTourPassenger'];
  }


  CustomerType(this._cusTypeNm, this._cusTypeId, this._requireDeposit, this._displayDiscountOnInvoice, this._isTourPassenger);

  bool get isTourPassenger => _isTourPassenger;

  bool get displayDiscountOnInvoice => _displayDiscountOnInvoice;

  double get requireDeposit => _requireDeposit;

  int get cusTypeId => _cusTypeId;

  String get cusTypeNm => _cusTypeNm;
}
