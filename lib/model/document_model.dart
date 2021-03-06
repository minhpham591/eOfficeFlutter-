class DocContractResponseModel {
  final String url;
  DocContractResponseModel({this.url});
  factory DocContractResponseModel.fromJson(Map<String, dynamic> json) {
    return DocContractResponseModel(
      url: json["contractUrl"] != null ? json["contractUrl"] : "",
    );
  }
}

class DocInvoiceResponseModel {
  final String url;
  DocInvoiceResponseModel({this.url});
  factory DocInvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    return DocInvoiceResponseModel(
      url: json["invoiceURL"] != null ? json["invoiceURL"] : "",
    );
  }
}
