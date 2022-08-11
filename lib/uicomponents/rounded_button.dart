import 'package:flutter/material.dart';

import '../res/ResColor.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double corner_radius;
  final VoidCallback press;
  final Color color, textColor;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = MainColor,
    required this.corner_radius,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(corner_radius),
        child: newElevatedButton(),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  //Here we have to apply customizations to Button by inheriting the styleFrom

  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontFamily: "Bold",
          height: 1.1,
        ),
      ),
      onPressed: press,
      style: ElevatedButton.styleFrom(
          primary: color,
          padding: EdgeInsets.fromLTRB(20, 17, 20, 17),
          textStyle: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: "Black")),
    );
  }
}
