import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/models/ShopDetailsDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../res/ResColor.dart';
import '../../res/ResString.dart';
import '../../utils/LocalStorageName.dart';
import '../../utils/Utils.dart';
import '../search/GlobalSearchScreen.dart';

class ShopDetailsHeader extends StatefulWidget {
  final ShopDetailsDataModel shopDetailsDataModel;
  final String shop_id, shop_cat_id;
  bool? IsFavorite;
  VoidCallback likebuttonclick;

  ShopDetailsHeader(this.shopDetailsDataModel, this.shop_id, this.shop_cat_id,
      this.IsFavorite, this.likebuttonclick);

  @override
  State<ShopDetailsHeader> createState() => _ShopDetailsHeaderState();
}

class _ShopDetailsHeaderState extends State<ShopDetailsHeader> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SliverList(
        delegate: SliverChildListDelegate([
      Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.shopDetailsDataModel.shopDetails!.shopImage
                      .toString(),
                  placeholder: (context, url) => Image.asset(
                      imagePath + "no_image_placeholder.png",
                      fit: BoxFit.cover,
                      width: double.maxFinite),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GlobalSearchScreen(
                                                    widget.shop_id,
                                                    widget.shop_cat_id)),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: whiteColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(Icons.search,
                                            size: 18, color: mainColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
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
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            child: Container(
                              color: widget.shopDetailsDataModel.shopDetails!
                                          .shop_isopened ==
                                      true
                                  ? mainColor
                                  : redColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: ShopTag(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.shopDetailsDataModel.shopDetails!.shopName
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
                            widget.shopDetailsDataModel.shopDetails!.shopAddress
                                .toString(),
                            style: TextStyle(
                              color: lightWhiteColor,
                              fontSize: 13.0,
                              fontFamily: Segoe_ui_semibold,
                            ),
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
    ]));
  }

  Widget ShopTag() {
    String ShopStatus;
    if (widget.shopDetailsDataModel.shopDetails!.shop_isopened == true) {
      ShopStatus = "Open";
    } else {
      ShopStatus = "Close";
    }
    return Text(
      ShopStatus,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
          fontSize: 12, height: 1, fontFamily: Segoeui, color: whiteColor),
    );
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
      widget.likebuttonclick();
      widget.IsFavorite = response.data["is_wishlist"];
      print("responseresponseresponse${response.data.toString()}");
      if (response.data[status] != true) {
        ShowToast(response.data[message].toString(), context);
      }
    });
  }
}
