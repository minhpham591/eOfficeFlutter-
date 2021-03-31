class Status {
  int id;
  int status;
  Status({
    this.id,
    this.status,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'status': status,
    };
    return map;
  }
}
