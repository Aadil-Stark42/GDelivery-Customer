import 'package:flutter/material.dart';

import 'package:gdeliverycustomer/res/ResColor.dart';

import '../../res/ResString.dart';
import '../../uicomponents/progress_button.dart';

class AppMaintainanceScreen extends StatefulWidget {
  final bool IsBackAble;
  AppMaintainanceScreen(this.IsBackAble);
  @override
  AppMaintainanceScreenState createState() => AppMaintainanceScreenState();
}

class AppMaintainanceScreenState extends State<AppMaintainanceScreen> {
  ButtonState buttonState = ButtonState.normal;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Container(
          height: double.infinity,
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppMaintenance,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                    fontSize: 18,
                    height: 1.0,
                    fontFamily: Segoe_ui_bold,
                    color: darkMainColor2),
              ),
              Image.asset(
                imagePath + "maintanence.png",
                height: 342,
              ),
              Text(
                "G Digital Delivery",
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                    fontSize: 17,
                    height: 1.0,
                    fontFamily: Segoe_ui_bold,
                    color: darkMainColor2),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "We are closed now, will be back online soon! Please stay connected!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15, fontFamily: Segoeui, color: greyColor4),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              ProgressButton(
                child: Text(
                  OKAY,
                  style: TextStyle(
                    color: whiteColor,
                    fontFamily: Segoe_ui_semibold,
                    height: 1.1,
                  ),
                ),
                onPressed: () {
                  if (widget.IsBackAble) {
                    Navigator.pop(context);
                  }
                },
                buttonState: buttonState,
                backgroundColor: mainColor,
                progressColor: whiteColor,
                border_radius: Rounded_Button_Corner,
              )
            ],
          ),
        ),
      ),
    );
  }
}
