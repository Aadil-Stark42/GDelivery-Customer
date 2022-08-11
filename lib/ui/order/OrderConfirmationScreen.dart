import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/models/OrderDetailsDataModel.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/ui/home/HomeScreen.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/MyProgressBar.dart';
import '../../models/OrderConfirmDataModel.dart';
import '../../models/OrderSummaryDataModel.dart';
import '../../uicomponents/RoundedBorderButton.dart';
import '../../uicomponents/progress_button.dart';
import '../../uicomponents/rounded_button.dart';
import '../../utils/Utils.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final OrderConfirmDataModel orderConfirmDataModel;
  final String GstPer;
  final String distance_km;

  OrderConfirmationScreen(
      this.orderConfirmDataModel, this.GstPer, this.distance_km);

  @override
  OrderConfirmationScreenState createState() => OrderConfirmationScreenState();
}

class OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: WhiteColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              backgroundColor: WhiteColor,
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
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: Image.asset(imagePath + "back_arrow.png",
                        height: 25, width: 25),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    OrderConfirmed,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Inter_bold,
                        color: BlackColor),
                  ),
                ],
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([OrderDetailsView()]))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: RoundedButton(
          color: MainColor,
          text: CONTINUESHOPPING,
          corner_radius: Rounded_Button_Corner,
          press: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }

  Widget OrderDetailsView() {
    Size size = MediaQuery.of(context).size;
    if (widget.orderConfirmDataModel.status != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 80, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 180,
                child: OverflowBox(
                  minHeight: 240,
                  maxHeight: 240,
                  child: Lottie.asset(
                    imagePath + "order_confirmed_anim.json",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      OrderPlaced,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Inter_bold,
                          color: BlackColor),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Image.asset(
                      imagePath + "ic_green_tick.png",
                      height: 18,
                      width: 18,
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.orderConfirmDataModel.orderDetails!.orderId.toString(),
                  style: TextStyle(
                      color: BlackColor,
                      fontFamily: Poppinsmedium,
                      height: 1.1,
                      fontSize: 14),
                )
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Text(
              YourOrders,
              style: TextStyle(
                  fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
            ),
            SizedBox(
              height: 5,
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.orderConfirmDataModel.items!.length,
              itemBuilder: (context, index) {
                final itemdata = widget.orderConfirmDataModel.items![index];
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
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
                                    color: GreyColor,
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
                                color: GreyColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                      //Farzi
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Column(
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
                      "₹${widget.orderConfirmDataModel.priceDetails!.subTotal}",
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
                      "₹${widget.orderConfirmDataModel.priceDetails!.couponDiscount}",
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
                      "₹${widget.orderConfirmDataModel.priceDetails!.gstPrice}",
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
                      "₹${widget.orderConfirmDataModel.priceDetails!.packingCharge}",
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
                          widget.distance_km.toString() +
                          ") " +
                          "₹${widget.orderConfirmDataModel.priceDetails!.deliveryCharge}",
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
                      "₹${widget.orderConfirmDataModel.priceDetails!.total_amount2}",
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
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              width: double.maxFinite,
              height: 0.5,
              color: GreyColor2,
            ),
            SizedBox(
              height: 18,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OrderDetailss,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
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
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        widget.orderConfirmDataModel.orderDetails!.orderNumber
                            .toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
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
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        widget.orderConfirmDataModel.orderDetails!.address
                            .toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
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
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        widget.orderConfirmDataModel.orderDetails!.paymentType
                                    .toString() ==
                                "0"
                            ? CashOnDelivery
                            : OnlinePayment,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
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
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        widget.orderConfirmDataModel.orderDetails!
                                    .isScheduled ==
                                1
                            ? widget.orderConfirmDataModel.orderDetails!
                                    .estimatedTime
                                    .toString() +
                                " Min"
                            : EstimateTime,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: GreyColor),
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
}
