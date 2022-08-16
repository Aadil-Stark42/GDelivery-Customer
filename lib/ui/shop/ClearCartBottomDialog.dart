import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:gdeliverycustomer/res/ResColor.dart';

import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';

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
                  color: blackColor,
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
                        color: blackColor),
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
                        color: greyColor),
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
                                          mainColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: const BorderSide(
                                              color: mainColor)))),
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
                                          whiteColor),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          mainColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: const BorderSide(color: mainColor)))),
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
