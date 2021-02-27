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

class SignResponseModel {
  final int signID;
  SignResponseModel({this.signID});
  factory SignResponseModel.fromJson(Map<String, dynamic> json) {
    return SignResponseModel(
      signID: json["id"] != null ? json["id"] : "",
    );
  }
}
