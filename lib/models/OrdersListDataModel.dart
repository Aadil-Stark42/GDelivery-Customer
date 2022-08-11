class OrdersListDataModel {
  bool? status;
  String? message;
  List<Orders>? orders;

  OrdersListDataModel({this.status, this.message, this.orders});

  OrdersListDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? orderId;
  String? orderReferel;
  int? orderStatus;
  ShopDetails? shopDetails;
  List<ProductDetails>? productDetails;
  String? orderedAt;
  String? totalAmount;
  String? fullTimeLeft;
  int? timeLeftMin;
  int? timeLeftSec;
  bool? canCancel;

  Orders(
      {this.orderId,
      this.orderReferel,
      this.orderStatus,
      this.shopDetails,
      this.productDetails,
      this.orderedAt,
      this.totalAmount,
      this.fullTimeLeft,
      this.timeLeftMin,
      this.timeLeftSec,
      this.canCancel});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderReferel = json['order_referel'];
    orderStatus = json['order_status'];
    shopDetails = json['shop_details'] != null
        ? new ShopDetails.fromJson(json['shop_details'])
        : null;
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
    orderedAt = json['ordered_at'];
    totalAmount = json['total_amount'];
    fullTimeLeft = json['full_time_left'];
    timeLeftMin = json['time_left_min'];
    timeLeftSec = json['time_left_sec'];
    canCancel = json['can_cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_referel'] = this.orderReferel;
    data['order_status'] = this.orderStatus;
    if (this.shopDetails != null) {
      data['shop_details'] = this.shopDetails!.toJson();
    }
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    data['ordered_at'] = this.orderedAt;
    data['total_amount'] = this.totalAmount;
    data['full_time_left'] = this.fullTimeLeft;
    data['time_left_min'] = this.timeLeftMin;
    data['time_left_sec'] = this.timeLeftSec;
    data['can_cancel'] = this.canCancel;
    return data;
  }
}

class ShopDetails {
  int? cartId;
  int? shopId;
  String? shopName;
  String? shopStreet;
  String? shopImage;

  ShopDetails(
      {this.cartId,
      this.shopId,
      this.shopName,
      this.shopStreet,
      this.shopImage});

  ShopDetails.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopStreet = json['shop_street'];
    shopImage = json['shop_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_street'] = this.shopStreet;
    data['shop_image'] = this.shopImage;
    return data;
  }
}

class ProductDetails {
  String? productName;
  ProductDetails({this.productName});
  ProductDetails.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    return data;
  }
}
