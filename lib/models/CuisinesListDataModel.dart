class CuisinesListDataModel {
  bool? status;
  String? message;
  List<Cuisines>? cuisines;

  CuisinesListDataModel({this.status, this.message, this.cuisines});

  CuisinesListDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['cuisines'] != null) {
      cuisines = <Cuisines>[];
      json['cuisines'].forEach((v) {
        cuisines!.add(new Cuisines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.cuisines != null) {
      data['cuisines'] = this.cuisines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cuisines {
  int? cuisineId;
  String? cuisineName;
  bool? isCheck = false;

  Cuisines({this.cuisineId, this.cuisineName, this.isCheck});

  Cuisines.fromJson(Map<String, dynamic> json) {
    cuisineId = json['cuisine_id'];
    cuisineName = json['cuisine_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cuisine_id'] = this.cuisineId;
    data['cuisine_name'] = this.cuisineName;
    return data;
  }
}
