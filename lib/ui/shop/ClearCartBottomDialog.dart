import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/models/ShopProductDataModel.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';
import '../../../utils/Utils.dart';
import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/animation_limiter.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../models/ProductToppingDataModel.dart';
import '../../models/ShopDetailsDataModel.dart';
import '../../uicomponents/CustomTabView.dart';
import '../../uicomponents/MyProgressBar.dart';
import 'MainTappingView.dart';
import 'ShopDetailsHeader.dart';

class ClearCartBottomDialog extends StatefulWidget {
  final VoidCallback Positivepress, Nagetivepress;

  const ClearCartBottomDialog(
      {required this.Positivepress, required this.Nagetivepress});

  @override
  ClearCartBottomDialogState createState() => ClearCartBottomDialogState();
}

class ClearCartBottomDialogState extends State<ClearCartBottomDialog>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  ButtonState buttonState = ButtonState.normal;
  String VersionName = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      margin: EdgeInsets.all(20),
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: Stack(
        children: [
          Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close_rounded,
                  color: BlackColor,
                ),
              )),
          Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Image.asset(
                      imagePath + "ic_emptycart.png",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    ClearCart,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Segoe_ui_bold,
                        color: BlackColor),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    yourcartcontain,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: Poppinsmedium,
                        color: GreyColor),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              child:
                                  Text(Cancel, style: TextStyle(fontSize: 14)),
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(15)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          MainColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: const BorderSide(
                                              color: MainColor)))),
                              onPressed: () {
                                Navigator.pop(context);
                                widget.Nagetivepress();
                              })),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: TextButton(
                              child: Text(ClearCartt,
                                  style: TextStyle(fontSize: 14)),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.all(15)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          WhiteColor),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          MainColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: const BorderSide(color: MainColor)))),
                              onPressed: () => widget.Positivepress())),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
