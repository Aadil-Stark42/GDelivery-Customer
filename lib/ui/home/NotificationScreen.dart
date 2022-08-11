import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/uicomponents/MyProgressBar.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:permission_handler/permission_handler.dart' as permis;
import 'package:shared_preferences/shared_preferences.dart';

import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/animation_limiter.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/scale_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../imageslider/carousel_slider.dart';
import '../../models/DashBoardDataModell.dart';
import '../../models/NotificationDataListModel.dart';
import '../../models/WishListDataModel.dart';
import '../../res/ResString.dart';
import '../../uicomponents/progress_button.dart';
import '../../utils/Utils.dart';
import '../shop/ShopDetailsScreen.dart';
import 'homesubscreen/CartSubScreen.dart';
import 'homesubscreen/CategorySearchScreen.dart';
import 'homesubscreen/HomeSubScreen.dart';
import 'homesubscreen/ProfileScreen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  NotificationDataListModel _notificationDataListModel =
      NotificationDataListModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: WhiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            backgroundColor: WhiteColor,
            floating: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(),
            elevation: 2,
            forceElevated: true,
            centerTitle: false,
            leading: null,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(imagePath + "back_arrow.png",
                      height: 25, width: 25),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  Notifications,
                  style: TextStyle(
                      fontSize: 16, fontFamily: Inter_bold, color: BlackColor),
                ),
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([FevoriteListDataView()]))
        ],
      ),
    );
  }

  Widget FevoriteListDataView() {
    Size size = MediaQuery.of(context).size;
    if (_notificationDataListModel.notificationList != null) {
      if (_notificationDataListModel.notificationList!.isNotEmpty) {
        return Container(
          padding: EdgeInsets.only(top: 20),
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _notificationDataListModel.notificationList!.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: AnimationTime),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        _notificationDataListModel
                                            .notificationList![index].image
                                            .toString(),
                                      ),
                                      placeholder: AssetImage(
                                          "${imagePath}ic_logo.png"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _notificationDataListModel
                                        .notificationList![index].notifyHead
                                        .toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: Inter_bold,
                                        color: BlackColor),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    _notificationDataListModel
                                        .notificationList![index].description
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: Poppinsmedium,
                                        color: GreyColor),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        return EmptyDataView();
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.7),
        child: MyProgressBar(),
      );
    }
  }

  Future<Response> GetNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.get(NOTIFICATION_LIST);
    print("responseresponseresponse${response.data.toString()}");
    setState(() {
      _notificationDataListModel =
          NotificationDataListModel.fromJson(response.data);
    });
    if (response.data[status] != true) {
      ShowToast(response.data[message].toString(), context);
    }
    return response;
  }

  Widget EmptyDataView() {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        Image.asset(
          imagePath + "ic_notificationempty.png",
          color: MainColor,
          height: 300,
          width: 300,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          NotificationdontYouhave,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
              fontSize: 16, fontFamily: Segoe_ui_semibold, color: GreyColor),
        )
      ],
    );
  }
}
