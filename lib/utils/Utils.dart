import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/ResColor.dart';

class UtilsClass extends Color {
  UtilsClass(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

void ShowToast(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 1),
    content: Text(message),
  ));
}

void ShowLongToast(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(message),
  ));
}

void statusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: mainColor,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: whiteColor,
      statusBarIconBrightness: Brightness.light));
}

void HideKeyBoard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Future<String?> GetDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // Unique ID on Android
  }
}

Future<void> AddLoginData(String mobileNumber, String device_id,
    String fcm_token, String userName, String userid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(TOKEN, fcm_token);
  prefs.setString(USER_NAME, userName);
  prefs.setString(USER_MOBILE, mobileNumber);
  prefs.setString(USER_ID, userid);
  prefs.setString(DEVICE_ID, device_id);
}
