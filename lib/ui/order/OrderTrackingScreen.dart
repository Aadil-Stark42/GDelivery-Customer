import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/models/OrderDetailsDataModel.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/MyProgressBar.dart';
import '../../uicomponents/RoundedBorderButton.dart';
import '../../uicomponents/progress_button.dart';
import '../../utils/Utils.dart';

class MyOrderTrackingScreen extends StatefulWidget {
  final String orderid;
  final ValueSetter<int> deletedIndex;

  final int ThisIndex;

  MyOrderTrackingScreen(this.orderid, this.ThisIndex, this.deletedIndex);

  @override
  MyOrderTrackingScreenState createState() => MyOrderTrackingScreenState();
}

class MyOrderTrackingScreenState extends State<MyOrderTrackingScreen> {
  OrderDetailsDataModel _orderDetailsDataModel = OrderDetailsDataModel();

  @override
  void initState() {
    super.initState();
    GetOrderDetails();
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
              elevation: 2,
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
                    child: Image.asset(imagePath + "back_arrow.png",
                        height: 25, width: 25),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    OrderDetailss,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Inter_bold,
                        color: blackColor),
                  ),
                ],
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([OrderDetailsView()]))
          ],
        ),
      ),
    );
  }

  Future<void> GetOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[order_id] = widget.orderid;
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(TRACK_ORDER, data: Params);
    print("GetOrderDetailsRESPONSEE${response.data.toString()}");
    setState(() {
      _orderDetailsDataModel = OrderDetailsDataModel.fromJson(response.data);
    });
  }

  Widget OrderDetailsView() {
    Size size = MediaQuery.of(context).size;
    if (_orderDetailsDataModel.status != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: SizedBox(
                    height: 90,
                    width: 90,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        _orderDetailsDataModel.shopDetails!.shopImage
                            .toString(),
                      ),
                      placeholder: AssetImage("${imagePath}ic_logo.png"),
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
                        _orderDetailsDataModel.shopDetails!.shopName.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Inter_bold,
                            color: blackColor),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            _orderDetailsDataModel.shopDetails!.shopStreet
                                .toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: Poppinsmedium,
                                color: greyColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: double.maxFinite,
              height: 0.5,
              color: greyColor2,
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OrderStatus,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: blackColor),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          child: CircleAvatar(
                            backgroundColor: _orderDetailsDataModel
                                        .timeDetails!.confirmedAt ==
                                    null
                                ? whiteColor
                                : mainColor,
                            child: Icon(
                              Icons.circle_outlined,
                              color: _orderDetailsDataModel
                                          .timeDetails!.confirmedAt ==
                                      null
                                  ? greyColor
                                  : mainColor,
                              size: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 17, left: 9),
                          child: Container(
                            width: 1,
                            height: 60,
                            color: greyColor,
                          ),
                        ),
                        //Second

                        Padding(
                          padding: const EdgeInsets.only(top: 73.5),
                          child: Container(
                            width: 20,
                            height: 20,
                            child: CircleAvatar(
                              backgroundColor: _orderDetailsDataModel
                                          .timeDetails!.pickedAt ==
                                      null
                                  ? whiteColor
                                  : mainColor,
                              child: Icon(
                                Icons.circle_outlined,
                                color: _orderDetailsDataModel
                                            .timeDetails!.pickedAt ==
                                        null
                                    ? greyColor
                                    : mainColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 91.5, left: 8.5),
                          child: Container(
                            width: 1,
                            height: 60,
                            color: greyColor,
                          ),
                        ),

                        //Third
                        Padding(
                          padding: const EdgeInsets.only(top: 148.5),
                          child: Container(
                            width: 20,
                            height: 20,
                            child: CircleAvatar(
                              backgroundColor: _orderDetailsDataModel
                                          .timeDetails!.deliveredAt ==
                                      null
                                  ? whiteColor
                                  : mainColor,
                              child: Icon(
                                Icons.circle_outlined,
                                color: _orderDetailsDataModel
                                            .timeDetails!.deliveredAt ==
                                        null
                                    ? greyColor
                                    : mainColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          OrderConfirmed,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: Segoe_ui_semibold,
                              color: blackColor),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          _orderDetailsDataModel.timeDetails!.confirmedAt
                              .toString(),
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: Segoe_ui_semibold,
                              color: greyColor),
                        ),

                        //Second
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          PickedUpByDelivery,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: Segoe_ui_semibold,
                              color: _orderDetailsDataModel
                                          .timeDetails!.pickedAt ==
                                      null
                                  ? greyColor
                                  : blackColor),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          _orderDetailsDataModel.timeDetails!.pickedAt == null
                              ? "-"
                              : _orderDetailsDataModel.timeDetails!.pickedAt
                                  .toString(),
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: Segoe_ui_semibold,
                              color: greyColor),
                        ),
                        //Third
                        SizedBox(
                          height: 35,
                        ),
                        Text(
                          Delivered,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: Segoe_ui_semibold,
                              color: _orderDetailsDataModel
                                          .timeDetails!.deliveredAt ==
                                      null
                                  ? greyColor
                                  : blackColor),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          _orderDetailsDataModel.timeDetails!.deliveredAt ==
                                  null
                              ? "-"
                              : _orderDetailsDataModel.timeDetails!.deliveredAt
                                  .toString(),
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: Segoe_ui_semibold,
                              color: greyColor),
                        )
                      ],
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                HandleTimer(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  YourOrders,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: blackColor),
                ),
                SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _orderDetailsDataModel.items!.length,
                  itemBuilder: (context, index) {
                    final itemdata = _orderDetailsDataModel.items![index];
                    return Row(
                      children: [
                        Expanded(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              child: Image.asset(
                                itemdata.variety == 1
                                    ? "${imagePath}veg.png"
                                    : "${imagePath}nonveg.png",
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemdata.productName.toString() +
                                        " x " +
                                        itemdata.quantity.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: Segoe_ui_semibold,
                                      fontSize: 14,
                                      height: 1.0,
                                      color: greyColor,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                        Row(
                          children: [
                            Text(
                              "₹${itemdata.amount.toString()}",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: Segoe_ui_semibold,
                                  color: greyColor),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                        //Farzi
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                /*  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TotalFoodCost,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.subTotal}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          CouponDiscount,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.couponDiscount}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GST " + widget.GstPer + "%",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.gstPrice}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          PackingCharges,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.packingCharge}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DeliveryChargesTag,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        ),
                        Text(
                          "(" +
                              _orderSummaryDataModel.priceDetails!.distance_km
                                  .toString() +
                              ") " +
                              "₹${_orderSummaryDataModel.priceDetails!.deliveryCharge}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: GreyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          GrandTotal,
                          style: TextStyle(
                            fontFamily: Segoe_ui_bold,
                            fontSize: 18,
                            height: 1.0,
                            color: BlackColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.total}",
                          style: TextStyle(
                            fontFamily: Segoe_ui_bold,
                            fontSize: 18,
                            height: 1.0,
                            color: BlackColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Inclusivecharges,
                      style: TextStyle(
                        fontFamily: Poppinsmedium,
                        fontSize: 10,
                        height: 1.0,
                        color: GreyColor,
                      ),
                    ),
                  ],
                ),*/
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          SubTotal,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: greyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderDetailsDataModel.orderDetails!.subTotal}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: greyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          CouponDiscount,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: greyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderDetailsDataModel.orderDetails!.couponDiscount}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: greyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DeliveryChargesTag,
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 12,
                            height: 1.0,
                            color: greyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderDetailsDataModel.orderDetails!.deliveryCharge}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: greyColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          GrandTotal,
                          style: TextStyle(
                            fontFamily: Segoe_ui_bold,
                            fontSize: 18,
                            height: 1.0,
                            color: blackColor,
                          ),
                        ),
                        Text(
                          "₹${_orderDetailsDataModel.orderDetails!.total}",
                          style: TextStyle(
                            fontFamily: Segoe_ui_bold,
                            fontSize: 18,
                            height: 1.0,
                            color: blackColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      DeliveryChargesmaybeApplicable,
                      style: TextStyle(
                        fontFamily: Poppinsmedium,
                        fontSize: 10,
                        height: 1.0,
                        color: greyColor,
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
                  margin: EdgeInsets.symmetric(horizontal: 5),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  OrderDetailss,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: blackColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        OrderConfirmed,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: blackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        _orderDetailsDataModel.orderDetails!.orderNumber
                            .toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: greyColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        Address,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: blackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        _orderDetailsDataModel.orderDetails!.address.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: greyColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        Payment,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: blackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        _orderDetailsDataModel.orderDetails!.paymentType
                                    .toString() ==
                                "0"
                            ? CashOnDelivery
                            : OnlinePayment,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: greyColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        DeliveryWithin,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: blackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        _orderDetailsDataModel.orderDetails!.isScheduled == 1
                            ? _orderDetailsDataModel.orderDetails!.estimatedTime
                                    .toString() +
                                " Min"
                            : EstimateTime,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: greyColor),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.7),
        child: MyProgressBar(),
      );
    }
  }

  Widget HandleTimer() {
    if (_orderDetailsDataModel.orderDetails!.canCancel == true) {
      int totalSeconds = _orderDetailsDataModel.orderDetails!.timeLeftMin! * 60;
      totalSeconds = totalSeconds +
          _orderDetailsDataModel.orderDetails!.timeLeftSec!.toInt();
      return Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 0.5,
            color: greyColor2,
            margin: EdgeInsets.symmetric(horizontal: 5),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TweenAnimationBuilder<Duration>(
                    duration: Duration(seconds: totalSeconds),
                    tween: Tween(
                        begin: Duration(seconds: totalSeconds),
                        end: Duration.zero),
                    onEnd: () {
                      setState(() {
                        _orderDetailsDataModel.orderDetails!.canCancel = false;
                      });
                    },
                    builder:
                        (BuildContext context, Duration value, Widget? child) {
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
                            color: greyColor),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: RoundedBorderButton(
                  txt: CancelOrder,
                  txtSize: 13,
                  CornerReduis: 7,
                  BorderWidth: 0.8,
                  BackgroundColor: whiteColor,
                  ForgroundColor: mainColor,
                  PaddingLeft: 15,
                  PaddingRight: 15,
                  PaddingTop: 7,
                  PaddingBottom: 7,
                  press: () {
                    CancelOrderDialog();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.maxFinite,
            height: 0.5,
            color: greyColor2,
            margin: EdgeInsets.symmetric(horizontal: 5),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void CancelOrderDialog() {
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
                                  _orderDetailsDataModel.shopDetails!.shopImage
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
                                  _orderDetailsDataModel.shopDetails!.shopName
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
                                  _orderDetailsDataModel.shopDetails!.shopStreet
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
                              "Items",
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
                              itemCount: _orderDetailsDataModel.items!.length,
                              itemBuilder: (context, inerindex) {
                                final item = _orderDetailsDataModel
                                    .items![inerindex].productName;
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
                                  _orderDetailsDataModel.orderDetails!.total
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
                              _orderDetailsDataModel.orderDetails!.orderId
                                  .toString(),
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

  Future<void> CancelOrderApi(String orderid, ButtonState buttonState) async {
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
      CancelAbleOrderResoanDialog();
    }
  }

  void CancelAbleOrderResoanDialog() {
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
                            _orderDetailsDataModel.orderDetails!.orderId
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
                                    _orderDetailsDataModel.orderDetails!.orderId
                                        .toString(),
                                    buttonState,
                                    reasons);
                              } else {
                                setState(() {
                                  widget.deletedIndex(widget.ThisIndex);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
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

  Future<void> CanceledReasonNote(
      String orderid, ButtonState buttonState, String reasons) async {
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
    setState(() {
      buttonState = ButtonState.normal;
    });
    ShowToast(response.data[message], context);
    setState(() {
      widget.deletedIndex(widget.ThisIndex);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
