class WishListDataModel {
  bool? status;
  String? message;
  List<Shops>? shops;

  WishListDataModel({this.status, this.message, this.shops});

  WishListDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(new Shops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.shops != null) {
      data['shops'] = this.shops!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shops {
  int? shopId;
  String? shopName;
  String? shopImage;
  String? shopArea;
  String? shopAddress;
  String? price;
  String? intDis;
  String? distance;
  String? time;
  int? rating;
  int? ratingCount;
  bool? isWishlist;

  Shops(
      {this.shopId,
      this.shopName,
      this.shopImage,
      this.shopArea,
      this.shopAddress,
      this.price,
      this.intDis,
      this.distance,
      this.time,
      this.rating,
      this.ratingCount,
      this.isWishlist});

  Shops.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopImage = json['shop_image'];
    shopArea = json['shop_area'];
    shopAddress = json['shop_address'];
    price = json['price'];
    intDis = json['int_dis'];
    distance = json['distance'];
    time = json['time'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    isWishlist = json['is_wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_image'] = this.shopImage;
    data['shop_area'] = this.shopArea;
    data['shop_address'] = this.shopAddress;
    data['price'] = this.price;
    data['int_dis'] = this.intDis;
    data['distance'] = this.distance;
    data['time'] = this.time;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['is_wishlist'] = this.isWishlist;
    return data;
  }
}
