import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/res/ResString.dart';
import 'package:gdeliverycustomer/ui/home/HomeScreen.dart';
import 'package:gdeliverycustomer/ui/intro/IntroScreen.dart';
import 'package:gdeliverycustomer/ui/address/SelectAddressScreen.dart';
import 'package:gdeliverycustomer/ui/login/LoginScreen.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: mainColor,
      statusBarColor: mainColor,
    ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: mainColor,
        primaryColor: mainColor,
        primarySwatch: Colors.blue,
      ),
      home: MySplashScreenPage(),
    );
  }

/*  Future<void> statusbaColorChange() async {
    await FlutterStatusbarcolor.setStatusBarColor(MainColor);
  }*/
}

class MySplashScreenPage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MySplashScreenPage> {
  Future checkFirstSeen() async {
    print("checkFirstSeen");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(const Duration(milliseconds: 2000), () {
      // Do something
      print("delayed");
      bool _seen = (prefs.getBool(introscreen) ?? false);
      print("DEVICE_IDDEVICE_ID${prefs.getString(DEVICE_ID)}");
      print("SELECTED_ADDRESS_ID${prefs.getString(SELECTED_ADDRESS_ID)}");
      if (_seen) {
        if (prefs.getBool(ISLOGIN) == true) {
          //Go to Home
          if (prefs.getString(SELECTED_ADDRESS_ID) == null) {
            //Go to address Selection
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectAddressScreen(
                        IsJustChangeAddress: false,
                        GstPer: "",
                        IsForCart: false,
                        isBackAvaillable: true)),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
          }
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
        }
      } else {
        prefs.setBool(introscreen, true);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => IntroScreen()),
            (Route<dynamic> route) => false);
      }
      print("_seen_seen_seen$_seen");
      return _seen;
    });
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: splashColor,
        child: Center(
          child: Lottie.asset(
            imagePath + 'gdsplash.json',
          ),
        ));
  }
} //Image(image: AssetImage('${IMAGE_PATH}gdelivery_splash.png'))
