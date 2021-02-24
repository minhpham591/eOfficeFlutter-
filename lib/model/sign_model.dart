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
