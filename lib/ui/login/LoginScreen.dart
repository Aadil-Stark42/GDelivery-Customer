import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/utils/Utils.dart';

import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../res/ResString.dart';
import '../../main.dart';

import '../../uicomponents/progress_button.dart';
import '../../uicomponents/rounded_button.dart';
import '../../uicomponents/rounded_input_field.dart';
import '../../utils/LowerCaseTextFormatter.dart';
import 'OtpScreen.dart';
import 'components/background.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLoginUi(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyLoginUi extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<MyLoginUi> {
  String UserName = "", MobileNumber = "";
  ButtonState buttonState = ButtonState.normal;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                LOGIN,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: Inter_medium,
                    fontSize: 17),
              ),
              SizedBox(height: size.height * 0.06),
              Image.asset(
                "${imagePath}step-one.png",
                height: size.height * 0.35,
              ),
              SizedBox(height: 50),
              RoundedInputField(
                  hintText: EnterNameHint,
                  onChanged: (value) {
                    UserName = value;
                  },
                  inputType: TextInputType.name,
                  icon: Icons.account_circle,
                  Corner_radius: Full_Rounded_Button_Corner,
                  horizontal_margin: 20,
                  elevations: 1,
                  formatter: LowerCaseTextFormatter()),
              SizedBox(height: 10),
              RoundedInputField(
                  hintText: EnterMobileHint,
                  onChanged: (value) {
                    MobileNumber = value;
                  },
                  inputType: TextInputType.number,
                  icon: Icons.phone,
                  Corner_radius: Full_Rounded_Button_Corner,
                  horizontal_margin: 20,
                  elevations: 1,
                  formatter: LowerCaseTextFormatter()),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ProgressButton(
                  child: Text(
                    LOGIN,
                    style: TextStyle(
                      color: WhiteColor,
                      fontFamily: Segoe_ui_semibold,
                      height: 1.1,
                    ),
                  ),
                  onPressed: () {
                    LoginApiCalling();
                  },
                  buttonState: buttonState,
                  backgroundColor: MainColor,
                  progressColor: WhiteColor,
                  border_radius: Full_Rounded_Button_Corner,
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> LoginApiCalling() async {
    if (UserName.isEmpty) {
      ShowToast(EnterNameHint, context);
    } else if (MobileNumber.length != 10) {
      ShowToast(EnterValidmobile, context);
    } else {
      HideKeyBoard();
      setState(() {
        buttonState = ButtonState.inProgress;
      });

      var dio = GetApiInstance();
      Response response;
      response = await dio
          .post(LOGIN_API, data: {mobile: MobileNumber, name: UserName});
      print("response.data${response.data}");
      if (response.data[STATUS]) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            buttonState = ButtonState.normal;
          });
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => OtpScreen(
                      mobileNumber: MobileNumber,
                      UserName: UserName,
                    )),
          );
        });
      }
    }
  }
}
