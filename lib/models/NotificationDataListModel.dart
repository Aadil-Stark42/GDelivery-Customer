class NotificationDataListModel {
  bool? status;
  String? message;
  List<NotificationList>? notificationList;

  NotificationDataListModel({this.status, this.message, this.notificationList});

  NotificationDataListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['notification_list'] != null) {
      notificationList = <NotificationList>[];
      json['notification_list'].forEach((v) {
        notificationList!.add(new NotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.notificationList != null) {
      data['notification_list'] =
          this.notificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationList {
  int? notifyId;
  String? notifyHead;
  String? image;
  String? description;

  NotificationList(
      {this.notifyId, this.notifyHead, this.image, this.description});

  NotificationList.fromJson(Map<String, dynamic> json) {
    notifyId = json['notify_id'];
    notifyHead = json['notify_head'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notify_id'] = this.notifyId;
    data['notify_head'] = this.notifyHead;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}
