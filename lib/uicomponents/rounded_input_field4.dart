import 'package:flutter/material.dart';

import '../res/ResColor.dart';
import '../res/ResString.dart';

class RoundedInputField4 extends StatelessWidget {
  final String hintText;

  final TextInputType inputType;
  final ValueChanged<String> onChanged;
  final double cornerRadius;
  final double horizontalmargin;
  final double verticalmargin;
  final double elevations;
  final Color textcolor;
  final double textsize;
  final TextAlign textAlign;
  final Color hintColor;
  final EdgeInsetsGeometry contentPaddings;

  const RoundedInputField4({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.cornerRadius,
    required this.inputType,
    required this.horizontalmargin,
    required this.elevations,
    required this.textAlign,
    required this.verticalmargin,
    required this.textcolor,
    required this.textsize,
    required this.hintColor,
    required this.contentPaddings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        textAlign: textAlign,

        onChanged: onChanged,
        cursorColor: mainColor,
        keyboardType: inputType,
        style: TextStyle(
            fontFamily: Raleway_SemiBold,
            height: 1.0,
            fontSize: textsize, //14
            color: textcolor),
        //EditTextColor
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor, fontFamily: Raleway_SemiBold),
          border: InputBorder.none,
          contentPadding: contentPaddings,
        ),
      ),
    );
  }
}
