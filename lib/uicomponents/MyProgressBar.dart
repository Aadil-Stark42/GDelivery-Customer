library progress_button;

import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';

class MyProgressBar extends StatefulWidget {
  @override
  _MyProgressBarState createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Center(
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }
}
