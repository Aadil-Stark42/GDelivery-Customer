import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/ui/home/HomeScreen.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:otp_text_field/otp_field.dart';
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

  OtpScreen({
    required this.mobileNumber,
    required this.UserName,
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: WhiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: 200,
                height: 200,
                child: Image.asset(
                  '${imagePath}step-one.png',
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Text(
                Verification,
                style: TextStyle(
                    fontSize: 22, fontFamily: Segoe_ui_semibold, height: 1),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                EnterYourOTP,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    fontFamily: Inter_regular,
                    height: 1),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "OTP Send to " + widget.mobileNumber,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GreyColor3,
                    fontFamily: Segoe_ui_semibold,
                    height: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OTPTextField(
                            length: 4,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 60,
                            style: TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onChanged: (currentvalue) {},
                            onCompleted: (pin) {
                              print("Completed: " + pin);
                              OttStr = pin;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    ProgressButton(
                      child: Text(
                        Verify,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: Segoe_ui_semibold,
                          height: 1.1,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          buttonState = ButtonState.inProgress;
                        });
                        OtpVerification();
                      },
                      buttonState: buttonState,
                      backgroundColor: MainColor,
                      progressColor: WhiteColor,
                      border_radius: Full_Rounded_Button_Corner,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                DidnotReceive,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    fontFamily: Inter_regular,
                    height: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  ResendOtp();
                },
                child: Text(
                  Resend,
                  style: TextStyle(
                      height: 1,
                      fontSize: 15,
                      color: MainColor,
                      fontFamily: Poppinsmedium),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
  Widget _textFieldOTP({required bool first, last}) {
    return Container(
      height: 60,
      width: 60,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 1 && last == true) {}
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: MainColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
*/

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
                  builder: (context) => SelectAddressScreen(false, "", false)),
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
    response = await dio.post(LOGIN_API,
        data: {mobile: widget.mobileNumber, name: widget.UserName});

    ShowToast(response.data[MESSAGE], context);
  }
}
