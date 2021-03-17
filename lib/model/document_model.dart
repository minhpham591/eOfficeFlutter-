class DocContractResponseModel {
  final String url;
  final String signerId;
  final int status;
  DocContractResponseModel({this.url, this.signerId, this.status});
  factory DocContractResponseModel.fromJson(Map<String, dynamic> json) {
    return DocContractResponseModel(
      url: json["contractUrl"] != null ? json["contractUrl"] : "",
      signerId:
          json["signs"].toString() != null ? json["signs"].toString() : "",
      status: json["status"] != null ? json["status"] : "",
    );
  }
}

class DocInvoiceResponseModel {
  final String url;
  final int status;
  DocInvoiceResponseModel({this.url, this.status});
  factory DocInvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    return DocInvoiceResponseModel(
      url: json["invoiceURL"] != null ? json["invoiceURL"] : "",
      status: json["status"] != null ? json["status"] : "",
    );
  }
}
