class NotificationDataModel {
  Data? data;

  NotificationDataModel({this.data});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? image;
  String? title;
  String? message;
  String? type;

  Data({this.image, this.title, this.message, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }
}
