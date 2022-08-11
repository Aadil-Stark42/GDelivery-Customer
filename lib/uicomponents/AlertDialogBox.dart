library progress_button;

import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/alertdialog/rflutter_alert.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';

import '../alertdialog/src/alert.dart';
import '../alertdialog/src/constants.dart';
import '../alertdialog/src/dialog_button.dart';
import '../res/ResString.dart';
import '../ui/home/homesubscreen/CartSubScreen.dart';

class AlertDialogBox extends StatefulWidget {
  AlertDialogBox();

  @override
  _AlertDialogBoxState createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: OpenDIalog(),
    );
  }

  OpenDIalog() {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
          titleStyle: TextStyle(fontSize: 18, fontFamily: Inter_bold),
          descStyle: TextStyle(fontSize: 16, fontFamily: Segoe_ui_semibold)),
      title: "INSUVAI DELIVERY SERVICES",
      desc:
          "We are closed now, will be back online soon! Please stay connected!",
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          width: 120,
        )
      ],
    ).show();
  }
}
