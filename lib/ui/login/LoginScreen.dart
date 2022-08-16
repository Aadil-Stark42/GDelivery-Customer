import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdeliverycustomer/models/CityDataModel.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/utils/Utils.dart';

import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../res/ResString.dart';

import '../../uicomponents/progress_button.dart';
import '../../uicomponents/rounded_input_field4.dart';
import 'OtpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String UserName = "", MobileNumber = "";
  ButtonState buttonState = ButtonState.normal;
  CityDataModel cityDataModel = CityDataModel();
  Citiess initcity = Citiess(
      id: 000, name: selectYourLocation, isActive: 000, createdDate: "115555");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
    statusBarColor();
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(imagePath + "login_background_img.png"))),
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
                      gDeliveryStart,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: Raleway_Bold,
                          color: blackColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: greyColor7)),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+91",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: Raleway_SemiBold,
                                height: 1.0,
                                color: blackColor),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 1.5,
                            color: blackColor,
                            height: 15,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: RoundedInputField4(
                              hintText: "Enter your mobile number",
                              onChanged: (value) {
                                MobileNumber = value;
                              },
                              inputType: TextInputType.number,
                              cornerRadius: 8,
                              horizontalmargin: 0,
                              elevations: 0,
                              textAlign: TextAlign.start,
                              verticalmargin: 0,
                              textsize: 16,
                              textcolor: blackColor,
                              hintColor: greyColor6,
                              contentPaddings: EdgeInsets.only(top: -15),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: greyColor7)),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RoundedInputField4(
                              hintText: EnterNameHint,
                              onChanged: (value) {
                                UserName = value;
                              },
                              inputType: TextInputType.name,
                              cornerRadius: 8,
                              horizontalmargin: 0,
                              elevations: 0,
                              textAlign: TextAlign.start,
                              verticalmargin: 0,
                              textsize: 15,
                              textcolor: blackColor,
                              hintColor: greyColor6,
                              contentPaddings: EdgeInsets.only(top: -15),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: greyColor7)),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: cityDataModel.cities != null
                                ? DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      // Initial Value
                                      value: initcity,
                                      // Array list of items
                                      icon: Container(),
                                      items: cityDataModel.cities!.citiess!
                                          .map((Citiess items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items.name.toString(),
                                            style: TextStyle(
                                                color: items.name.toString() ==
                                                        selectYourLocation
                                                    ? greyColor6
                                                    : blackColor,
                                                height: 1.0,
                                                fontFamily: Raleway_SemiBold,
                                                fontSize: 15),
                                          ),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (Citiess? newValue) {
                                        setState(() {
                                          initcity = newValue!;
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 30,
                            color: blackColor,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius:
                              BorderRadius.circular(Rounded_Button_Corner)),
                      child: ProgressButton(
                        child: Text(
                          LOGIN.toUpperCase(),
                          style: TextStyle(
                            color: whiteColor,
                            fontFamily: Raleway_Bold,
                            height: 1.0,
                          ),
                        ),
                        onPressed: () {
                          LoginApiCalling();
                        },
                        buttonState: buttonState,
                        backgroundColor: mainColor,
                        progressColor: whiteColor,
                        border_radius: Full_Rounded_Button_Corner,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "By signing up you agree to our ",
                          style: TextStyle(
                              color: greyColor8,
                              fontSize: 12,
                              fontFamily: Raleway_SemiBold),
                        ),
                        Text(
                          "Terms of Use ",
                          style: TextStyle(
                              color: greenColor2,
                              fontSize: 12,
                              fontFamily: Raleway_SemiBold),
                        ),
                        Text(
                          "and ",
                          style: TextStyle(
                              color: greyColor8,
                              fontSize: 12,
                              fontFamily: Raleway_SemiBold),
                        ),
                        Text(
                          "Privacy Policy ",
                          style: TextStyle(
                              color: greenColor2,
                              fontSize: 12,
                              fontFamily: Segoe_ui_semibold),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    ));
  }

/* Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
          )*/
  Future<void> LoginApiCalling() async {
    if (UserName.isEmpty) {
      ShowToast(EnterNameHint, context);
    } else if (MobileNumber.length != 10) {
      ShowToast(EnterValidmobile, context);
    } else if (initcity.id == 000) {
      ShowToast(selectYourLocation, context);
    } else {
      HideKeyBoard();
      setState(() {
        buttonState = ButtonState.inProgress;
      });

      var dio = GetApiInstance();
      Response response;
      response = await dio.post(LOGIN_API,
          data: {mobile: MobileNumber, name: UserName, city: initcity.id});
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
                      cityId: initcity.id.toString(),
                    )),
          );
        });
      }
    }
  }

  Future<Response> getCities() async {
    var ApiCalling = GetApiInstance();
    Response response;
    response = await ApiCalling.get(GET_Cities);
    setState(() {
      cityDataModel = CityDataModel.fromJson(response.data);
      cityDataModel.cities!.citiess!.insert(0, initcity);
    });
    if (response.data[status] != true) {
      ShowToast(response.data[message].toString(), context);
    }
    return response;
  }
}
