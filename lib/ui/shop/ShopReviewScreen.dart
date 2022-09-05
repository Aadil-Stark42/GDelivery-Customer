import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';
import '../../../utils/Utils.dart';
import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../models/ShopReviewDataModel.dart';
import '../../uicomponents/MyProgressBar.dart';

class ShopReviewScreen extends StatefulWidget {
  final String shop_id;
  late bool? IsFavorite = false;

  ShopReviewScreen(this.shop_id, this.IsFavorite);

  @override
  ShopReviewScreenState createState() => ShopReviewScreenState();
}

class ShopReviewScreenState extends State<ShopReviewScreen>
    with TickerProviderStateMixin {
  ShopReviewDataModel _shopReviewDataModel = ShopReviewDataModel();

  @override
  void initState() {
    super.initState();
    GetShopReviewDetails();
  }

  ButtonState buttonState = ButtonState.normal;
  String VersionName = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: ShopDetailsView(),
      ),
    );
  }

  Widget ShopDetailsView() {
    if (_shopReviewDataModel.status != null) {
      if (_shopReviewDataModel.status != false) {
        return CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          _shopReviewDataModel.shop!.bannerImage.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        child: Container(
                          color: transBlackColor,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const CircleAvatar(
                                          radius: 15,
                                          backgroundColor: whiteColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Icon(
                                              Icons.arrow_back_ios_rounded,
                                              size: 18,
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ManageWishList();
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: whiteColor,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                    widget.IsFavorite == true
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    size: 18,
                                                    color: mainColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _shopReviewDataModel.shop!.shopName
                                        .toString(),
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 17.0,
                                      fontFamily: Segoe_ui_semibold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _shopReviewDataModel.shop!.shopArea
                                        .toString(),
                                    style: TextStyle(
                                      color: lightWhiteColor,
                                      fontSize: 13.0,
                                      fontFamily: Segoe_ui_semibold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _shopReviewDataModel.shop!.rating
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: Segoe_ui_semibold,
                                                color: whiteColor),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: whiteColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 1,
                                        height: 12,
                                        color: whiteColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        _shopReviewDataModel.shop!.ratingCount
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: Segoe_ui_semibold,
                                            color: whiteColor),
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
                                            color: whiteColor),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: greyColor2,
                    ),
                    SizedBox(height: 5),
                    //add start
                    Container(
                      width: double.maxFinite,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.maxFinite,
                              child: Text(
                                LeaveRating,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 15.0,
                                  fontFamily: Inter_bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              unratedColor: mainLightColor2,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: mainColor,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                                GiveRating(rating);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: greyColor2,
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            RecentReviewss,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 16.0,
                              fontFamily: Inter_bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount:
                                _shopReviewDataModel.recentReviews!.length,
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
                                    padding: const EdgeInsets.only(top: 20),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: Image.asset(
                                                    imagePath +
                                                        "profile-user.png",
                                                    color: mainColor,
                                                  ),
                                                ),
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
                                                  _shopReviewDataModel
                                                      .recentReviews![index]
                                                      .username
                                                      .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: Inter_bold,
                                                      color: blackColor),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                RatingBar.builder(
                                                  initialRating:
                                                      _shopReviewDataModel
                                                          .recentReviews![index]
                                                          .rating!
                                                          .toDouble(),
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemSize: 15,
                                                  ignoreGestures: true,
                                                  unratedColor: mainLightColor2,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 1.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: mainColor,
                                                    size: 15,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                    /*-------*/
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

  Future<void> GetShopReviewDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_id] = widget.shop_id;
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(SINGLE_SHOP, data: Params);
    setState(() {
      _shopReviewDataModel = ShopReviewDataModel.fromJson(response.data);
      print("responseresponseresponse${response.data.toString()}");
      if (_shopReviewDataModel.status != true) {
        ShowToast(_shopReviewDataModel.message.toString(), context);
      }
    });
  }

  Future<void> GiveRating(double ratings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_id] = widget.shop_id;
    Params[rating] = ratings;
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(GIVE_RATING, data: Params);
    ShowToast(response.data[message], context);
    GetShopReviewDetails();
  }

  Future<void> ManageWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_id] = widget.shop_id;

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(MANAGE_WISHLIST, data: Params);

    setState(() {
      print("responseresponseresponse${response.data.toString()}");
      widget.IsFavorite = response.data["is_wishlist"];

      if (response.data[status] != true) {
        ShowToast(response.data[message].toString(), context);
      }
    });
  }
}
