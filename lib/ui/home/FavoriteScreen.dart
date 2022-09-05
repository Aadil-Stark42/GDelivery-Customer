import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/uicomponents/MyProgressBar.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/animation_limiter.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../models/WishListDataModel.dart';
import '../../res/ResString.dart';
import '../../utils/Utils.dart';
import '../shop/ShopDetailsScreen.dart';
import 'AppMaintainanceScreen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  WishListDataModel wishListDataModel = WishListDataModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetWishList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              automaticallyImplyLeading: false,
              pinned: false,
              backgroundColor: whiteColor,
              floating: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(),
              elevation: 0,
              forceElevated: true,
              centerTitle: false,
              leading: null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      imagePath + "ic_back2.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Favorite,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Inter_bold,
                        color: darkMainColor2),
                  ),
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([FevoriteListDataView()]))
          ],
        ),
      ),
    );
  }

  Widget FevoriteListDataView() {
    Size size = MediaQuery.of(context).size;
    if (wishListDataModel.shops != null) {
      if (wishListDataModel.shops!.isNotEmpty) {
        return AnimationLimiter(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: wishListDataModel.shops!.length,
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
                        if (CHECKAPPSTATUS == STATUSNUMBER) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    AppMaintainanceScreen(true)),
                          );
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => ShopDetailsScreen(
                                        wishListDataModel.shops![index].shopId
                                            .toString(),
                                        "14",
                                        wishListDataModel.shops![index].shopName
                                            .toString(), () {
                                      GetWishList();
                                    })),
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      wishListDataModel.shops![index].shopImage
                                          .toString(),
                                    ),
                                    placeholder:
                                        AssetImage("${imagePath}ic_logo.png"),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          wishListDataModel
                                              .shops![index].shopName
                                              .toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: Inter_bold,
                                              color: blackColor),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        ManageWishList(
                                            wishListDataModel
                                                .shops![index].shopId
                                                .toString(),
                                            index);
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 7, 0),
                                        child: Icon(
                                          wishListDataModel.shops![index]
                                                      .isWishlist ==
                                                  true
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: mainColor,
                                          size: 22,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      wishListDataModel.shops![index].shopArea
                                              .toString() +
                                          " " +
                                          wishListDataModel
                                              .shops![index].distance
                                              .toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: Poppinsmedium,
                                          color: greyColor),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.watch_later_outlined,
                                      size: 15,
                                      color: greyColor,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      wishListDataModel.shops![index].time
                                          .toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: Poppinsmedium,
                                          color: greyColor),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Approx price for two person : " +
                                      wishListDataModel.shops![index].price
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: Poppinsmedium,
                                      color: greyColor),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          wishListDataModel.shops![index].rating
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: Segoe_ui_semibold,
                                              color: mainColor),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Icon(
                                          Icons.star_rounded,
                                          size: 15,
                                          color: mainColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 12,
                                      color: greyColor2,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      wishListDataModel
                                          .shops![index].ratingCount
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: Segoe_ui_semibold,
                                          color: greyColor2),
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
                                          color: greyColor2),
                                    )
                                  ],
                                )
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
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.7),
        child: MyProgressBar(),
      );
    }
  }

  Future<Response> GetWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);

    print("GetShopListParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(WISHLISTS, data: Params);
    print("responseresponseresponse${response.data.toString()}");
    setState(() {
      wishListDataModel = WishListDataModel.fromJson(response.data);
    });
    if (response.data[status] != true) {
      ShowToast(response.data[message].toString(), context);
    }
    return response;
  }

  Future<void> ManageWishList(String shopid, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[shop_id] = shopid;

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(MANAGE_WISHLIST, data: Params);
    setState(() {
      wishListDataModel.shops!.removeAt(index);
      print("responseresponseresponse${response.data.toString()}");
      if (response.data[status] != true) {
        ShowToast(response.data[message].toString(), context);
      }
    });
  }
}
