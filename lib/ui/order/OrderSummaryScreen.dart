import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:gdeliverycustomer/models/PaytmResponse.dart';
import 'package:gdeliverycustomer/models/ShopDetailsDataModel.dart';
import 'package:lottie/lottie.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/ui/order/OrderConfirmationScreen.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/MyProgressBar.dart';
import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/animation_limiter.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../models/OrderConfirmDataModel.dart';
import '../../models/OrderSummaryDataModel.dart';
import '../../uicomponents/RoundedBorderButton.dart';
import '../../uicomponents/progress_button.dart';
import '../../uicomponents/rounded_button.dart';
import '../../uicomponents/rounded_input_field.dart';
import '../../utils/UpperCaseTextFormatter.dart';
import '../../utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String GstPer, Temp_Address_id, Temp_address_name;

  OrderSummaryScreen(this.GstPer, this.Temp_Address_id, this.Temp_address_name);

  @override
  OrderSummaryScreenState createState() => OrderSummaryScreenState();
}

class OrderSummaryScreenState extends State<OrderSummaryScreen> {
  OrderSummaryDataModel _orderSummaryDataModel = OrderSummaryDataModel();
  bool IsCashOnDeliveryCLick = false;
  bool IsOnlineCLick = false;
  String Payment_Method = "";
  String paytm_checkshum = "";
  String paytm_order_id = "";
  String paytm_txn_id = "";
  final Razorpay _razorpay = Razorpay();
  bool IsLoadingPayment = false;
  String CouponValue = "";
  ButtonState buttonState = ButtonState.normal;
  bool isClickCouponAplly = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    GetOrderSummaryDetails("");
  }

  @override
  Widget build(BuildContext context) {
    _razorpay.clear();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    return Scaffold(
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
                    Navigator.pop(context);
                  },
                  child: Image.asset(imagePath + "back_arrow.png",
                      height: 25, width: 25),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  OrderSummary,
                  style: TextStyle(
                      fontSize: 16, fontFamily: Inter_bold, color: BlackColor),
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
        text: IsLoadingPayment == true ? Loadinggg : ConfirmedOrder,
        corner_radius: Rounded_Button_Corner,
        press: () {
          if (Payment_Method.isNotEmpty) {
            if (!IsLoadingPayment) {
              setState(() {
                IsLoadingPayment = true;
              });
              if (Payment_Method == CashOnDelivery) {
                OrderConfirmation();
              } else {
                GetTokenForPayment();
              }
            }
          } else {
            ShowToast(Selectpaymentmethod, context);
          }
        },
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    _razorpay.clear();
    paytm_checkshum = response.signature.toString();
    paytm_order_id = response.paymentId.toString();
    paytm_txn_id = response.orderId.toString();
    OrderConfirmation();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("response.code${response.code}");
    if (response.code == 2) {
      ShowToast(PaymentCancelled, context);
    } else {
      ShowToast(response.message.toString(), context);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  Future<void> GetOrderSummaryDetails(String coupon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[address_id] = widget.Temp_Address_id;
    Params[coupon_code] = coupon;
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(ORDER_SUMMARY, data: Params);
    print("GetOrderSummaryDetailsRESPONSEE${response.data.toString()}");
    if (coupon.isNotEmpty) {
      ShowToast(response.data[message], context);
    }
    setState(() {
      if (OrderSummaryDataModel.fromJson(response.data).items!.isNotEmpty) {
        _orderSummaryDataModel = OrderSummaryDataModel.fromJson(response.data);
        /*     List<Coupons> list = [];
        list.add(Coupons(
            couponCode: "MYFLAT",
            couponDescription: "FLAT 505 off this Offers"));
        _orderSummaryDataModel.coupons = list;*/
      }

      if (isClickCouponAplly) {
        if (_orderSummaryDataModel.priceDetails!.couponDiscount.toString() !=
            "0.00") {
          showCouponDialog();
        }
      }
    });
  }

  Future<void> OrderConfirmation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[order_id] = _orderSummaryDataModel.orderDetails!.orderId.toString();
    if (Payment_Method == CashOnDelivery) {
      Params[payment_type] = "0";
    } else {
      Params[payment_type] = "1";
      Params[razorpay_signature] = paytm_checkshum;
      Params[razorpay_payment_id] = paytm_order_id;
      Params[razorpay_order_id] = paytm_txn_id;
    }

    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(ORDER_CONFIRM, data: Params);
    print("OrderConfirmationresponse${response.data.toString()}");
    setState(() {
      IsLoadingPayment = false;
    });
    ShowToast(response.data[message], context);
    print(
        "OrderConfirmationresponsemessagemessage${response.data[message].toString()}");
    if (response.data[status]) {
      OrderConfirmDataModel orderConfirmDataModel =
          OrderConfirmDataModel.fromJson(response.data);
      orderConfirmDataModel.priceDetails!.gstPrice =
          _orderSummaryDataModel.priceDetails!.gstPrice.toString();
      orderConfirmDataModel.priceDetails!.packingCharge =
          _orderSummaryDataModel.priceDetails!.packingCharge.toString();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => OrderConfirmationScreen(
                  orderConfirmDataModel,
                  widget.GstPer,
                  _orderSummaryDataModel.priceDetails!.distance_km.toString())),
          (Route<dynamic> route) => false);
    }
  }

  Widget OrderDetailsView() {
    Size size = MediaQuery.of(context).size;
    if (_orderSummaryDataModel.status != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 60, left: 10, right: 10, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  YourOrders,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
                ),
                SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _orderSummaryDataModel.items!.length,
                  itemBuilder: (context, index) {
                    final itemdata = _orderSummaryDataModel.items![index];
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
                  height: 20,
                ),
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
                        OrderNumber,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Segoe_ui_semibold,
                            color: BlackColor2),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        _orderSummaryDataModel.orderDetails!.orderNumber
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
                        widget.Temp_address_name,
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
                        _orderSummaryDataModel.orderDetails!.isScheduled == 1
                            ? _orderSummaryDataModel.orderDetails!.estimatedTime
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
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Use delivery coupons here",
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: GreyColor2),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: RoundedInputField(
                        hintText: "Use INSUVAI Coupons",
                        onChanged: (value) {
                          CouponValue = value.toUpperCase();
                        },
                        icon: Icons.airplane_ticket_outlined,
                        Corner_radius: 0,
                        horizontal_margin: 0,
                        elevations: 0,
                        formatter: UpperCaseTextFormatter(),
                        inputType: TextInputType.text,
                      )),
                      Container(
                        width: 80,
                        height: 45,
                        child: ProgressButton(
                          child: Text(
                            APPLY,
                            style: TextStyle(
                              color: WhiteColor,
                              fontFamily: Segoe_ui_semibold,
                              height: 1.1,
                            ),
                          ),
                          onPressed: () {
                            if (CouponValue.isNotEmpty) {
                              isClickCouponAplly = true;
                              GetOrderSummaryDetails(CouponValue);
                            } else {
                              ShowToast("Please enter coupon code", context);
                            }
                          },
                          buttonState: buttonState,
                          backgroundColor: MainColor,
                          progressColor: WhiteColor,
                          border_radius: Rounded_Button_Corner,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      )
                    ],
                  ),
                ),
                CouponListview(),
                SizedBox(
                  height: 25,
                ),
                Text(
                  Payment,
                  style: TextStyle(
                      fontSize: 17, fontFamily: Inter_bold, color: BlackColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: RoundedBorderButton(
                      txt: CashOnDelivery,
                      txtSize: 13,
                      CornerReduis: 7,
                      BorderWidth: 0.8,
                      BackgroundColor: IsCashOnDeliveryCLick == true
                          ? MainColor
                          : WhiteColor,
                      ForgroundColor: IsCashOnDeliveryCLick == true
                          ? WhiteColor
                          : MainColor,
                      PaddingLeft: 15,
                      PaddingRight: 15,
                      PaddingTop: 15,
                      PaddingBottom: 15,
                      press: () {
                        Payment_Method = CashOnDelivery;
                        setState(() {
                          IsCashOnDeliveryCLick = true;
                          IsOnlineCLick = false;
                        });
                      },
                    )),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: RoundedBorderButton(
                      txt: OnlinePayment,
                      txtSize: 13,
                      CornerReduis: 7,
                      BorderWidth: 0.8,
                      BackgroundColor:
                          IsOnlineCLick == true ? MainColor : WhiteColor,
                      ForgroundColor:
                          IsOnlineCLick == true ? WhiteColor : MainColor,
                      PaddingLeft: 15,
                      PaddingRight: 15,
                      PaddingTop: 15,
                      PaddingBottom: 15,
                      press: () {
                        Payment_Method = OnlinePayment;
                        setState(() {
                          IsCashOnDeliveryCLick = false;
                          IsOnlineCLick = true;
                        });
                      },
                    ))
                  ],
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
                            color: _orderSummaryDataModel
                                        .priceDetails!.couponDiscount
                                        .toString() !=
                                    "0.00"
                                ? RedColor
                                : GreyColor,
                          ),
                        ),
                        Text(
                          "₹${_orderSummaryDataModel.priceDetails!.couponDiscount}",
                          style: TextStyle(
                            fontFamily: Poppinsmedium,
                            fontSize: 13,
                            height: 1.0,
                            color: _orderSummaryDataModel
                                        .priceDetails!.couponDiscount
                                        .toString() !=
                                    "0.00"
                                ? RedColor
                                : GreyColor,
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
                ),
                SizedBox(
                  height: 20,
                ),
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

  Future<void> OnlinePaymentStart(String api_key, String Res_Order_Id) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var RetryOPtion = {
      'enabled': true,
      'max_count': 10,
    };
    var options = {
      'key': api_key,
      'amount': _orderSummaryDataModel.priceDetails!.total.toString(),
      'name': packageInfo.appName,
      'order_id': Res_Order_Id,
      'theme.color': '#41B649FF',
      'currency': 'INR',
      'image': 'https://s3.amazonaws.com/rzp-mobile/images/rzp.png',
      'retry': RetryOPtion,
    };
    _razorpay.open(options);
  }

  Future<void> GetTokenForPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fcm_token = await FirebaseMessaging.instance.getToken();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[order_id] = _orderSummaryDataModel.orderDetails!.orderId.toString();
    Params[order_amount] = _orderSummaryDataModel.priceDetails!.total
        .toString()
        .replaceAll(",", "")
        .replaceAll(".", "");
    Params[customer_id] = fcm_token;
    print("GetTokenForPaymentParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(PAYMENT_INITIATE, data: Params);
    print("GetTokenForPaymentRESPONSEE${response.data.toString()}");
    setState(() {
      IsLoadingPayment = false;
    });
    if (response.data[status]) {
      /*TestingPayment();*/
      PaytmPaymentStart(response.data["token"], response.data["mid"],
          response.data["order_id"]);
    } else {
      ShowToast(response.data[message], context);
    }
  }

  void PaytmPaymentStart(token, mid, order_id) {
    String host = "https://securegw.paytm.in/";
    String callBackUrl = host + "theia/paytmCallback?ORDER_ID=" + order_id;
    try {
      var response = AllInOneSdk.startTransaction(
          mid,
          order_id,
          _orderSummaryDataModel.priceDetails!.total.toString(),
          token,
          callBackUrl,
          false,
          true);
      /* response.then((value) {
        print(value);
        setState(() {
          result = value.toString();
        });*/
      response.then((value) {
        if (value != null) {
          if (value["STATUS"]?.toString() == "TXN_SUCCESS") {
            paytm_checkshum = value["CHECKSUMHASH"].toString();
            paytm_order_id = value["ORDERID"].toString();
            paytm_txn_id = value["TXNID"].toString();
            OrderConfirmation();
          } else {
            ShowToast(value["RESPMSG"].toString(), context);
            print("resultresultresultresultPAYMENTNOT01" +
                value["RESPMSG"].toString());
          }
        }
      }).catchError((onError) {
        if (onError is PlatformException) {
          print("resultresultresultresultPAYMENTPlatformException" +
              onError.message! +
              " \n  " +
              onError.details.toString());
          ShowToast(onError.message.toString(), context);
        } else {
          ShowToast(onError.toString(), context);
          print("resultresultresultresultPAYMENTonError.toString" +
              onError.toString());
        }
      });
    } catch (err) {
      print("resultresultresultresultPAYMENT" + err.toString());
      ShowToast(err.toString(), context);
    }
  }

  Widget CouponListview() {
    print("CuponsList" + _orderSummaryDataModel.coupons!.length.toString());
    if (_orderSummaryDataModel.coupons!.isNotEmpty) {
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
                itemCount: _orderSummaryDataModel.coupons!.length,
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
                              _orderSummaryDataModel
                                      .coupons![index].couponDescription
                                      .toString() +
                                  "  (Coupon copied)",
                              context);
                          Clipboard.setData(ClipboardData(
                              text: _orderSummaryDataModel
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
                                              _orderSummaryDataModel
                                                  .coupons![index]
                                                  .couponDescription
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.0,
                                                  fontFamily: Segoe_ui_semibold,
                                                  color: BlackColor),
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
                                                        color: BlackColor),
                                                  ),
                                                  Text(
                                                    _orderSummaryDataModel
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
                                                        color: BlackColor),
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

  void TestingPayment() {
    var value = <dynamic, dynamic>{};
    value["CURRENCY"] = "INR";
    value["GATEWAYNAME"] = "PPBL";
    value["RESPMSG"] = "Txn Success";
    value["PAYMENTMODE"] = "UPI";
    value["MID"] = "qqUMXL75442270455952";
    value["RESPCODE"] = 01;
    value["TXNAMOUNT"] = 36.00;
    value["TXNID"] = "20220531111212800110168874954864568";
    value["ORDERID"] = "349020220531000725";
    value["STATUS"] = "TXN_SUCCESS";
    value["BANKTXNID"] = 215117170839;
    value["TXNDATE"] = "2022-05-31 00:07:26.0";
    value["CHECKSUMHASH"] =
        "vmhrHzl+FzxzS+sRzY3uM/ES4HTNqSmJu/Rrd4VYbSmEeHQxcy1NZYABiAveA95j+Q0tevI40BBqgoknItVPgBMDNr71lFRCfc45GEZlYSQ=";

    if (value["STATUS"].toString() == "TXN_SUCCESS") {
      paytm_checkshum = value["CHECKSUMHASH"].toString();
      paytm_order_id = value["ORDERID"].toString();
      paytm_txn_id = value["TXNID"].toString();
    }
    ShowToast(value["RESPMSG"].toString(), context);
    print("resultresultresultresultPAYMENTNOT01" + value["RESPMSG"].toString());
  }

  showCouponDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 355,
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 200),
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset(
                            imagePath + "saved_money.json",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 170,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  "\'" + CouponValue.toUpperCase() + "\'",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Segoe_ui_semibold,
                                    fontSize: 13,
                                    height: 1.0,
                                    color: GreyColor5,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "applied",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Segoe_ui_semibold,
                                    fontSize: 11,
                                    height: 1.0,
                                    color: GreyColor5,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "YOU SAVED " +
                                  RUPPEE +
                                  _orderSummaryDataModel
                                      .priceDetails!.couponDiscount
                                      .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: Segoe_bold,
                                fontSize: 19,
                                height: 1.0,
                                color: BlackColor,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "with this coupon code.",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: Segoe_ui_semibold,
                                fontSize: 12,
                                height: 1.0,
                                color: GreyColor5,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Woohoo! Thanks..",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: Segoe_ui_semibold,
                                fontSize: 13,
                                height: 1.0,
                                color: RedColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
