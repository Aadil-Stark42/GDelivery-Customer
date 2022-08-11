import 'package:gdeliverycustomer/models/CartDataModel.dart';

class OrderConfirmDataModel {
  bool? status;
  String? message;
  List<Items>? items;
  OrderDetails? orderDetails;
  PriceDetails? priceDetails;

  OrderConfirmDataModel(
      {this.status,
      this.message,
      this.items,
      this.orderDetails,
      this.priceDetails});

  OrderConfirmDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
    priceDetails = json['price_details'] != null
        ? new PriceDetails.fromJson(json['price_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.toJson();
    }
    if (this.priceDetails != null) {
      data['price_details'] = this.priceDetails!.toJson();
    }
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
  String? address;
  String? paymentType;
  String? deliveryTime;
  String? estimatedTime;
  int? isScheduled;

  OrderDetails(
      {this.orderId,
      this.orderNumber,
      this.address,
      this.paymentType,
      this.deliveryTime,
      this.estimatedTime,
      this.isScheduled});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    address = json['address'];
    paymentType = json['payment_type'];
    deliveryTime = json['delivery_time'];
    estimatedTime = json['estimated_time'];
    isScheduled = json['is_scheduled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['address'] = this.address;
    data['payment_type'] = this.paymentType;
    data['delivery_time'] = this.deliveryTime;
    data['estimated_time'] = this.estimatedTime;
    data['is_scheduled'] = this.isScheduled;
    return data;
  }
}

class PriceDetails {
  String? itemsTotal;
  String? subTotal;
  String? tax;
  String? deliveryCharge;
  String? couponDiscount;
  String? total;
  String? gstPrice;
  String? packingCharge;
  int? total_amount2;

  PriceDetails(
      {this.itemsTotal,
      this.subTotal,
      this.tax,
      this.deliveryCharge,
      this.couponDiscount,
      this.total,
      this.total_amount2});

  PriceDetails.fromJson(Map<String, dynamic> json) {
    itemsTotal = json['items_total'];
    subTotal = json['sub_total'];
    tax = json['tax'];
    deliveryCharge = json['delivery_charge'];
    couponDiscount = json['coupon_discount'];
    total = json['total'];
    total_amount2 = json['total_amount2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['items_total'] = this.itemsTotal;
    data['sub_total'] = this.subTotal;
    data['tax'] = this.tax;
    data['delivery_charge'] = this.deliveryCharge;
    data['coupon_discount'] = this.couponDiscount;
    data['total'] = this.total;
    data['total_amount2'] = this.total_amount2;
    return data;
  }
}
