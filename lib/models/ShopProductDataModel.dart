import 'ShopDetailsDataModel.dart';

class ShopProductDataModel {
  bool? status;
  String? message;
  bool? isCart;
  List<ShopProducts>? shopProducts;

  ShopProductDataModel(
      {this.status, this.message, this.isCart, this.shopProducts});

  ShopProductDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isCart = json['is_cart'];
    if (json['shop_products'] != null) {
      shopProducts = <ShopProducts>[];
      json['shop_products'].forEach((v) {
        shopProducts!.add(new ShopProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_cart'] = this.isCart;
    if (this.shopProducts != null) {
      data['shop_products'] =
          this.shopProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variants {
  int? id;
  int? inCart;
  int? cartCount;
  String? actualPrice;
  String? price;
  String? currency;
  Null? variant;
  String? unit;
  int? availableCount;
  int? discount;

  Variants(
      {this.id,
      this.inCart,
      this.cartCount,
      this.actualPrice,
      this.price,
      this.currency,
      this.variant,
      this.unit,
      this.availableCount,
      this.discount});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inCart = json['in_cart'];
    cartCount = json['cart_count'];
    actualPrice = json['actual_price'];
    price = json['price'];
    currency = json['currency'];
    variant = json['variant'];
    unit = json['unit'];
    availableCount = json['available_count'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['in_cart'] = this.inCart;
    data['cart_count'] = this.cartCount;
    data['actual_price'] = this.actualPrice;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['variant'] = this.variant;
    data['unit'] = this.unit;
    data['available_count'] = this.availableCount;
    data['discount'] = this.discount;
    return data;
  }
}
