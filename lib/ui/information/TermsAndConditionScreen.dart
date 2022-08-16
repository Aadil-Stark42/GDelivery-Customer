import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../res/ResString.dart';

class TermsAndConditionScreen extends StatefulWidget {
  final String WEB_URL_NAME;

  TermsAndConditionScreen(this.WEB_URL_NAME);

  @override
  TermsAndConditionScreenState createState() => TermsAndConditionScreenState();
}

class TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  String Temrsurl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    GetTermsUrl();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IMAGE_PATH + "ic_termsandcon.png",
                      height: 250,
                      width: 200,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),*/
              WebViewHandle()
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
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
                widget.WEB_URL_NAME == TERMS_CONDITION
                    ? TermsandConditions
                    : PrivacyPolicy,
                style: TextStyle(
                    fontSize: 16, fontFamily: Inter_bold, color: blackColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void GetTermsUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.WEB_URL_NAME == TERMS_CONDITION) {
        Temrsurl = prefs.getString(TERMS_CONDITION)!;
      } else {
        Temrsurl = prefs.getString(PRIVACY_POLICY)!;
      }
    });
  }

  Widget WebViewHandle() {
    if (Temrsurl.isNotEmpty) {
      print("TemrsurlTemrsurlTemrsurlTemrsurl $Temrsurl");
      return Expanded(
        child: WebView(
          initialUrl: Temrsurl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      );
    } else {
      return Container();
    }
  }
}
