class CartDataModel {
  bool? status;
  String? message;
  String? currency;
  ShopDetails? shopDetails;
  List<Products>? products;
  String? instructions;
  int? totalItems;
  String? couponDiscount;
  String? deliveryCharge;
  int? tax;
  String? subTotal;
  String? total;
  int? gstPer;
  String? gstPrice;
  String? packingCharge;

  CartDataModel(
      {this.status,
      this.message,
      this.currency,
      this.shopDetails,
      this.products,
      this.instructions,
      this.totalItems,
      this.couponDiscount,
      this.deliveryCharge,
      this.tax,
      this.subTotal,
      this.total,
      this.gstPer,
      this.gstPrice,
      this.packingCharge});

  CartDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    currency = json['currency'];
    shopDetails = json['shop_details'] != null
        ? new ShopDetails.fromJson(json['shop_details'])
        : null;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    instructions = json['instructions'];
    totalItems = json['total_items'];
    couponDiscount = json['coupon_discount'];
    deliveryCharge = json['delivery_charge'];
    tax = json['tax'];
    subTotal = json['sub_total'];
    total = json['total'];
    gstPer = json['gst_per'];
    gstPrice = json['gst_price'];
    packingCharge = json['packing_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['currency'] = this.currency;
    if (this.shopDetails != null) {
      data['shop_details'] = this.shopDetails!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['instructions'] = this.instructions;
    data['total_items'] = this.totalItems;
    data['coupon_discount'] = this.couponDiscount;
    data['delivery_charge'] = this.deliveryCharge;
    data['tax'] = this.tax;
    data['sub_total'] = this.subTotal;
    data['total'] = this.total;
    data['gst_per'] = this.gstPer;
    data['gst_price'] = this.gstPrice;
    data['packing_charge'] = this.packingCharge;
    return data;
  }
}

class ShopDetails {
  int? cartId;
  int? shopId;
  String? shopName;
  String? shopStreet;
  String? shopImage;
  bool? isOpened;
  bool? shop_isopened = true;

  ShopDetails({
    this.cartId,
    this.shopId,
    this.shopName,
    this.shopStreet,
    this.shopImage,
    this.isOpened,
    this.shop_isopened,
  });

  ShopDetails.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopStreet = json['shop_street'];
    shopImage = json['shop_image'];
    isOpened = json['is_opened'];
    shop_isopened = json['shop_isopened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_street'] = this.shopStreet;
    data['shop_image'] = this.shopImage;
    data['is_opened'] = this.isOpened;
    data['shop_isopened'] = this.shop_isopened;
    return data;
  }
}

class Products {
  int? id;
  int? cartProductId;
  int? productId;
  String? productName;
  int? variety;
  String? size;
  String? amount;
  String? totalAmount;
  int? quantity;
  int? canCustomize;
  List<Topping>? toppings;

  Products(
      {this.id,
      this.cartProductId,
      this.productId,
      this.productName,
      this.variety,
      this.size,
      this.amount,
      this.totalAmount,
      this.quantity,
      this.canCustomize,
      this.toppings});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartProductId = json['cart_product_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    variety = json['variety'];
    size = json['size'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    quantity = json['quantity'];
    canCustomize = json['can_customize'];
    if (json['toppings'] != null) {
      toppings = <Topping>[];
      json['toppings'].forEach((v) {
        toppings!.add(Topping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cart_product_id'] = this.cartProductId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['variety'] = this.variety;
    data['size'] = this.size;
    data['amount'] = this.amount;
    data['total_amount'] = this.totalAmount;
    data['quantity'] = this.quantity;
    data['can_customize'] = this.canCustomize;
    if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topping {
  int? id;
  String? name;
  int? price;

  Topping({
    this.id,
    this.name,
    this.price,
  });

  Topping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;

    return data;
  }
}
