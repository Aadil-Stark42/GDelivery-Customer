class ShopDetailsDataModel {
  bool? status;
  String? message;
  ShopDetails? shopDetails;
  List<Categories>? categories;
  List<ShopProducts>? shopProducts;
  List<Coupons>? coupons = [];
  ShopDetailsDataModel(
      {this.status,
      this.message,
      this.shopDetails,
      this.categories,
      this.shopProducts,
      this.coupons});

  ShopDetailsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    shopDetails = json['shop_details'] != null
        ? new ShopDetails.fromJson(json['shop_details'])
        : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['shop_products'] != null) {
      shopProducts = <ShopProducts>[];
      json['shop_products'].forEach((v) {
        shopProducts!.add(new ShopProducts.fromJson(v));
      });
    }
    if (json['coupons'] != null) {
      coupons = <Coupons>[];
      json['coupons'].forEach((v) {
        coupons!.add(new Coupons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.shopDetails != null) {
      data['shop_details'] = this.shopDetails!.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.shopProducts != null) {
      data['shop_products'] =
          this.shopProducts!.map((v) => v.toJson()).toList();
    }
    if (this.coupons != null) {
      data['coupons'] = this.coupons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  int? id;
  String? couponCode;
  String? expiredOn;
  int? maxOrderAmount;
  String? couponPercentage;
  String? symbol;
  String? couponDescription;
  int? discountUseAmt;
  int? minOrderAmt;
  int? shopId;
  String? subCategoryId;
  String? productId;
  String? subCategoryName;
  String? productName;
  int? active;
  String? createdAt;
  String? updatedAt;

  Coupons(
      {this.id,
      this.couponCode,
      this.expiredOn,
      this.maxOrderAmount,
      this.couponPercentage,
      this.symbol,
      this.couponDescription,
      this.discountUseAmt,
      this.minOrderAmt,
      this.shopId,
      this.subCategoryId,
      this.productId,
      this.subCategoryName,
      this.productName,
      this.active,
      this.createdAt,
      this.updatedAt});

  Coupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponCode = json['coupon_code'];
    expiredOn = json['expired_on'];
    maxOrderAmount = json['max_order_amount'];
    couponPercentage = json['coupon_percentage'];
    symbol = json['symbol'];
    couponDescription = json['coupon_description'];
    discountUseAmt = json['Discount_use_amt'];
    minOrderAmt = json['min_order_amt'];
    shopId = json['shop_id'];
    subCategoryId = json['sub_category_id'];
    productId = json['product_id'];
    subCategoryName = json['sub_category_name'];
    productName = json['product_name'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_code'] = this.couponCode;
    data['expired_on'] = this.expiredOn;
    data['max_order_amount'] = this.maxOrderAmount;
    data['coupon_percentage'] = this.couponPercentage;
    data['symbol'] = this.symbol;
    data['coupon_description'] = this.couponDescription;
    data['Discount_use_amt'] = this.discountUseAmt;
    data['min_order_amt'] = this.minOrderAmt;
    data['shop_id'] = this.shopId;
    data['sub_category_id'] = this.subCategoryId;
    data['product_id'] = this.productId;
    data['sub_category_name'] = this.subCategoryName;
    data['product_name'] = this.productName;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ShopDetails {
  int? shopId;
  String? shopName;
  String? shopImage;
  String? shopArea;
  String? shopAddress;
  String? distance;
  String? time;
  String? price;
  int? rating;
  int? ratingCount;
  bool? isWishlist;
  bool isCart = false;
  bool? isOpened;
  bool? shop_isopened;

  ShopDetails(
      {this.shopId,
      this.shopName,
      this.shopImage,
      this.shopArea,
      this.shopAddress,
      this.distance,
      this.time,
      this.price,
      this.rating,
      this.ratingCount,
      this.isWishlist,
      required this.isCart,
      this.isOpened,
      this.shop_isopened});

  ShopDetails.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    shopImage = json['shop_image'];
    shopArea = json['shop_area'];
    shopAddress = json['shop_address'];
    distance = json['distance'];
    time = json['time'];
    price = json['price'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
    isWishlist = json['is_wishlist'];
    isCart = json['is_cart'];
    isOpened = json['is_opened'];
    shop_isopened = json['shop_isopened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['shop_name'] = this.shopName;
    data['shop_image'] = this.shopImage;
    data['shop_area'] = this.shopArea;
    data['shop_address'] = this.shopAddress;
    data['distance'] = this.distance;
    data['time'] = this.time;
    data['price'] = this.price;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    data['is_wishlist'] = this.isWishlist;
    data['is_cart'] = this.isCart;
    data['is_opened'] = this.isOpened;
    data['shop_isopened'] = this.shop_isopened;

    return data;
  }
}

class Categories {
  int? categoryId;
  String? categoryName;

  Categories({this.categoryId, this.categoryName});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class ShopProducts {
  int? productId;
  String? productName;
  String? productImage;
  String? description;
  int? variety;
  int? canCustomize = 0;
  int? inCartTotal;
  List<Variants>? variants;

  ShopProducts(
      {this.productId,
      this.productName,
      this.productImage,
      this.description,
      this.variety,
      this.canCustomize,
      this.inCartTotal,
      this.variants});

  ShopProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    description = json['description'];
    variety = json['variety'];
    canCustomize = json['can_customize'];
    inCartTotal = json['in_cart_total'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['description'] = this.description;
    data['variety'] = this.variety;
    data['can_customize'] = this.canCustomize;
    data['in_cart_total'] = this.inCartTotal;
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
