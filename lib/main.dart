import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/res/ResString.dart';
import 'package:gdeliverycustomer/ui/home/HomeScreen.dart';
import 'package:gdeliverycustomer/ui/intro/IntroScreen.dart';
import 'package:gdeliverycustomer/ui/address/SelectAddressScreen.dart';
import 'package:gdeliverycustomer/ui/login/LoginScreen.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  var notyres = json.decode(message.data["data"]);

  flutterLocalNotificationsPlugin.show(
      5,
      notyres["title"].toString(),
      notyres["message"].toString(),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: Colors.blue,
          priority: Priority.max,
          playSound: true,
          icon: '@mipmap/launcher_icon',
        ),
      ));

  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Insuvai Customer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MySplashScreenPage(),
      ),
    );
  }
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
                    builder: (context) =>
                        SelectAddressScreen(false, "", false)),
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      PopUpNotification(message.data);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!');
      await Firebase.initializeApp();
      var notyres = json.decode(message.data["data"]);

      flutterLocalNotificationsPlugin.show(
          5,
          notyres["title"].toString(),
          notyres["message"].toString(),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              priority: Priority.max,
              playSound: true,
              icon: '@mipmap/launcher_icon',
            ),
          ));
    });
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Image(
          image: AssetImage('${imagePath}insuvai_splash.png'),
          fit: BoxFit.cover,
        ));
  }

  Future<void> PopUpNotification(Map<String, dynamic> data) async {
    var notyres = json.decode(data["data"]);
    flutterLocalNotificationsPlugin.show(
        5,
        notyres["title"].toString(),
        notyres["message"].toString(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: Colors.blue,
            priority: Priority.max,
            playSound: true,
            icon: '@mipmap/launcher_icon',
          ),
        ));

    showSimpleNotification(
      Text(
        notyres["title"].toString(),
        style: TextStyle(
          color: WhiteColor,
          fontSize: 15.0,
          fontFamily: Segoe_ui_bold,
        ),
      ),
      leading: NotificationBadge(),
      subtitle: Text(
        notyres["message"].toString(),
        style: TextStyle(
          color: WhiteColor,
          fontSize: 12.0,
          fontFamily: Segoe_ui_bold,
        ),
      ),
      background: MainColor,
      duration: Duration(seconds: 3),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  const NotificationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image:
              DecorationImage(image: AssetImage(imagePath + "ic_logo.png"))),
    );
  }
}
