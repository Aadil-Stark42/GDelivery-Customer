class ProductToppingDataModel {
  bool? status;
  String? message;
  Product? product;
  List<Quantity>? quantity;
  List<Toppings>? toppings;

  ProductToppingDataModel(
      {this.status, this.message, this.product, this.quantity, this.toppings});

  ProductToppingDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    if (json['quantity'] != null) {
      quantity = <Quantity>[];
      json['quantity'].forEach((v) {
        quantity!.add(new Quantity.fromJson(v));
      });
    }
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(new Toppings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity!.map((v) => v.toJson()).toList();
    }
    if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? productName;
  int? variety;

  Product({this.productName, this.variety});

  Product.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    variety = json['variety'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['variety'] = this.variety;
    return data;
  }
}

class Quantity {
  int? id;
  String? size;
  int? variety;
  String? price;

  Quantity({this.id, this.size, this.variety, this.price});

  Quantity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
    variety = json['variety'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['variety'] = this.variety;
    data['price'] = this.price;
    return data;
  }
}

class Toppings {
  String? toppingId;
  String? name;
  String? price;
  int? variety;
  bool? IsChecked = false;

  Toppings({this.toppingId, this.name, this.price, this.variety});

  Toppings.fromJson(Map<String, dynamic> json) {
    toppingId = json['topping_id'].toString();
    name = json['name'].toString();
    price = json['price'].toString();
    variety = json['variety'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topping_id'] = this.toppingId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['variety'] = this.variety;
    return data;
  }
}
