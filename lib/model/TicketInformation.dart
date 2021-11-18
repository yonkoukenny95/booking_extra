class TicketInformation {
  String orderNo;
  String tmplNo;
  String companyNm;
  String companyAddr;
  String companyTaxCode;
  String agentNm;
  String fromPlace;
  String toPlace;
  int ticketId;
  String boatNm;
  String departDateTime;
  String seatNm;
  String passengerNm;
  String idNo;
  String ticketTypeNm;
  double price;
  double discount;
  String qRCode;
  String harbor;
  String invoiceCode;
  String publishedById;
  String ticketClass;

  TicketInformation.fromJson(Map<String, dynamic> parsedJson) {
    orderNo = parsedJson["OrderNo"];
    tmplNo = parsedJson["TmplNo"];
    companyNm = parsedJson["CompanyNm"];
    companyAddr = parsedJson["CompanyAddr"];
    companyTaxCode = parsedJson["CompanyTaxCode"];
    agentNm = parsedJson["AgentNm"];
    fromPlace = parsedJson["FromPlace"];
    toPlace = parsedJson["ToPlace"];
    ticketId = parsedJson["TicketId"];
    boatNm = parsedJson["BoatNm"];
    departDateTime = parsedJson["DepartDateTime"];
    seatNm = parsedJson["SeatNm"];
    passengerNm = parsedJson["PassengerNm"];
    idNo = parsedJson["IdNo"];
    ticketTypeNm = parsedJson["TicketTypeNm"];
    price = parsedJson["Price"];
    discount = parsedJson["Discount"];
    qRCode = parsedJson["QRCode"];
    harbor = parsedJson["Harbor"];
    invoiceCode = parsedJson["InvoiceCode"];
    publishedById = parsedJson["PublishedById"];
    ticketClass = parsedJson["TicketClass"];
  }


}
