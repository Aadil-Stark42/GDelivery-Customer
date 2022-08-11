import 'package:gdeliverycustomer/models/CartDataModel.dart';

class OrderDetailsDataModel {
  bool? status;
  String? message;
  ShopDetails? shopDetails;
  TimeDetails? timeDetails;
  List<Items>? items;
  OrderDetails? orderDetails;
  String? deliveryBoyContact;

  OrderDetailsDataModel(
      {this.status,
      this.message,
      this.shopDetails,
      this.timeDetails,
      this.items,
      this.orderDetails,
      this.deliveryBoyContact});

  OrderDetailsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shopDetails = json['shop_details'] != null
        ? new ShopDetails.fromJson(json['shop_details'])
        : null;
    timeDetails = json['time_details'] != null
        ? new TimeDetails.fromJson(json['time_details'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
    deliveryBoyContact = json['delivery_boy_contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.shopDetails != null) {
      data['shop_details'] = this.shopDetails!.toJson();
    }
    if (this.timeDetails != null) {
      data['time_details'] = this.timeDetails!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.toJson();
    }
    data['delivery_boy_contact'] = this.deliveryBoyContact;
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

class TimeDetails {
  int? orderStatus;
  String? confirmedAt;
  String? pickedAt;
  String? deliveredAt;

  TimeDetails(
      {this.orderStatus, this.confirmedAt, this.pickedAt, this.deliveredAt});

  TimeDetails.fromJson(Map<String, dynamic> json) {
    orderStatus = json['order_status'];
    confirmedAt = json['confirmed_at'];
    pickedAt = json['picked_at'];
    deliveredAt = json['delivered_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status'] = this.orderStatus;
    data['confirmed_at'] = this.confirmedAt;
    data['picked_at'] = this.pickedAt;
    data['delivered_at'] = this.deliveredAt;
    return data;
  }
}

class Items {
  int? id;
  String? productName;
  List<Topping>? toppings;
  int? variety;
  String? amount;
  String? totalAmount;
  String? quantity;
  String? size;
  String? unit;

  Items(
      {this.id,
      this.productName,
      this.toppings,
      this.variety,
      this.amount,
      this.totalAmount,
      this.quantity,
      this.size,
      this.unit});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    if (json['toppings'] != null) {
      toppings = <Topping>[];
      json['toppings'].forEach((v) {
        toppings!.add(new Topping.fromJson(v));
      });
    }
    variety = json['variety'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    quantity = json['quantity'];
    size = json['size'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }
    data['variety'] = this.variety;
    data['amount'] = this.amount;
    data['total_amount'] = this.totalAmount;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['unit'] = this.unit;
    return data;
  }
}

class OrderDetails {
  int? orderId;
  String? orderNumber;
  int? timeLeftMin;
  int? timeLeftSec;
  bool? canCancel;
  String? fullTimeLeft;
  String? address;
  int? paymentType;
  int? itemsTotal;
  String? subTotal;
  String? tax;
  String? deliveryCharge;
  String? couponDiscount;
  String? total;
  String? estimatedTime;
  int? isScheduled;

  OrderDetails(
      {this.orderId,
      this.orderNumber,
      this.timeLeftMin,
      this.timeLeftSec,
      this.canCancel,
      this.fullTimeLeft,
      this.address,
      this.paymentType,
      this.itemsTotal,
      this.subTotal,
      this.tax,
      this.deliveryCharge,
      this.couponDiscount,
      this.total,
      this.estimatedTime,
      this.isScheduled});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    timeLeftMin = json['time_left_min'];
    timeLeftSec = json['time_left_sec'];
    canCancel = json['can_cancel'];
    fullTimeLeft = json['full_time_left'];
    address = json['address'];
    paymentType = json['payment_type'];
    itemsTotal = json['items_total'];
    subTotal = json['sub_total'];
    tax = json['tax'];
    deliveryCharge = json['delivery_charge'];
    couponDiscount = json['coupon_discount'];
    total = json['total'];
    estimatedTime = json['estimated_time'];
    isScheduled = json['is_scheduled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['time_left_min'] = this.timeLeftMin;
    data['time_left_sec'] = this.timeLeftSec;
    data['can_cancel'] = this.canCancel;
    data['full_time_left'] = this.fullTimeLeft;
    data['address'] = this.address;
    data['payment_type'] = this.paymentType;
    data['items_total'] = this.itemsTotal;
    data['sub_total'] = this.subTotal;
    data['tax'] = this.tax;
    data['delivery_charge'] = this.deliveryCharge;
    data['coupon_discount'] = this.couponDiscount;
    data['total'] = this.total;
    data['estimated_time'] = this.estimatedTime;
    data['is_scheduled'] = this.isScheduled;
    return data;
  }
}
