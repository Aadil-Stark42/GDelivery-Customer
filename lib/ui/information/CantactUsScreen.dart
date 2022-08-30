import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../utils/LocalStorageName.dart';

class CantactUsScreen extends StatefulWidget {
  @override
  CantactUsScreenState createState() => CantactUsScreenState();
}

class CantactUsScreenState extends State<CantactUsScreen> {
  String mobile_contact = "", email_contact = "", whatsapp_contact = "";
  @override
  void initState() {
    super.initState();
    UserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    imagePath + "ic_back2.png",
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ContactUs,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Inter_bold,
                      color: darkMainColor2),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.maxFinite,
              height: 1.5,
              color: greyColor12,
            ),
            SizedBox(
              height: 14,
            ),
            InkWell(
                onTap: () {
                  launch("tel:$mobile_contact");
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 13, bottom: 13),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.asset(
                        imagePath + "ic_telephone.png",
                        width: 39,
                        height: 39,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Phone",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Segoe_ui_semibold,
                            color: blackColor),
                      )
                    ],
                  ),
                )),
            InkWell(
                onTap: () {
                  launch("mailto:$email_contact?subject=&body=");
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 13, bottom: 13),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.asset(
                        imagePath + "ic_mail.png",
                        width: 39,
                        height: 39,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Segoe_ui_semibold,
                            color: blackColor),
                      )
                    ],
                  ),
                )),
            InkWell(
                onTap: () {
                  launch("https://wa.me/${mobile_contact}?text=Hello");
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 13, bottom: 13),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.asset(
                        imagePath + "ic_whatsapp.png",
                        width: 39,
                        height: 39,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Whatsapp",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Segoe_ui_semibold,
                            color: blackColor),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void UserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile_contact = prefs.getString(MOBILE_CONTACT)!;
      email_contact = prefs.getString(EMAIL_CONTACT)!;
      whatsapp_contact = prefs.getString(WHATSAPP_CONTACT)!;
    });
  }
}
