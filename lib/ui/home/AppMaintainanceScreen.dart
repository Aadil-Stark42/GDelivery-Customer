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

    return Scaffold(
      backgroundColor: WhiteColor,
      body: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              imagePath + "maintanence.png",
              height: 250,
              width: 350,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "INSUVAI DELIVERY SERVICES",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontFamily: Inter_bold, color: BlackColor),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "We are closed now, will be back online soon! Please stay connected!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: Segoe_ui_semibold,
                  color: BlackColor2),
            ),
            SizedBox(
              height: 20,
            ),
            ProgressButton(
              child: Text(
                OKAY,
                style: TextStyle(
                  color: WhiteColor,
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
              backgroundColor: MainColor,
              progressColor: WhiteColor,
              border_radius: Rounded_Button_Corner,
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: WhiteColor,
        flexibleSpace: FlexibleSpaceBar(),
        elevation: 2,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              AppMaintenance,
              style: TextStyle(
                  fontSize: 16, fontFamily: Inter_bold, color: BlackColor),
            ),
          ],
        ),
      ),
    );
  }
}
