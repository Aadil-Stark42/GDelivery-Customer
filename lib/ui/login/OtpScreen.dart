import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/ui/home/HomeScreen.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../res/ResColor.dart';
import '../../res/ResString.dart';
import '../../uicomponents/progress_button.dart';
import '../../utils/Utils.dart';
import '../address/SelectAddressScreen.dart';

class OtpScreen extends StatefulWidget {
  String mobileNumber;
  String UserName;
  String cityId;

  OtpScreen({
    required this.mobileNumber,
    required this.UserName,
    required this.cityId,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String OttStr = "";
  bool LastOtpget = true;
  ButtonState buttonState = ButtonState.normal;

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(imagePath + "ic_otp.png"))),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 30, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Verification,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: Raleway_Bold,
                          color: blackColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Submit the 4 digit code you got on your " +
                          widget.mobileNumber +
                          " number.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: Raleway_Medium,
                          color: greyColor9),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    OTPTextField(
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 60,
                      otpFieldStyle: OtpFieldStyle(
                        focusBorderColor: mainColor,
                        enabledBorderColor: greyColor7,
                      ),
                      style: TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onChanged: (currentvalue) {},
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        OttStr = pin;
                      },
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Center(
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(14)),
                        child: ProgressButton(
                          child: Text(
                            Verify,
                            style: TextStyle(
                              color: whiteColor,
                              fontFamily: Raleway_Bold,
                              height: 1.0,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              buttonState = ButtonState.inProgress;
                            });
                            OtpVerification();
                          },
                          buttonState: buttonState,
                          backgroundColor: mainColor,
                          progressColor: whiteColor,
                          border_radius: Full_Rounded_Button_Corner,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          ResendOtp();
                        },
                        child: Text(
                          "Didn't receive an OTP? Resend",
                          style: TextStyle(
                            shadows: [
                              Shadow(color: greyColor8, offset: Offset(0, -3))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: greyColor8,
                            decorationThickness: 1,
                            fontFamily: Poppins_light,
                            fontWeight: FontWeight.bold,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ))
        ],
      ),
    ));
  }

  Future<void> OtpVerification() async {
    String? token = await FirebaseMessaging.instance.getToken();
    String? deviceId = await GetDeviceId();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = <String, dynamic>{};
    body[mobile] = widget.mobileNumber;
    body[otp] = OttStr;
    body[device_id] = deviceId;
    body[fcm_token] = token;
    print(body.toString());
    var ApiCalling = GetApiInstance();

    Response response;
    response = await ApiCalling.post(VERIFICATION_OTP, data: body);
    print('RESPONSEEEEE${response.data.toString()}');
    if (response.data[status]) {
      setState(() {
        buttonState = ButtonState.normal;
      });

      prefs.setBool(ISLOGIN, true);
      Future.delayed(const Duration(milliseconds: 1000), () {
        AddLoginData(
            widget.mobileNumber,
            deviceId.toString(),
            response.data[brtoken].toString(),
            widget.UserName,
            response.data[user][id].toString());

        if (prefs.getString(SELECTED_ADDRESS_ID) == null) {
          print("SELECTED_ADDRESS_ID  NULLLLLLL");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectAddressScreen(
                      IsJustChangeAddress: false,
                      GstPer: "",
                      IsForCart: false,
                      isBackAvaillable: true)),
              (Route<dynamic> route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        }
      });
    } else {
      setState(() {
        buttonState = ButtonState.normal;
      });
      ShowToast(response.data[message], context);
    }
  }

  Future<void> ResendOtp() async {
    HideKeyBoard();
    var dio = GetApiInstance();
    Response response;
    response = await dio.post(LOGIN_API, data: {
      mobile: widget.mobileNumber,
      name: widget.UserName,
      city: widget.cityId
    });

    ShowToast(response.data[MESSAGE], context);
  }
}
