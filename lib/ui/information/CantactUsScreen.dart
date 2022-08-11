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
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        backgroundColor: WhiteColor,
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
              ContactUs,
              style: TextStyle(
                  fontSize: 16, fontFamily: Inter_bold, color: BlackColor),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                launch("tel:$mobile_contact");
              },
              child: Row(
                children: [
                  Image.asset(
                    imagePath + "ic_telephone.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Phone",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Segoe_ui_semibold,
                        color: BlackColor),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              width: double.maxFinite,
              height: 0.5,
              color: GreyColor2,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                launch("mailto:$email_contact?subject=&body=");
              },
              child: Row(
                children: [
                  Image.asset(
                    imagePath + "ic_mail.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Segoe_ui_semibold,
                        color: BlackColor),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              width: double.maxFinite,
              height: 0.5,
              color: GreyColor2,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                launch("https://wa.me/${mobile_contact}?text=Hello");
              },
              child: Row(
                children: [
                  Image.asset(
                    imagePath + "ic_whatsapp.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Whatsapp",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Segoe_ui_semibold,
                        color: BlackColor),
                  )
                ],
              ),
            ),
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
