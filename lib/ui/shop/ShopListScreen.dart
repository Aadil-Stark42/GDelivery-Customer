import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/models/ShopListDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/animation_limiter.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../models/CuisinesListDataModel.dart';
import '../../res/ResColor.dart';
import '../../res/ResString.dart';
import '../../uicomponents/AddtoCartView.dart';
import '../../uicomponents/MyProgressBar.dart';
import '../../uicomponents/RoundedBorderButton.dart';
import '../../utils/LocalStorageName.dart';
import '../../utils/Utils.dart';
import '../filter/CustomFilterSheetMenu.dart';
import '../search/GlobalSearchScreen.dart';
import 'ClearCartBottomDialog.dart';
import 'ShopDetailsScreen.dart';

class ShopListScreen extends StatefulWidget {
  final String Category_Id, Category_Name;
  final bool IsComeFromMainCat;

  ShopListScreen(this.Category_Id, this.Category_Name, this.IsComeFromMainCat);

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  double FilterButtonRedius = 18.0;
  ShopListDataModel shopListDataModel = ShopListDataModel();

  CuisinesListDataModel cuisinesListDataModel = CuisinesListDataModel();
  bool IsBottomCartShow = false;
  bool IsRatedClick = false,
      IsOpenNowClick = false,
      IsAtoZClick = false,
      IsZtoAClick = false;

  String dropdownvalue = 'Select';

  // List of items in our dropdown menu
  var items = [
    'Select',
    'Remove Filters',
    'Popularity',
    'Price: High - Low',
    'Price: Low - High',
    'Delivery time',
  ];

  @override
  void initState() {
    super.initState();
    GetShopList();
    GetShopFilterList();
  }

