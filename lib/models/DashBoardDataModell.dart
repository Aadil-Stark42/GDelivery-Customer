class DashBoardDataModel {
  bool? status;
  String? message;
  int? notificationCount;
  int? wishlistCount;
  List<Category1>? category1;
  List<dynamic>? category2;
  String? termsAndConditions;
  String? privacyPolicy;
  List<Banners>? banners;
  List<ShopBanners>? shopBanners;
  Conatct? conatct;
  List<TopBadge>? topBadge;
  List<CatList>? catList;
  int? appStatus;

  DashBoardDataModel(
      {this.status,
      this.message,
      this.notificationCount,
      this.wishlistCount,
      this.category1,
      this.category2,
      this.termsAndConditions,
      this.privacyPolicy,
      this.banners,
      this.shopBanners,
      this.conatct,
      this.topBadge,
      this.catList,
      this.appStatus});

  DashBoardDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    notificationCount = json['notification_count'];
    wishlistCount = json['wishlist_count'];
    if (json['category1'] != null) {
      category1 = <Category1>[];
      json['category1'].forEach((v) {
        category1!.add(new Category1.fromJson(v));
      });
    }
    if (json['category2'] != null) {
      category2 = <dynamic>[];
      json['category2'].forEach((v) {
        category2!.add(v);
      });
    }
    termsAndConditions = json['terms_and_conditions'];
    privacyPolicy = json['privacy_policy'];
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['shop_banners'] != null) {
      shopBanners = <ShopBanners>[];
      json['shop_banners'].forEach((v) {
        shopBanners!.add(new ShopBanners.fromJson(v));
      });
    }
    conatct =
        json['conatct'] != null ? new Conatct.fromJson(json['conatct']) : null;
    if (json['top_badge'] != null) {
      topBadge = <TopBadge>[];
      json['top_badge'].forEach((v) {
        topBadge!.add(new TopBadge.fromJson(v));
      });
    }
    if (json['cat_list'] != null) {
      catList = <CatList>[];
      json['cat_list'].forEach((v) {
        catList!.add(new CatList.fromJson(v));
      });
    }
    appStatus = json['app_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['notification_count'] = this.notificationCount;
    data['wishlist_count'] = this.wishlistCount;
    if (this.category1 != null) {
      data['category1'] = this.category1!.map((v) => v.toJson()).toList();
    }
    if (this.category2 != null) {
      data['category2'] = this.category2!.map((v) => v.toJson()).toList();
    }
    data['terms_and_conditions'] = this.termsAndConditions;
    data['privacy_policy'] = this.privacyPolicy;
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.shopBanners != null) {
      data['shop_banners'] = this.shopBanners!.map((v) => v.toJson()).toList();
    }
    if (this.conatct != null) {
      data['conatct'] = this.conatct!.toJson();
    }
    if (this.topBadge != null) {
      data['top_badge'] = this.topBadge!.map((v) => v.toJson()).toList();
    }
    if (this.catList != null) {
      data['cat_list'] = this.catList!.map((v) => v.toJson()).toList();
    }
    data['app_status'] = this.appStatus;
    return data;
  }
}

class Category1 {
  int? id;
  String? name;
  String? image;
  String? banner;

  Category1({this.id, this.name, this.image, this.banner});

  Category1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['banner'] = this.banner;
    return data;
  }
}

class Banners {
  int? id;
  String? image;

  Banners({this.id, this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class ShopBanners {
  int? shopBannerId;
  String? image;

  ShopBanners({this.shopBannerId, this.image});

  ShopBanners.fromJson(Map<String, dynamic> json) {
    shopBannerId = json['shop_banner_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_banner_id'] = this.shopBannerId;
    data['image'] = this.image;
    return data;
  }
}

class Conatct {
  String? mobile;
  String? whatsapp;
  String? email;

  Conatct({this.mobile, this.whatsapp, this.email});

  Conatct.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    whatsapp = json['whatsapp'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['whatsapp'] = this.whatsapp;
    data['email'] = this.email;
    return data;
  }
}

class TopBadge {
  int? id;
  String? name;
  String? latitude;
  String? longitude;
  String? image;
  String? bannerImage;
  int? shopCategroyId;
  String? distance;
  String? time;

  TopBadge(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.image,
      this.bannerImage,
      this.shopCategroyId,
      this.distance,
      this.time});

  TopBadge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    image = json['image'];
    bannerImage = json['banner_image'];
    shopCategroyId = json['shop_categroy_id'];
    distance = json['distance'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['image'] = this.image;
    data['banner_image'] = this.bannerImage;
    data['shop_categroy_id'] = this.shopCategroyId;
    data['distance'] = this.distance;
    data['time'] = this.time;
    return data;
  }
}

class CatList {
  int? id;
  String? name;
  String? image;
  int? active;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  CatList(
      {this.id,
      this.name,
      this.image,
      this.active,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  CatList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    active = json['active'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['active'] = this.active;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
