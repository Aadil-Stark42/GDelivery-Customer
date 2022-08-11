import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/uicomponents/text_field_container.dart';

import '../res/ResColor.dart';
import '../res/ResString.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final double horizontal_margin;
  final double elevations;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.horizontal_margin,
    required this.elevations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFieldContainer(
        Corner_radius: Full_Rounded_Button_Corner,
        horizontal_margin: horizontal_margin,
        elevations: elevations,
        child: TextField(
          obscureText: true,
          onChanged: onChanged,
          cursorColor: MainColor,
          decoration: const InputDecoration(
            hintText: "Password",
            icon: Icon(
              Icons.lock,
              color: MainColor,
            ),
            suffixIcon: Icon(
              Icons.visibility,
              color: MainColor,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
