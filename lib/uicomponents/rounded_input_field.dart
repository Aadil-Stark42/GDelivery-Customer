import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdeliverycustomer/uicomponents/text_field_container.dart';

import '../res/ResColor.dart';
import '../res/ResString.dart';
import '../utils/UpperCaseTextFormatter.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final ValueChanged<String> onChanged;
  final double Corner_radius;
  final double horizontal_margin;
  final double elevations;
  final TextInputFormatter formatter;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.Corner_radius,
    required this.inputType,
    required this.horizontal_margin,
    required this.elevations,
    required this.formatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: TextFieldContainer(
      Corner_radius: Corner_radius,
      horizontal_margin: horizontal_margin,
      elevations: elevations,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          onChanged: onChanged,
          cursorColor: MainColor,
          keyboardType: inputType,
          inputFormatters: [
            formatter,
          ],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: Segoe_ui_semibold,
              fontSize: 13,
              color: GreyColor),
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: GreyColor,
              size: 20,
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    ));
  }
}
