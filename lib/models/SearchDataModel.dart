class SearchDataModel {
  bool? status;
  String? message;
  List<Products>? products;

  SearchDataModel({this.status, this.message, this.products});

  SearchDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? productId;
  int? categoryId;
  String? productName;
  String? productImage;
  String? description;
  int? variety;
  List<Variants>? variants;

  Products(
      {this.productId,
      this.categoryId,
      this.productName,
      this.productImage,
      this.description,
      this.variety,
      this.variants});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    description = json['description'];
    variety = json['variety'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['category_id'] = this.categoryId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['description'] = this.description;
    data['variety'] = this.variety;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
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
  String? variant;
  String? unit;
  int? availableCount;
  String? discount;

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
    discount = json['discount'].toString();
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
