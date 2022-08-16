class CityDataModel {
  bool? status;
  Cities? cities;

  CityDataModel({this.status, this.cities});

  CityDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    cities =
        json['cities'] != null ? new Cities.fromJson(json['cities']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cities != null) {
      data['cities'] = this.cities!.toJson();
    }
    return data;
  }
}

class Cities {
  List<Citiess>? citiess;

  Cities({this.citiess});

  Cities.fromJson(Map<String, dynamic> json) {
    if (json['cities'] != null) {
      citiess = <Citiess>[];
      json['cities'].forEach((v) {
        citiess!.add(new Citiess.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.citiess != null) {
      data['cities'] = this.citiess!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Citiess {
  int? id;
  String? name;
  int? isActive;
  String? createdDate;

  Citiess({this.id, this.name, this.isActive, this.createdDate});

  Citiess.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
