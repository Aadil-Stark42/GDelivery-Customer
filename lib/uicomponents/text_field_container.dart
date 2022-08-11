import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final double Corner_radius;
  final double horizontal_margin;
  final double elevations;

  const TextFieldContainer({
    Key? key,
    required this.child,
    required this.Corner_radius,
    required this.horizontal_margin,
    required this.elevations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.all(1),
      elevation: elevations,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Corner_radius)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0),
        padding:
            EdgeInsets.symmetric(horizontal: horizontal_margin, vertical: 0),
        width: size.width * 0.8,

        /*decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.circular(29),
        ),*/
        child: child,
      ),
    );
  }
}
