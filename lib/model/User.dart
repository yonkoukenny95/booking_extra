class  User{
  String _uerNm;
  String _firstName;
  String _lastName;
  int _profileId;
  int _officeId;

  User();

  User.fromJson(Map<String, dynamic> parsedJson){
    _uerNm=parsedJson['UserNm'];
    _firstName= parsedJson['FirstName'];
    _lastName=parsedJson['LastName'];
    _profileId= parsedJson['ProfileId'];
    _officeId=parsedJson['OfficeId'];
  }
  int get officeId => _officeId;

  int get profileId => _profileId;

  String get lastName => _lastName;

  String get firstName => _firstName;

  String get uerNm => _uerNm;
}