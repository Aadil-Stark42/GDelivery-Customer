import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/models/OrdersListDataModel.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:gdeliverycustomer/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../animationlist/src/animation_configuration.dart';
import '../../../animationlist/src/fade_in_animation.dart';
import '../../../animationlist/src/slide_animation.dart';
import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/MyProgressBar.dart';
import '../../uicomponents/RoundedBorderButton.dart';
import '../../uicomponents/progress_button.dart';
import 'OrderTrackingScreen.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  MyOrdersScreenState createState() => MyOrdersScreenState();
}

class MyOrdersScreenState extends State<MyOrdersScreen> {
  OrdersListDataModel ordersListDataModel = OrdersListDataModel();

  @override
  void initState() {
    super.initState();
    GetMyOrders();
  }

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    width: 15,
                  ),
                  Text(
                    MyOrders,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 17,
                        height: 1.0,
                        fontFamily: Segoe_ui_bold,
                        color: darkMainColor2),
                  ),
                ],
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([OrderListDataView()]))
          ],
        ),
      ),
    );
  }

  Future<void> GetMyOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.get(MY_ORDERS);
    print("GetMyOrdersRESPONSE${response.data.toString()}");
    setState(() {
      ordersListDataModel = OrdersListDataModel.fromJson(response.data);
    });
  }

  Widget OrderListDataView() {
    Size size = MediaQuery.of(context).size;
    if (ordersListDataModel.orders != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: ordersListDataModel.orders!.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: AnimationTime),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                    child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: greyColor10, width: 1),
                      borderRadius: BorderRadius.circular(25)),
                  margin: EdgeInsets.only(
                      top: index == 0 ? 20 : 30, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 12, right: 12, bottom: 12, top: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    ordersListDataModel
                                        .orders![index].shopDetails!.shopImage
                                        .toString()
                                        .toString(),
                                  ),
                                  placeholder:
                                      AssetImage("${imagePath}ic_logo.png"),
                                ),
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
                                    ordersListDataModel
                                        .orders![index].shopDetails!.shopName
                                        .toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: Segoe_ui_semibold,
                                        color: blackColor),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    ordersListDataModel
                                        .orders![index].shopDetails!.shopStreet
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: Segoeui,
                                        color: greyColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 1,
                        color: greyColor10,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Items,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: Segoeui,
                                        color: greyColor11),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: ordersListDataModel
                                        .orders![index].productDetails!.length,
                                    itemBuilder: (context, inerindex) {
                                      final item = ordersListDataModel
                                          .orders![index]
                                          .productDetails![inerindex]
                                          .productName;
                                      return Text(
                                        item.toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: Segoeui,
                                            color: mainColor),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TotalAmount,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: Segoeui,
                                      color: greyColor11),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  RUPPEE +
                                      ordersListDataModel
                                          .orders![index].totalAmount
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: Segoeui,
                                      color: mainColor),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              Orderedon,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: Segoeui,
                                  color: greyColor11),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              ordersListDataModel.orders![index].orderedAt
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: Segoeui,
                                  color: mainColor),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatusviewHandler(index),
                    ],
                  ),
                )),
              ),
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.7),
        child: MyProgressBar(),
      );
    }
  }

  Widget StatusviewHandler(int index) {
    print(
        "ordersListDataModel.orders![index].orderStatus ${ordersListDataModel.orders![index].orderStatus}");

    if (ordersListDataModel.orders![index].orderStatus == 1 ||
        ordersListDataModel.orders![index].orderStatus == 2 ||
        ordersListDataModel.orders![index].orderStatus == 5 ||
        ordersListDataModel.orders![index].orderStatus == 7) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.maxFinite, height: 0.5, color: greyColor12),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: CheckOrderTime(index)),
              Container(width: 0.5, height: 25, color: greyColor12),
              Expanded(
                  child: InkWell(
                onTap: () {
                  if (ordersListDataModel.orders![index].orderStatus != 7) {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) => MyOrderTrackingScreen(
                          ordersListDataModel.orders![index].orderId.toString(),
                          index, (DeletedIndex) {
                        setState(() {
                          ordersListDataModel
                              .orders![DeletedIndex].orderStatus = 0;
                          ordersListDataModel.orders![DeletedIndex].canCancel =
                              false;
                        });
                      }),
                    ));
                  }
                },
                child: Center(
                  child: Text(
                    ordersListDataModel.orders![index].orderStatus == 7
                        ? WaitingForConfirmation
                        : TrackMyOrder,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Poppinsmedium,
                        color: mainColor),
                  ),
                ),
              ))
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      );
    } else if (ordersListDataModel.orders![index].orderStatus == 6 ||
        ordersListDataModel.orders![index].orderStatus == 0 ||
        ordersListDataModel.orders![index].orderStatus == 4) {
      String StatusText = ordersListDataModel.orders![index].orderStatus == 0
          ? OrderCancelled
          : ordersListDataModel.orders![index].orderStatus == 4
              ? TrackMyOrder
              : OrderRejectedByVendor;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.maxFinite, height: 0.5, color: greyColor12),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              if (ordersListDataModel.orders![index].orderStatus == 4) {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                  builder: (context) => MyOrderTrackingScreen(
                      ordersListDataModel.orders![index].orderId.toString(),
                      index, (DeletedIndex) {
                    setState(() {
                      ordersListDataModel.orders![DeletedIndex].orderStatus = 0;
                      ordersListDataModel.orders![DeletedIndex].canCancel =
                          false;
                    });
                  }),
                ));
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  StatusText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: Poppinsmedium,
                      color: ordersListDataModel.orders![index].orderStatus == 4
                          ? mainColor
                          : greyColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      );
    } else if (ordersListDataModel.orders![index].orderStatus == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.maxFinite, height: 0.5, color: greyColor12),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  RatingDeliveryBoyDialog(
                      ordersListDataModel.orders![index].orderId.toString());
                },
                child: Center(
                  child: Text(
                    RateDeliveryBoy,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Poppinsmedium,
                        color: mainColor),
                  ),
                ),
              )),
              Container(width: 0.5, height: 25, color: greyColor12),
              Expanded(
                  child: InkWell(
                onTap: () {
                  RepeatOrders(
                      ordersListDataModel.orders![index].orderId.toString());
                },
                child: Center(
                  child: Text(
                    RepeatOrder,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Poppinsmedium,
                        color: mainColor),
                  ),
                ),
              ))
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget CheckOrderTime(indexx) {
    if (ordersListDataModel.orders![indexx].canCancel == true) {
      int totalSeconds = ordersListDataModel.orders![indexx].timeLeftMin! * 60;
      totalSeconds = totalSeconds +
          ordersListDataModel.orders![indexx].timeLeftSec!.toInt();

      return InkWell(
        onTap: () {
          CancelOrderDialog(indexx);
        },
        child: Column(
          children: [
            Text(
              CancelOrder,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12, fontFamily: Poppinsmedium, color: mainColor),
            ),
            TweenAnimationBuilder<Duration>(
                duration: Duration(seconds: totalSeconds),
                tween: Tween(
                    begin: Duration(seconds: totalSeconds), end: Duration.zero),
                onEnd: () {
                  setState(() {
                    ordersListDataModel.orders![indexx].canCancel = false;
                  });
                },
                builder: (BuildContext context, Duration value, Widget? child) {
                  final minutes = value.inMinutes;
                  final seconds = value.inSeconds % 60;
                  return Text(
                    "Time left " +
                        minutes.toString() +
                        ": " +
                        seconds.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Poppinsmedium,
                        color: mainColor),
                  );
                })
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void CancelOrderDialog(int index) {
    ButtonState buttonState = ButtonState.normal;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AreyouCancelOrder,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: Inter_bold,
                            color: redColor),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(80.0)),
                            child: SizedBox(
                              height: 70,
                              width: 70,
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  ordersListDataModel
                                      .orders![index].shopDetails!.shopImage
                                      .toString()
                                      .toString(),
                                ),
                                placeholder:
                                    AssetImage("${imagePath}ic_logo.png"),
                              ),
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
                                  ordersListDataModel
                                      .orders![index].shopDetails!.shopName
                                      .toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Inter_bold,
                                      color: blackColor),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  ordersListDataModel
                                      .orders![index].shopDetails!.shopStreet
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: Poppinsmedium,
                                      color: greyColor),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Items,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: Segoe_ui_bold,
                                  color: blackColor2),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: ordersListDataModel
                                  .orders![index].productDetails!.length,
                              itemBuilder: (context, inerindex) {
                                final item = ordersListDataModel.orders![index]
                                    .productDetails![inerindex].productName;
                                return Text(
                                  item.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: Segoe_ui_semibold,
                                      color: greyColor),
                                );
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              Orderedon,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: Segoe_ui_bold,
                                  color: blackColor2),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              ordersListDataModel.orders![index].orderedAt
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: Segoe_ui_semibold,
                                  color: greyColor),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              TotalAmount,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: Segoe_ui_bold,
                                  color: blackColor2),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              RUPPEE +
                                  ordersListDataModel.orders![index].totalAmount
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: Segoe_ui_semibold,
                                  color: greyColor),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ProgressButton(
                        child: Text(
                          CancelOrder,
                          style: TextStyle(
                            color: whiteColor,
                            fontFamily: Segoe_ui_semibold,
                            height: 1.1,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            buttonState = ButtonState.inProgress;
                          });
                          CancelOrderApi(
                              ordersListDataModel.orders![index].orderId
                                  .toString(),
                              index,
                              buttonState);
                        },
                        buttonState: buttonState,
                        backgroundColor: mainColor,
                        progressColor: whiteColor,
                        border_radius: Full_Rounded_Button_Corner,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<void> CancelOrderApi(
      String orderid, int index, ButtonState buttonState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    var Params = <String, dynamic>{};
    Params[order_id] = orderid;
    print("ParamsParamsParams${Params.toString()}");
    Response response;
    response = await ApiCalling.post(CANCEL_DELIVERY2, data: Params);
    setState(() {
      buttonState = ButtonState.normal;
    });
    ShowToast(response.data[message], context);
    if (response.data[status]) {
      CancelAbleOrderResoanDialog(index);
    }
  }

  void CancelAbleOrderResoanDialog(int index) {
    ButtonState buttonState = ButtonState.normal;
    String reasons = "";
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      left: 15,
                      right: 15,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(80.0)),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  imagePath + "order_canceled.png",
                                ),
                                placeholder:
                                    AssetImage("${imagePath}ic_logo.png"),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                OrderCancelled,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: Inter_bold,
                                    color: blackColor),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Image.asset(
                                imagePath + "ic_green_tick.png",
                                height: 15,
                                width: 15,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            ordersListDataModel.orders![index].orderId
                                .toString(),
                            style: TextStyle(
                                color: blackColor,
                                fontFamily: Poppinsmedium,
                                height: 1.1,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              reasons = value;
                            },
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: greyColor, width: 0.5),
                                ),
                                hintStyle: TextStyle(color: greyColor2),
                                hintText:
                                    'Tell us reason of cancellation (optional)'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProgressButton(
                            child: Text(
                              Submit,
                              style: TextStyle(
                                color: whiteColor,
                                fontFamily: Segoe_ui_semibold,
                                height: 1.1,
                              ),
                            ),
                            onPressed: () {
                              if (reasons.isNotEmpty) {
                                setState(() {
                                  buttonState = ButtonState.inProgress;
                                });
                                CanceledReasonNote(
                                    ordersListDataModel.orders![index].orderId
                                        .toString(),
                                    index,
                                    buttonState,
                                    reasons);
                              } else {
                                Navigator.pop(context);
                                setState(() {
                                  GetMyOrders();
                                });
                              }
                            },
                            buttonState: buttonState,
                            backgroundColor: mainColor,
                            progressColor: whiteColor,
                            border_radius: Full_Rounded_Button_Corner,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<void> CanceledReasonNote(String orderid, int index,
      ButtonState buttonState, String reasons) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    var Params = <String, dynamic>{};
    Params[order_id] = orderid;
    Params[reason] = reasons;
    print("ParamsParamsParams${Params.toString()}");
    Response response;
    response = await ApiCalling.post(CANCEL_REASON, data: Params);
    print("CanceledReasonNoteRESPONSE${response.data.toString()}");
    Navigator.pop(context);
    setState(() {
      buttonState = ButtonState.normal;
    });
    ShowToast(response.data[message], context);
    if (response.data[status]) {
      setState(() {
        ordersListDataModel.orders![index].orderStatus = 0;
        ordersListDataModel.orders![index].canCancel = false;
      });
    }
  }

  void RatingDeliveryBoyDialog(String orderId) {
    double Rating_value = 0.0;
    String Comments = "";
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      left: 15,
                      right: 15,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            howdoyourate,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: Inter_bold,
                                color: blackColor),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            Yourfeedbackwill,
                            style: TextStyle(
                                color: greyColor,
                                fontFamily: Inter_regular,
                                height: 1.1,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        unratedColor: mainLightColor2,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: mainColor,
                        ),
                        onRatingUpdate: (rating) {
                          Rating_value = rating;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value) {
                          Comments = value;
                        },
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: greyColor, width: 0.5),
                            ),
                            hintStyle: TextStyle(color: greyColor2),
                            hintText: 'Leave a comment'),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundedBorderButton(
                              txt: Cancel,
                              txtSize: 12,
                              CornerReduis: Rounded_Button_Corner,
                              BorderWidth: 0.8,
                              BackgroundColor: whiteColor,
                              ForgroundColor: mainColor,
                              PaddingLeft: 10,
                              PaddingRight: 10,
                              PaddingTop: 14,
                              PaddingBottom: 14,
                              press: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ProgressButton(
                              child: Text(
                                Confirmss,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontFamily: Segoe_ui_semibold,
                                  height: 1.1,
                                ),
                              ),
                              onPressed: () {
                                RatingtoDeliveryBoy(
                                    Rating_value, Comments, orderId);
                              },
                              buttonState: ButtonState.normal,
                              backgroundColor: mainColor,
                              progressColor: whiteColor,
                              border_radius: Rounded_Button_Corner,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<void> RatingtoDeliveryBoy(
      double rating_value, String comments, String order_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    var Params = <String, dynamic>{};
    Params[order_ids] = order_id;
    Params[rating] = rating_value;
    Params[comment] = comments;
    print("ParamsParamsParams${Params.toString()}");
    Response response;
    response = await ApiCalling.post(CUSTOMER_DELIVERY_RATING, data: Params);
    print("CanceledReasonNoteRESPONSE${response.data.toString()}");
    ShowToast(response.data[message], context);
    Navigator.pop(context);
  }

  Future<void> RepeatOrders(String order_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    var Params = <String, dynamic>{};
    Params[order_ids] = order_id;
    print("ParamsParamsParams${Params.toString()}");
    Response response;
    response = await ApiCalling.post(ORDER_AGAIN, data: Params);
    print("CanceledReasonNoteRESPONSE${response.data.toString()}");
    ShowToast(response.data[message], context);
  }
}
