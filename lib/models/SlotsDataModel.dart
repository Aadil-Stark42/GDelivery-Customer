class SlotsDataModel {
  bool? status;
  String? message;
  String? estimatedTime;
  List<Slots>? slots = [];

  SlotsDataModel({this.status, this.message, this.estimatedTime, this.slots});

  SlotsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    estimatedTime = json['estimated_time'];
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['estimated_time'] = this.estimatedTime;
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  int? slotId;
  String? time;

  Slots({this.slotId, this.time});

  Slots.fromJson(Map<String, dynamic> json) {
    slotId = json['slot_id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_id'] = this.slotId;
    data['time'] = this.time;
    return data;
  }
}
