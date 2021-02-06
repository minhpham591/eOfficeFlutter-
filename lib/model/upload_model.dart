class UploadResponseModel {}

class UploadRequestModel {
  String name;
  dynamic image;

  UploadRequestModel({
    this.name,
    this.image,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'FileName': name.trim(),
      'File': image,
    };

    return map;
  }
}
