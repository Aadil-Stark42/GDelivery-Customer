import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/models/ShopProductDataModel.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/ui/shop/ClearCartBottomDialog.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';
import '../../../utils/Utils.dart';
import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/animation_limiter.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../models/ShopDetailsDataModel.dart';
import '../../uicomponents/AddtoCartView.dart';
import '../../uicomponents/CustomTabView.dart';
import '../../uicomponents/MyProgressBar.dart';
import 'MainTappingView.dart';
import 'ShopDetailsHeader.dart';
import 'ShopReviewScreen.dart';

class ShopDetailsScreen extends StatefulWidget {
  final String shop_id, shop_cat_id, product_name;
  VoidCallback likebuttonclick;

  ShopDetailsScreen(
      this.shop_id, this.shop_cat_id, this.product_name, this.likebuttonclick);

  @override
  ShopDetailsScreenState createState() => ShopDetailsScreenState();
}

class ShopDetailsScreenState extends State<ShopDetailsScreen>
    with TickerProviderStateMixin {
  ShopDetailsDataModel shopDetailsDataModel = ShopDetailsDataModel();
  ShopProductDataModel shopProductDataModel = ShopProductDataModel();
  bool IsBottomCartShow = false;
  int selectedIndex = 0;
  List<Categories>? TabCategories = [
    Categories(categoryId: 000, categoryName: Recommended)
  ];
  int CurrentPosition = 0;

  @override
  void initState() {
    super.initState();
    GetShopDetails();
  }

  ButtonState buttonState = ButtonState.normal;
  String VersionName = "";

  @override
  Widget build(BuildContext context) {
    statusBarColorChange();
    return SafeArea(
        child: Scaffold(
      backgroundColor: whiteColor,
      body: ShopDetailsView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: HandleAddedtoCart(),
    ));
  }

  Widget HandleAddedtoCart() {
    if (IsBottomCartShow) {
      return AddtoCartView(IsBottomCartShow, () {
        setState(() {
          IsBottomCartShow = false;
        });
      });
    } else {
      return Container();
    }
  }

  Widget ShopDetailsView() {
    if (shopDetailsDataModel.status != null) {
      if (shopDetailsDataModel.status != false) {
        if (TabCategories!.length == 1) {
          shopDetailsDataModel.categories!.forEach((element) {
            TabCategories!.add(element);
          });
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            ShopDetailsHeader(
                shopDetailsDataModel,
                widget.shop_id,
                widget.shop_cat_id,
                shopDetailsDataModel.shopDetails!.isWishlist,
                widget.likebuttonclick),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: greyColor2,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image(
                                    image:
                                        AssetImage("${imagePath}location.png"),
                                    width: 15,
                                    height: 15,
                                    color: mainColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    shopDetailsDataModel.shopDetails!.distance
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: Segoe_ui_semibold,
                                        color: greyColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  ".",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: Segoe_ui_semibold,
                                      color: greyColor),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    size: 15,
                                    color: mainColor,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    shopDetailsDataModel.shopDetails!.time
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: Segoe_ui_semibold,
                                        color: greyColor),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  ".",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: Segoe_ui_semibold,
                                      color: greyColor),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    shopDetailsDataModel.shopDetails!.rating
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: Segoe_ui_semibold,
                                        color: mainColor),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    size: 15,
                                    color: mainColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 1,
                                height: 12,
                                color: greyColor2,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                shopDetailsDataModel.shopDetails!.ratingCount
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Segoe_ui_semibold,
                                    color: greyColor2),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Reviews",
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Segoe_ui_semibold,
                                    color: greyColor2),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => ShopReviewScreen(
                                      widget.shop_id,
                                      shopDetailsDataModel
                                          .shopDetails!.isWishlist)),
                            );
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: mainColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: greyColor2,
                    ),
                    CouponListview(),
                    SizedBox(
                      height: 10,
                    ),
                    /*---TabVIew----*/
                    Container(
                      height: MediaQuery.of(context).size.height / 1.6,
                      width: MediaQuery.of(context).size.width,
                      child: CustomTabView(
                        initPosition: CurrentPosition,
                        itemCount: TabCategories!.length,
                        tabBuilder: (context, index) =>
                            Tab(text: TabCategories![index].categoryName),
                        pageBuilder: (context, index) =>
                            TabViewContainer(TabCategories!, index),
                        onPositionChange: (index) {
                          print('currentposition: $index');
                          CurrentPosition = index;
                          if (index != 0) {
                            setState(() {
                              shopProductDataModel.shopProducts = null;
                              shopProductDataModel.status = null;
                            });
                            GetShopProdutcs(TabCategories!, index);
                          } else {
                            setState(() {
                              shopDetailsDataModel.shopProducts =
                                  shopDetailsDataModel.shopProducts;
                            });
                          }
                        },
                        onScroll: (position) => print('$position'),
                      ),
                    )
                  ],
                ),
              )
            ]))
          ],
        );
      } else {
        return Container();
      }
    } else {
      return MyProgressBar();
    }
  }

  Future<void> GetShopDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_id] = widget.shop_id;
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[shop_category_id] = widget.shop_cat_id;
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(PRODUCTS, data: Params);
    setState(() {
      shopDetailsDataModel = ShopDetailsDataModel.fromJson(response.data);
      IsBottomCartShow = shopDetailsDataModel.shopDetails!.isCart;
      print("responseresponseresponse${response.data.toString()}");
      if (shopDetailsDataModel.status != true) {
        ShowToast(shopDetailsDataModel.message.toString(), context);
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      for (var i = 0; i < shopDetailsDataModel.categories!.length; i++) {
        if (shopDetailsDataModel.categories![i].categoryName!.toLowerCase() ==
            widget.product_name.toLowerCase()) {
          setState(() {
            CurrentPosition = i + 1;
          });
          break;
        }
      }
    });
  }

  Widget TabViewContainer(List<Categories> tabCategories, int index) {
    if (CurrentPosition == index) {
      if (index == 0) {
        List<ShopProducts>? shopProductsList =
            shopDetailsDataModel.shopProducts;
        return Container(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: CommanListview(shopProductsList!),
          ),
        );
      } else {
        return OtherTabData(tabCategories, index);
      }
    } else {
      return MyProgressBar();
    }
  }

  Widget OtherTabData(List<Categories> tabCategories, int index) {
    if (shopProductDataModel.shopProducts != null &&
        shopProductDataModel.status != false) {
      List<ShopProducts>? shopProductsList = shopProductDataModel.shopProducts;
      return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: CommanListview(shopProductsList!),
        ),
      );
    } else {
      return Container(
        child: MyProgressBar(),
      );
    }
  }

  Future<void> GetShopProdutcs(
      List<Categories> tabCategories, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_id] = widget.shop_id;
    Params[category_id] = tabCategories[index].categoryId;
    Params[device_id] = prefs.getString(DEVICE_ID);

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(CATEGORY_PRODUCTS, data: Params);
    setState(() {
      shopProductDataModel = ShopProductDataModel.fromJson(response.data);
      print("responseresponseresponse${response.data.toString()}");
      if (shopProductDataModel.status != true) {
        ShowToast(shopProductDataModel.message.toString(), context);
      }
    });
  }

  Widget CommanListview(List<ShopProducts> shopProductsList) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.only(
            bottom: shopDetailsDataModel.coupons!.isNotEmpty ? 130 : 70),
        itemCount: shopProductsList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: AnimationTime),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: shopProductsList[index]
                                      .productImage
                                      .toString(),
                                  placeholder: (context, url) => Image.asset(
                                      imagePath + "no_image_placeholder.png",
                                      fit: BoxFit.cover,
                                      width: double.maxFinite),
                                ),
                              ),
                              Positioned(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    child: Image.asset(
                                        shopProductsList[index].variety == 1
                                            ? "${imagePath}veg.png"
                                            : "${imagePath}nonveg.png"),
                                  ),
                                ),
                                right: 0,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                shopProductsList[index].productName.toString(),
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: Inter_bold,
                                    color: blackColor),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                shopProductsList[index].description.toString(),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Poppinsmedium,
                                    color: greyColor),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "₹" +
                                    shopProductsList[index]
                                        .variants![0]
                                        .actualPrice
                                        .toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: Segoe_ui_bold,
                                    color: mainColor),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                    Column(
                      children: [
                        Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side:
                                  const BorderSide(color: mainColor, width: 1),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3, top: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    splashColor: greyColor,
                                    onTap: () {
                                      if (shopProductsList[index]
                                              .variants![0]
                                              .inCart !=
                                          0) {
                                        AddOrRemoveCart(
                                            shopProductsList[index]
                                                .variants![0]
                                                .id
                                                .toString(),
                                            "-1",
                                            []);
                                      }
                                    },
                                    child: Visibility(
                                      maintainState: true,
                                      maintainAnimation: true,
                                      maintainSize: true,
                                      visible: shopProductsList[index]
                                                  .variants![0]
                                                  .inCart ==
                                              0
                                          ? false
                                          : true,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.remove_rounded,
                                          color: mainColor,
                                          size: 20,
                                        ),
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    shopProductsList[index]
                                                .variants![0]
                                                .inCart ==
                                            0
                                        ? "Add"
                                        : shopProductsList[index]
                                            .variants![0]
                                            .cartCount
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: Poppinsmedium,
                                        color: blackColor),
                                  ),
                                  InkWell(
                                    splashColor: greyColor2,
                                    onTap: () {
                                      if (shopProductsList[index]
                                              .canCustomize !=
                                          1) {
                                        AddOrRemoveCart(
                                            shopProductsList[index]
                                                .variants![0]
                                                .id
                                                .toString(),
                                            "1",
                                            []);
                                      } else {
                                        ToppingBottomSheetMenu(
                                            shopProductsList[index], "1");
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: mainColor,
                                        size: 20,
                                      ),
                                      width: 30,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        Visibility(
                          visible: shopProductsList[index].canCustomize == 1
                              ? true
                              : false,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              Customizable,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: Poppinsmedium,
                                  color: blackColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
            ),
          );
        },
      ),
    );
  }

  Future<void> AddOrRemoveCart(
      String Product_id, String quanty, List<dynamic> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[id] = Product_id;
    Params[quantity] = quanty;
    Params[device_id] = prefs.getString(DEVICE_ID);
    if (list.isEmpty) {
      Params[toppings] = [];
    } else {
      Params[toppings] = list;
    }

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(MANAGE_PRODUCT, data: Params);
    print("responseresponseresponse${response.data.toString()}");
    if (response.data[refresh]) {
      _modalBottomSheetMenu(Product_id, quanty);
    } else {
      ShowToast(response.data[message].toString(), context);
      print("CurrentPositionCurrentPosition${CurrentPosition.toString()}");
      if (response.data[status]) {
        setState(() {
          if (response.data[quantity] != null && response.data[quantity] != 0) {
            IsBottomCartShow = true;
          } else {
            IsBottomCartShow = false;
          }
        });
      }
      if (CurrentPosition != 0) {
        GetShopProdutcs(TabCategories!, CurrentPosition);
      } else {
        GetRecommendedData();
      }
    }
  }

  void _modalBottomSheetMenu(String Product_id, String quanty) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return ClearCartBottomDialog(
            Positivepress: () => RefreshCart(Product_id, quanty),
            Nagetivepress: () {},
          );
        });
  }

  Future<void> RefreshCart(String Product_id, String quanty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[id] = Product_id;
    Params[quantity] = quanty;
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[toppings] = [];
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(REFRESH_CART, data: Params);
    print("RefreshCartRefreshCartResponse${response.data.toString()}");
    ShowToast(response.data[message].toString(), context);
    if (response.data[status]) {
      setState(() {
        if (response.data[quantity] != null && response.data[quantity] != 0) {
          IsBottomCartShow = true;
        } else {
          IsBottomCartShow = false;
        }
      });
    }
    Navigator.pop(context);
    if (CurrentPosition != 0) {
      GetShopProdutcs(TabCategories!, CurrentPosition);
    } else {
      GetRecommendedData();
    }
  }

  Future<void> GetRecommendedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[shop_id] = widget.shop_id;
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[shop_category_id] = widget.shop_cat_id;
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(PRODUCTS, data: Params);
    setState(() {
      shopDetailsDataModel.shopProducts =
          ShopDetailsDataModel.fromJson(response.data).shopProducts;
    });
  }

  void ToppingBottomSheetMenu(ShopProducts shopProductsList, String quanty) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        builder: (builder) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 80,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Image.asset(
                                    shopProductsList.variety == 1
                                        ? "${imagePath}veg.png"
                                        : "${imagePath}nonveg.png",
                                    width: 15,
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    shopProductsList.productName.toString(),
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: Segoe_ui_bold,
                                        color: blackColor),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                imagePath + "ic_topping_close.png",
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.maxFinite,
                          height: 0.5,
                          color: greyColor2,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MainTappingView(shopProductsList),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                decoration: BoxDecoration(
                    color: mainColor, borderRadius: BorderRadius.circular(7)),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      Total + " " + RUPPEE,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Segoe_ui_semibold,
                          color: whiteColor),
                    )),
                    GestureDetector(
                      onTap: () {
                        print("QtyIdQtyIdQtyId $QtyId");
                        print(
                            "TappingIdTappingIdTappingId ${TappingId.toString()}");
                        AddOrRemoveCart(QtyId, "1", TappingId);
                        Navigator.pop(context);
                      },
                      child: Text(
                        ADDITEMS,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoe_ui_semibold,
                            color: whiteColor),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget CouponListview() {
    print("CuponsList" + shopDetailsDataModel.coupons!.length.toString());
    if (shopDetailsDataModel.coupons!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: shopDetailsDataModel.coupons!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: AnimationTime),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                          child: InkWell(
                        onTap: () {
                          ShowLongToast(
                              shopDetailsDataModel
                                      .coupons![index].couponDescription
                                      .toString() +
                                  "  (Coupon copied)",
                              context);
                          Clipboard.setData(ClipboardData(
                              text: shopDetailsDataModel
                                  .coupons![index].couponCode
                                  .toString()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: index != 0 ? 10 : 0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: 180,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        imagePath + "coupon_bg.png",
                                        width: 28,
                                        height: 28,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              shopDetailsDataModel
                                                  .coupons![index]
                                                  .couponDescription
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.0,
                                                  fontFamily: Segoe_ui_semibold,
                                                  color: blackColor),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            FittedBox(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "use code ",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        height: 1.0,
                                                        fontFamily:
                                                            Segoe_ui_semibold,
                                                        color: blackColor),
                                                  ),
                                                  Text(
                                                    shopDetailsDataModel
                                                        .coupons![index]
                                                        .couponCode
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        height: 1.0,
                                                        fontFamily:
                                                            Segoe_ui_semibold,
                                                        color: blackColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