  @override
  Widget build(BuildContext context) {
    statusBarColor();
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              backgroundColor: whiteColor,
              floating: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(),
              elevation: 2,
              forceElevated: true,
              centerTitle: false,
              leading: null,
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(imagePath + "back_arrow.png",
                              height: 25, width: 25),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              widget.Category_Name,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Inter_bold,
                                  color: blackColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    GlobalSearchScreen("", widget.Category_Id)),
                          );
                        },
                        child: Image.asset(imagePath + "ic_search.png",
                            height: 20, width: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([ShopListDataView()]))
          ],
        ),
        floatingActionButton: HandleAddedtoCart(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
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

  Future<Response> GetShopList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[id] = widget.Category_Id;
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);

    print("GetShopListParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    if (widget.IsComeFromMainCat) {
      response = await ApiCalling.post(SHOPS, data: Params);
    } else {
      response = await ApiCalling.post(FEATURECAT, data: Params);
    }

    print("responseresponseresponse${response.data["products"].toString()}");
    setState(() {
      shopListDataModel = ShopListDataModel.fromJson(response.data);
    });
    if (response.data[status] != true) {
      ShowToast(response.data[message].toString(), context);
    }
    return response;
  }

  Future<Response> GetShopFilterList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.get(CUISINES);
    print(
        "GetShopFilterListresponseresponseresponse${response.data.toString()}");
    cuisinesListDataModel = CuisinesListDataModel.fromJson(response.data);
    return response;
  }

  Widget ShopListDataView() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              RoundedBorderButton(
                txt: Filter,
                txtSize: 13,
                CornerReduis: FilterButtonRedius,
                BorderWidth: 0.8,
                BackgroundColor: whiteColor,
                ForgroundColor: greyColor,
                PaddingLeft: 10,
                PaddingRight: 10,
                PaddingTop: 5,
                PaddingBottom: 5,
                press: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => CustomFilterSheetMenu(
                                cuisinesListDataModel, (FilterData) {
                              setState(() {
                                shopListDataModel.shops = null;
                              });
                              GetMultiFilter(FilterData);
                            }, () {
                              setState(() {
                                shopListDataModel.shops = null;
                              });
                              GetShopList();
                            })),
                  );
                },
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(FilterButtonRedius),
                  border: Border.all(
                      color: greyColor, style: BorderStyle.solid, width: 0.8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    borderRadius: BorderRadius.circular(FilterButtonRedius),
                    // Down Arrow Icon
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: greyColor,
                    ),
                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items,
                            style: TextStyle(
                                color: greyColor,
                                fontSize: 13,
                                fontFamily: Poppinsmedium)),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      dropdownvalue = newValue!;
                      IsRatedClick = false;
                      IsOpenNowClick = false;
                      IsAtoZClick = false;
                      IsZtoAClick = false;
                      setState(() {
                        shopListDataModel.shops = null;
                      });
                      if (newValue == "Remove Filters") {
                        GetShopList();
                      } else if (newValue == "Popularity") {
                        GetSingleFilter("1", "0");
                      } else if (newValue == "Price: High - Low") {
                        GetSingleFilter("2", "0");
                      } else if (newValue == "Price: Low - High") {
                        GetSingleFilter("3", "0");
                      } else if (newValue == "Delivery time") {
                        GetSingleFilter("4", "0");
                      }
                    },
                  ),
                ),
              ),
              /*   RoundedBorderButton(
                txt: items,
                txtSize: 13,
                CornerReduis: FilterButtonRedius,
                BorderWidth: 0.8,
                BackgroundColor: WhiteColor,
                ForgroundColor: GreyColor,
                PaddingLeft: 10,
                PaddingRight: 10,
                PaddingTop: 5,
                PaddingBottom: 5,
                press: () {},
              ),*/
              SizedBox(
                width: 10,
              ),
              RoundedBorderButton(
                txt: Rated4,
                txtSize: 13,
                CornerReduis: FilterButtonRedius,
                BorderWidth: 0.8,
                BackgroundColor: IsRatedClick == true ? mainColor : whiteColor,
                ForgroundColor: IsRatedClick == true ? whiteColor : greyColor,
                PaddingLeft: 10,
                PaddingRight: 10,
                PaddingTop: 5,
                PaddingBottom: 5,
                press: () {
                  setState(() {
                    shopListDataModel.shops = null;
                    IsOpenNowClick = false;
                    IsAtoZClick = false;
                    IsZtoAClick = false;
                    if (IsRatedClick) {
                      IsRatedClick = false;

                      GetShopList();
                    } else {
                      GetSingleFilter(RATING_FILTER_TYPE, "4");
                      IsRatedClick = true;
                    }
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              RoundedBorderButton(
                txt: OpenNow,
                txtSize: 13,
                CornerReduis: FilterButtonRedius,
                BorderWidth: 0.8,
                BackgroundColor:
                    IsOpenNowClick == true ? mainColor : whiteColor,
                ForgroundColor: IsOpenNowClick == true ? whiteColor : greyColor,
                PaddingLeft: 10,
                PaddingRight: 10,
                PaddingTop: 5,
                PaddingBottom: 5,
                press: () {
                  setState(() {
                    shopListDataModel.shops = null;
                    IsRatedClick = false;
                    IsAtoZClick = false;
                    IsZtoAClick = false;
                    if (IsOpenNowClick) {
                      IsOpenNowClick = false;
                      GetShopList();
                    } else {
                      GetSingleFilter(OPEN_NOW_FILTER_TYPE, "0");
                      IsOpenNowClick = true;
                    }
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              RoundedBorderButton(
                txt: AtoZ,
                txtSize: 13,
                CornerReduis: FilterButtonRedius,
                BorderWidth: 0.8,
                BackgroundColor: IsAtoZClick == true ? mainColor : whiteColor,
                ForgroundColor: IsAtoZClick == true ? whiteColor : greyColor,
                PaddingLeft: 10,
                PaddingRight: 10,
                PaddingTop: 5,
                PaddingBottom: 5,
                press: () {
                  setState(() {
                    shopListDataModel.shops = null;
                    IsRatedClick = false;
                    IsOpenNowClick = false;
                    IsZtoAClick = false;
                    if (IsAtoZClick) {
                      IsAtoZClick = false;
                      GetShopList();
                    } else {
                      GetSingleFilter(ATOZ_FILTER_TYPE, "0");
                      IsAtoZClick = true;
                    }
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
              RoundedBorderButton(
                txt: ZtoA,
                txtSize: 13,
                CornerReduis: FilterButtonRedius,
                BorderWidth: 0.8,
                BackgroundColor: IsZtoAClick == true ? mainColor : whiteColor,
                ForgroundColor: IsZtoAClick == true ? whiteColor : greyColor,
                PaddingLeft: 10,
                PaddingRight: 10,
                PaddingTop: 5,
                PaddingBottom: 5,
                press: () {
                  setState(() {
                    shopListDataModel.shops = null;
                    IsRatedClick = false;
                    IsOpenNowClick = false;
                    IsAtoZClick = false;
                    if (IsZtoAClick) {
                      IsZtoAClick = false;
                      GetShopList();
                    } else {
                      GetSingleFilter(ZTOA_FILTER_TYPE, "0");
                      IsZtoAClick = true;
                    }
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CommanListview(shopListDataModel.shops),
      ],
    );
  }

  Widget CommanListview(List<Shops>? mainshopList) {
    Size size = MediaQuery.of(context).size;
    if (mainshopList != null) {
      if (mainshopList.isNotEmpty) {
        List<Shops>? shopList1 = [];
        List<Shops>? shopList2 = [];
        mainshopList.forEach((element) {
          shopList2!.add(element);
        });
        print("shopList2shopList2shopList2 ${mainshopList.length}");
        if (mainshopList.length > 3) {
          for (var i = 0; i < 3; i++) {
            print("iiiiiiiiiiii ${i}");
            shopList1.add(shopList2[i]);
          }
          shopList2.removeAt(0);
          shopList2.removeAt(0);
          shopList2.removeAt(0);
        } else {
          shopList2 = [];
          shopList1 = mainshopList;
        }
        print("shopListshopListshopList ${mainshopList.length}");
        return Column(
          children: [
            AnimationLimiter(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: shopList1.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: AnimationTime),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                          child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => ShopDetailsScreen(
                                      shopList1![index].shopId.toString(),
                                      widget.Category_Id,
                                      widget.Category_Name,
                                      () {})),
                            );
                          },
                          child: Container(
                              width: double.maxFinite,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 5,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              topLeft: Radius.circular(15)),
                                          child: SizedBox(
                                            height: 250,
                                            width: double.maxFinite,
                                            child: FadeInImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                shopList1![index]
                                                    .shopImage
                                                    .toString(),
                                              ),
                                              placeholder: AssetImage(
                                                  "${imagePath}ic_logo.png"),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 10,
                                            child: shopList1[index]
                                                    .coupon_detail
                                                    .toString()
                                                    .isNotEmpty
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color: couponcolor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        5))),
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 3,
                                                        bottom: 3),
                                                    child: Text(
                                                      shopList1[index]
                                                          .coupon_detail
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontFamily:
                                                              Poppinsmedium,
                                                          color: whiteColor),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  )),
                                        Positioned(
                                            bottom: 10,
                                            right: 7,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.only(
                                                  left: 7,
                                                  right: 7,
                                                  top: 3,
                                                  bottom: 3),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.watch_later_outlined,
                                                    size: 11,
                                                    color: mainColor,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    shopList1[index]
                                                        .time
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        fontFamily: Inter_bold,
                                                        color: blackColor),
                                                  )
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Text(
                                                    shopList1[index]
                                                        .shopName
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: Inter_bold,
                                                        color: blackColor),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: greenColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 1,
                                                    bottom: 2),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      shopList1[index]
                                                          .rating
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontFamily:
                                                              Segoe_ui_semibold,
                                                          color: whiteColor),
                                                    ),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    Icon(
                                                      Icons.star_rounded,
                                                      size: 11,
                                                      color: whiteColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 10,
                                                      color: whiteColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      shopList1[index]
                                                          .ratingCount
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              Segoe_ui_semibold,
                                                          color: whiteColor),
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      "Reviews",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontFamily:
                                                              Segoe_ui_semibold,
                                                          color: whiteColor),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            shopList1[index]
                                                    .shopArea
                                                    .toString() +
                                                " " +
                                                shopList1[index]
                                                    .distance
                                                    .toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontFamily: Poppinsmedium,
                                                color: greyColor4),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            shopList1[index]
                                                .shop_openclose_dtl
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: Poppinsmedium,
                                                color: shopList1[index]
                                                            .iscoloured_blue ==
                                                        "true"
                                                    ? mainColor
                                                    : redColor),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      )),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GradListview(shopListDataModel.products),
            SizedBox(
              height: 15,
            ),
            if (shopList2.isNotEmpty)
              CommanListView2(shopList2)
            else
              Container()
          ],
        );
      } else {
        return Column(
          children: [
            SizedBox(
              height: size.height / 2.7,
            ),
            Text(
              NoDataFound,
              style: TextStyle(
                  fontSize: 16, fontFamily: Inter_bold, color: mainColor),
            )
          ],
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.5),
        child: MyProgressBar(),
      );
    }
  }

  Widget CommanListView2(List<Shops> shopList) {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: shopList.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: AnimationTime),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 15, right: 10, bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => ShopDetailsScreen(
                                shopList[index].shopId.toString(),
                                widget.Category_Id,
                                widget.Category_Name,
                                () {})),
                      );
                    },
                    child: Container(
                        width: double.maxFinite,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15)),
                                    child: SizedBox(
                                      height: 250,
                                      width: double.maxFinite,
                                      child: FadeInImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          shopList[index].shopImage.toString(),
                                        ),
                                        placeholder: AssetImage(
                                            "${imagePath}ic_logo.png"),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      child: shopList[index]
                                              .coupon_detail
                                              .toString()
                                              .isNotEmpty
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: couponcolor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5))),
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 3,
                                                  bottom: 3),
                                              child: Text(
                                                shopList[index]
                                                    .coupon_detail
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: Poppinsmedium,
                                                    color: whiteColor),
                                              ),
                                            )
                                          : Container(
                                              width: 0,
                                              height: 0,
                                            )),
                                  Positioned(
                                      bottom: 10,
                                      right: 7,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.only(
                                            left: 7,
                                            right: 7,
                                            top: 3,
                                            bottom: 3),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.watch_later_outlined,
                                              size: 11,
                                              color: mainColor,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              shopList[index].time.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  fontFamily: Inter_bold,
                                                  color: blackColor),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text(
                                              shopList[index]
                                                  .shopName
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: Inter_bold,
                                                  color: blackColor),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: greenColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 1,
                                              bottom: 2),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                shopList[index]
                                                    .rating
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily:
                                                        Segoe_ui_semibold,
                                                    color: whiteColor),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Icon(
                                                Icons.star_rounded,
                                                size: 11,
                                                color: whiteColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                width: 1,
                                                height: 10,
                                                color: whiteColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                shopList[index]
                                                    .ratingCount
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        Segoe_ui_semibold,
                                                    color: whiteColor),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                "Reviews",
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily:
                                                        Segoe_ui_semibold,
                                                    color: whiteColor),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      shopList[index].shopArea.toString() +
                                          " " +
                                          shopList[index].distance.toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontFamily: Poppinsmedium,
                                          color: greyColor4),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      shopList[index]
                                          .shop_openclose_dtl
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: Poppinsmedium,
                                          color:
                                              shopList[index].iscoloured_blue ==
                                                      "true"
                                                  ? mainColor
                                                  : redColor),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                )),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget GradListview(List<Products>? productList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            QuickGrab,
            maxLines: 1,
            style: TextStyle(
                fontSize: 18, fontFamily: Inter_bold, color: blackColor2),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 230,
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: productList!.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: AnimationTime),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 15),
                            child: Container(
                              width: 180,
                              height: 240,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  child: Image.asset(
                                                    productList[index]
                                                                .variety ==
                                                            1
                                                        ? "${imagePath}veg.png"
                                                        : "${imagePath}nonveg.png",
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    AddOrRemoveCart(
                                                        productList[index]
                                                            .variants![0]
                                                            .id
                                                            .toString(),
                                                        "1",
                                                        []);
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    child: Icon(
                                                      Icons.add_rounded,
                                                      color: mainColor,
                                                      size: 25,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: SizedBox(
                                                    height: 110,
                                                    width: 110,
                                                    child: FadeInImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        productList[index]
                                                            .productImage
                                                            .toString(),
                                                      ),
                                                      placeholder: AssetImage(
                                                          "${imagePath}ic_logo.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                productList[index]
                                                    .productName
                                                    .toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: Inter_bold,
                                                    color: blackColor2),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        RUPPEE +
                                                            productList[index]
                                                                .variants![0]
                                                                .price
                                                                .toString(),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                Inter_bold,
                                                            color: mainColor),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      HandleDiscountPrice(
                                                          productList, index)
                                                    ],
                                                  )),
                                                  GetPercantage(
                                                      productList, index)
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ))),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
    if (response.data[refresh]) {
      _modalBottomSheetMenu(Product_id, quanty);
    } else {
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
            Positivepress: () {
              RefreshCart(Product_id, quanty);
            },
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
  }

  Future GetSingleFilter(String filtertype, String ratings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_category_id] = widget.Category_Id;
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[filter_type] = filtertype;
    Params[rating] = ratings;
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(SORT, data: Params);
    print("GetSingleFilterresponseresponseresponse${response.toString()}");
    setState(() {
      shopListDataModel = ShopListDataModel.fromJson(response.data);
    });

    if (response.data[status] != true) {
      ShowToast(response.data[message].toString(), context);
    }
  }

  Future GetMultiFilter(Map<String, dynamic> filterData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[shop_category_id] = widget.Category_Id;
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);
    Params[sort] = filterData[SORT_ID].toString();
    Params[rating] = filterData[RATING_ID].toString();
    Params[price] = filterData[PRICING_ID].toString();
    Params[cuisine_ids] = filterData[SHOPS_ID];
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(MULTI_SORT, data: Params);
    print(
        "GetMultiFilterresponseresponseresponse${response.data["products"].toString()}");
    if (response.data[status] == true) {
      setState(() {
        shopListDataModel = ShopListDataModel.fromJson(response.data);
      });
    } else {
      ShowToast(response.data[message].toString(), context);
    }
  }

  Widget HandleDiscountPrice(List<Products> productList, int index) {
    if (double.parse(productList[index]
            .variants![0]
            .price
            .toString()
            .replaceAll(",", "")) !=
        double.parse(productList[index]
            .variants![0]
            .actualPrice
            .toString()
            .replaceAll(",", ""))) {
      return Flexible(
        child: Text(
          RUPPEE + productList[index].variants![0].actualPrice.toString(),
          maxLines: 1,
          style: TextStyle(
              fontSize: 11,
              fontFamily: Inter_medium,
              color: greyColor,
              decoration: TextDecoration.lineThrough,
              decorationThickness: 1.5),
        ),
      );
    } else {
      return Container();
    }
  }

  GetPercantage(List<Products> productList, int index) {
    if (double.parse(productList[index]
            .variants![0]
            .price
            .toString()
            .replaceAll(",", "")) !=
        double.parse(productList[index]
            .variants![0]
            .actualPrice
            .toString()
            .replaceAll(",", ""))) {
      var pers = 0.0;
      pers = 100 *
          (double.parse(productList[index]
                  .variants![0]
                  .actualPrice
                  .toString()
                  .replaceAll(",", "")) -
              double.parse(productList[index]
                  .variants![0]
                  .price
                  .toString()
                  .replaceAll(",", ""))) /
          double.parse(productList[index]
              .variants![0]
              .actualPrice
              .toString()
              .replaceAll(",", ""));
      var intprec = pers.toInt();
      return Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 7, right: 7, top: 2, bottom: 2),
        decoration: BoxDecoration(
            color: mainColor, borderRadius: BorderRadius.circular(15)),
        child: Text(
          intprec.toString() + "% OFF",
          maxLines: 1,
          style: TextStyle(
              fontSize: 10, fontFamily: Segoe_ui_bold, color: whiteColor),
        ),
      );
    } else {
      return Container();
    }
  }
}
/*  Container(
                            width: double.maxFinite,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: FadeInImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            shopList1![index]
                                                .shopImage
                                                .toString(),
                                          ),
                                          placeholder: AssetImage(
                                              "${IMAGE_PATH}ic_logo.png"),
                                        ),
                                      ),
                                      /*    Positioned(
                                        child: Container(
                                          color:
                                              shopList1[index].isOpened == true
                                                  ? MainColor
                                                  : RedColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              shopList1[index].isOpened == true
                                                  ? "Open"
                                                  : "Close",
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: Segoeui,
                                                  color: WhiteColor),
                                            ),
                                          ),
                                        ),
                                        left: 0,
                                      )*/
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        shopList1[index].shopName.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: Inter_bold,
                                            color: BlackColor),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          Text(
                                            shopList1[index]
                                                    .shopArea
                                                    .toString() +
                                                " " +
                                                shopList1[index]
                                                    .distance
                                                    .toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: Poppinsmedium,
                                                color: GreyColor),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.watch_later_outlined,
                                            size: 15,
                                            color: GreyColor,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            shopList1[index].time.toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: Poppinsmedium,
                                                color: GreyColor),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        shopList1[index]
                                            .shop_openclose_dtl
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: Poppinsmedium,
                                            color: shopList1[index]
                                                        .iscoloured_blue ==
                                                    "true"
                                                ? MainColor
                                                : RedColor),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      shopList1[index].coupons!.length != 0
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: couponcolor),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 3),
                                              child: Text(
                                                "Coupons available",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: Poppinsmedium,
                                                    color: WhiteColor),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                shopList1[index]
                                                    .rating
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        Segoe_ui_semibold,
                                                    color: MainColor),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Icon(
                                                Icons.star_rounded,
                                                size: 15,
                                                color: MainColor,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 1,
                                            height: 12,
                                            color: GreyColor2,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            shopList1[index]
                                                .ratingCount
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: Segoe_ui_semibold,
                                                color: GreyColor2),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Reviews",
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: Segoe_ui_semibold,
                                                color: GreyColor2),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),*/
