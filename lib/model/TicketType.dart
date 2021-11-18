class TicketType{
  bool _disabled;
  bool _selected;
  String label;
  int typeID;
  
  TicketType.fromJson(Map<String, dynamic> parsedJson){
    _disabled=parsedJson['Disabled'];
    _selected=parsedJson['Selected'];
    label=parsedJson['Label'];
    typeID=parsedJson['TicketTypeId'];
  }

  TicketType(this._disabled, this._selected, this.label, this.typeID);

  int get value => typeID;

  String get text => label;

  bool get selected => _selected;

  bool get disabled => _disabled;
}
