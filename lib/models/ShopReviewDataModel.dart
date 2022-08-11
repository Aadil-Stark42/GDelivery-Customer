class ShopReviewDataModel {
  bool? status;
  String? message;
  Shop? shop;
  List<RecentReviews>? recentReviews;

  ShopReviewDataModel(
      {this.status, this.message, this.shop, this.recentReviews});

  ShopReviewDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    if (json['recent_reviews'] != null) {
      recentReviews = <RecentReviews>[];
      json['recent_reviews'].forEach((v) {
        recentReviews!.add(new RecentReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.recentReviews != null) {
      data['recent_reviews'] =
          this.recentReviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shop {
  int? shopId;
  String? shopName;
  String? bannerImage;
  String? shopArea;
  int? rating;
  int? ratingCount;
  bool? isWishlist;

  Shop(
      {this.shopId,
      this.shopName,
      this.bannerImage,
      this.shopArea,
      this.rating,
      this.ratingCount,
      this.isWishlist});

  Shop.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    bannerImage = json['banner_image'];
    shopArea = json['shop_area'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    isWishlist = json['is_wishlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['banner_image'] = this.bannerImage;
    data['shop_area'] = this.shopArea;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['is_wishlist'] = this.isWishlist;
    return data;
  }
}

class RecentReviews {
  String? username;
  int? rating;
  String? time;

  RecentReviews({this.username, this.rating, this.time});

  RecentReviews.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    rating = json['rating'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['rating'] = this.rating;
    data['time'] = this.time;
    return data;
  }
}
