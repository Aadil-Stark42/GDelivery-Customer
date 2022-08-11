library progress_button;

import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';

import '../res/ResString.dart';

class RoundedBorderButton extends StatefulWidget {
  final String txt;
  final double txtSize;
  final double CornerReduis;
  final double BorderWidth;
  final Color BackgroundColor;
  final Color ForgroundColor;
  final double PaddingLeft;
  final double PaddingRight;
  final double PaddingTop;
  final double PaddingBottom;
  final VoidCallback press;
  const RoundedBorderButton({
    required this.txt,
    required this.txtSize,
    required this.CornerReduis,
    required this.BorderWidth,
    required this.BackgroundColor,
    required this.ForgroundColor,
    required this.PaddingLeft,
    required this.PaddingRight,
    required this.PaddingTop,
    required this.PaddingBottom,
    required this.press,
  });

  @override
  _RoundedBorderButtonState createState() => _RoundedBorderButtonState();
}

class _RoundedBorderButtonState extends State<RoundedBorderButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: TextButton(
          child: Text(widget.txt,
              style: TextStyle(
                  fontSize: widget.txtSize, fontFamily: Poppinsmedium)),
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
                  left: widget.PaddingLeft,
                  right: widget.PaddingRight,
                  top: widget.PaddingTop,
                  bottom: widget.PaddingBottom)),
              foregroundColor:
                  MaterialStateProperty.all<Color>(widget.ForgroundColor),
              backgroundColor:
                  MaterialStateProperty.all<Color>(widget.BackgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(widget.CornerReduis),
                      side: BorderSide(
                          color: widget.ForgroundColor,
                          width: widget.BorderWidth)))),
          onPressed: () => {widget.press()}),
    );
  }
}
