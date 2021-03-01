class Sign {
  String signEncode;
  int signerId;
  Sign({
    this.signEncode,
    this.signerId,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'signEncode': signEncode.trim(),
      'signerId': signerId,
    };
    return map;
  }
}

class SignInvoice {
  String signEncode;
  int signerId;
  int invoiceId;
  SignInvoice({this.invoiceId, this.signEncode, this.signerId});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'signEncode': signEncode.trim(),
      'signerId': signerId,
      'invoiceId': invoiceId,
    };
    return map;
  }
}

class SignToContract {
  int signId;
  int contractId;
  SignToContract({
    this.contractId,
    this.signId,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'signId': signId,
      'contractId': contractId,
    };
    return map;
  }
}

class SignToInvoice {
  int signId;
  int invoiceId;
  SignToInvoice({
    this.invoiceId,
    this.signId,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'signId': signId,
      'invoiceId': invoiceId,
    };
    return map;
  }
}

class SignResponseModel {
  final int signID;
  SignResponseModel({this.signID});
  factory SignResponseModel.fromJson(Map<String, dynamic> json) {
    return SignResponseModel(
      signID: json["id"] != null ? json["id"] : "",
    );
  }
}
