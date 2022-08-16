import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/ui/home/FavoriteScreen.dart';
import 'package:gdeliverycustomer/ui/home/NotificationScreen.dart';
import 'package:gdeliverycustomer/ui/shop/ShopDetailsScreen.dart';
import 'package:gdeliverycustomer/ui/shop/ShopListScreen.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:update_available/update_available.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../locationpicker/src/place_picker.dart';
import '../../../models/DashBoardDataModell.dart';
import '../../../animationlist/src/animation_configuration.dart';
import '../../../animationlist/src/animation_limiter.dart';
import '../../../animationlist/src/fade_in_animation.dart';
import '../../../animationlist/src/scale_animation.dart';
import '../../../animationlist/src/slide_animation.dart';
import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../imageslider/carousel_slider.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/MyProgressBar.dart';
import '../../../utils/Utils.dart';
import '../../search/GlobalSearchScreen.dart';
import '../AppMaintainanceScreen.dart';

class HomeSubScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeSubScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomeSubScreen extends StatefulWidget {
  @override
  MyHomeSubScreenState createState() => MyHomeSubScreenState();
}

class MyHomeSubScreenState extends State<MyHomeSubScreen> {
  DashBoardDataModel DashBoardData = DashBoardDataModel();
  String SelectedAddressType = "", SelectedAddress = "";
  late List<Widget> imageSliders = [];
  late List<Widget> AllRestaurantFoodList = [];
  late List<Widget> BottomBannerList = [];
  int FeaturCatShrinkLength = 0;
  String SeeMore = "See All";
  bool IsvisibleSeeMore = false;

  @override
  void initState() {
    print("initStateinitState");
    super.initState();
    printAvailability();
    GetDashBoardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: MainHomeDataView(),
    );
  }

  Future<void> GetDashBoardList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);

    Response response;
    response = await ApiCalling.post(DASHBOARD, data: Params);
    setState(() {
      SelectedAddressType = prefs.getString(SELECTED_ADDDRESS_TYPE)!;
      SelectedAddress = prefs.getString(SELECTED_ADDDRESS)!;

      DashBoardData = DashBoardDataModel.fromJson(response.data);
      CHECKAPPSTATUS = DashBoardData.appStatus.toString();
      print("responseresponseresponse${response.data.toString()}");
      prefs.setString(
          TERMS_CONDITION, DashBoardData.termsAndConditions.toString());
      prefs.setString(PRIVACY_POLICY, DashBoardData.privacyPolicy.toString());
      prefs.setString(MOBILE_CONTACT, DashBoardData.conatct!.mobile.toString());
      prefs.setString(EMAIL_CONTACT, DashBoardData.conatct!.email.toString());
      prefs.setString(
          WHATSAPP_CONTACT, DashBoardData.conatct!.whatsapp.toString());
      if (DashBoardData.shopBanners?.isNotEmpty == true) {
        DashBoardData.shopBanners?.forEach((element) {
          imageSliders.add(ImageSlideView(element));
        });
        DashBoardData.category1?.forEach((element) {
          AllRestaurantFoodList.add(RestaurantFoodView(element));
        });
        DashBoardData.banners?.forEach((element) {
          BottomBannerList.add(BottomBannerView(element));
        });
      }
      if (DashBoardData.catList!.length <= 6) {
        IsvisibleSeeMore = false;
        FeaturCatShrinkLength = DashBoardData.catList!.length;
      } else {
        IsvisibleSeeMore = true;
        FeaturCatShrinkLength = 6;
      }
      if (DashBoardData.status == true) {
      } else {
        ShowToast(DashBoardData.message.toString(), context);
      }
    });
  }

  Widget ImageSlideView(ShopBanners element) {
    return Container(
      width: double.maxFinite,
      child: FadeInImage(
          fit: BoxFit.cover,
          placeholder: AssetImage(imagePath + "no_image_placeholder.png"),
          image: NetworkImage(element.image.toString())),
    );
  }

  Widget RestaurantFoodView(Category1 element) {
    print("IMAGEEEEEEFOOD${element.image}");
    return GestureDetector(
      onTap: () {
        if (CHECKAPPSTATUS == STATUSNUMBER) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (context) => AppMaintainanceScreen(true)),
          );
        } else {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
                builder: (context) => ShopListScreen(
                    element.id.toString(), element.name.toString(), true)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              children: <Widget>[
                Image.network(element.image.toString(),
                    fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child: Container(
                    color: transBlackColor,

                    /* decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(0, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    )*/
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element.name.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontFamily: Inter_bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: whiteColor,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Image.asset(
                              "${imagePath}right-arrow.png",
                              height: 15,
                              width: 15,
                              color: mainColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget BottomBannerView(Banners element) {
    print("IMAGEEEEEEFOOD${element.image}");
    return Container(
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8, top: 20),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: FadeInImage(
                placeholder: AssetImage(imagePath + "no_image_placeholder.png"),
                image: NetworkImage(element.image.toString()))),
      ),
    );
  }

  Widget MainHomeDataView() {
    if (DashBoardData.status != null) {
      return RefreshIndicator(
        onRefresh: refreshMethod,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                pinned: false,
                backgroundColor: mainColor,
                floating: true,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(),
                elevation: 0.5,
                title: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          OpenLocationPicker();
                                        },
                                        child: Image(
                                          image: AssetImage(
                                              "${imagePath}location.png"),
                                          width: 22,
                                          height: 22,
                                          color: whiteColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Flexible(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              OpenLocationPicker();
                                            },
                                            child: Text(
                                              SelectedAddressType,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: Segoe_ui_bold,
                                                  color: whiteColor),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              OpenLocationPicker();
                                            },
                                            child: Text(
                                              SelectedAddress,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  height: 1.1,
                                                  fontFamily: Segoeui,
                                                  color: whiteColor),
                                            ),
                                          )
                                        ],
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                actions: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (CHECKAPPSTATUS == STATUSNUMBER) {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AppMaintainanceScreen(true)),
                            );
                          } else {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GlobalSearchScreen("", "")),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(
                            Icons.search,
                            color: whiteColor,
                            size: 25,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (CHECKAPPSTATUS == STATUSNUMBER) {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AppMaintainanceScreen(true)),
                            );
                          } else {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => FavoriteScreen()),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                          child: Icon(
                            Icons.favorite_border,
                            color: whiteColor,
                            size: 25,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (CHECKAPPSTATUS == STATUSNUMBER) {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AppMaintainanceScreen(true)),
                            );
                          } else {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => NotificationScreen()),
                            );
                          }
                        },
                        child: Stack(
                          children: <Widget>[
                            const Icon(
                              Icons.notifications_outlined,
                              color: whiteColor,
                              size: 25,
                            ),
                            Positioned(
                                right: 0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 2, 0),
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      DashBoardData.notificationCount
                                          .toString(),
                                      style: TextStyle(
                                        color: blackColor,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ]),
            SliverList(
                delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: imageSliders,
                    options: CarouselOptions(
                        height: 170,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          // setState(() {
                          //   // _current = index;
                          // });
                        }),
                  ),
                  Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 15, top: 30),
                          child: Text(
                            TopRestaurant,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: Inter_bold,
                                color: blackColor),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 10, bottom: 0, top: 50),
                          child: Container(
                            height: 150,
                            child: AnimationLimiter(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: DashBoardData.topBadge?.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration:
                                        Duration(milliseconds: AnimationTime),
                                    child: SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (CHECKAPPSTATUS == STATUSNUMBER) {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppMaintainanceScreen(
                                                          true)),
                                            );
                                          } else {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShopDetailsScreen(
                                                          DashBoardData
                                                              .topBadge![index]
                                                              .id
                                                              .toString(),
                                                          DashBoardData
                                                              .topBadge![index]
                                                              .shopCategroyId
                                                              .toString(),
                                                          DashBoardData
                                                              .topBadge![index]
                                                              .name
                                                              .toString(),
                                                          () {})),
                                            );
                                          }
                                        },
                                        child: FadeInAnimation(
                                            child: Row(
                                          children: [
                                            index == 0
                                                ? InkWell(
                                                    onTap: () {
                                                      if (CHECKAPPSTATUS ==
                                                          STATUSNUMBER) {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AppMaintainanceScreen(
                                                                      true)),
                                                        );
                                                      } else {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .push(
                                                          MaterialPageRoute(
                                                              builder: (context) => ShopListScreen(
                                                                  DashBoardData
                                                                      .category1![
                                                                          0]
                                                                      .id
                                                                      .toString(),
                                                                  DashBoardData
                                                                      .category1![
                                                                          0]
                                                                      .name
                                                                      .toString(),
                                                                  true)),
                                                        );
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Container(
                                                              width: 70,
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color:
                                                                          blackColor,
                                                                      width: 1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              48)),
                                                              child: Center(
                                                                child: Text(
                                                                  "View All",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          Segoe_ui_bold,
                                                                      color:
                                                                          blackColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Container(
                                                      width: 70,
                                                      height: 70,
                                                      child: CircleAvatar(
                                                        radius: 48,
                                                        backgroundColor:
                                                            mainColor,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                DashBoardData
                                                                    .topBadge![
                                                                        index]
                                                                    .image
                                                                    .toString()),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              left: 0,
                                                              right: 0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 80,
                                                        child: Text(
                                                          DashBoardData
                                                              .topBadge![index]
                                                              .name
                                                              .toString(),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            height: 1.3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontFamily:
                                                                Inter_bold,
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 0.27,
                                                            color: blackColor,
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ))
                    ],
                  ),
                  CarouselSlider(
                    items: AllRestaurantFoodList,
                    options: CarouselOptions(
                        height: 140,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          // setState(() {
                          //   // _current = index;
                          // });
                        }),
                  ),
                  Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 15, top: 30),
                          child: Text(
                            FeaturesCategories,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: Inter_bold,
                                color: blackColor),
                          )),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 0, top: 20),
                            child: AnimationLimiter(
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                children: List.generate(
                                  FeaturCatShrinkLength,
                                  (int index) {
                                    return AnimationConfiguration.staggeredGrid(
                                      columnCount: 3,
                                      position: index,
                                      duration:
                                          Duration(milliseconds: AnimationTime),
                                      child: ScaleAnimation(
                                        scale: 0.5,
                                        child: FadeInAnimation(
                                          child: InkWell(
                                            onTap: () {
                                              if (CHECKAPPSTATUS ==
                                                  STATUSNUMBER) {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AppMaintainanceScreen(
                                                              true)),
                                                );
                                              } else {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShopListScreen(
                                                              DashBoardData
                                                                  .catList![
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                              DashBoardData
                                                                  .catList![
                                                                      index]
                                                                  .name
                                                                  .toString(),
                                                              false)),
                                                );
                                              }
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 75,
                                                  width: 75,
                                                  child: FadeInImage(
                                                    image: NetworkImage(
                                                      catImagePath +
                                                          DashBoardData
                                                              .catList![index]
                                                              .image
                                                              .toString(),
                                                    ),
                                                    placeholder: AssetImage(
                                                        "${imagePath}ic_logo.png"),
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            left: 5,
                                                            right: 5),
                                                    child: Text(
                                                      DashBoardData
                                                          .catList![index].name
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        height: 1.1,
                                                        fontFamily: Inter_bold,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.27,
                                                        color: blackColor,
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (SeeMore == "See All") {
                                    SeeMore = "See Less";
                                    FeaturCatShrinkLength =
                                        DashBoardData.catList!.length;
                                  } else {
                                    SeeMore = "See All";
                                    FeaturCatShrinkLength = 6;
                                  }
                                });
                              },
                              child: Text(
                                SeeMore,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: Inter_bold,
                                    color: mainColor),
                              ),
                            ),
                            visible: IsvisibleSeeMore,
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      )
                    ],
                  ),
                  CarouselSlider(
                    items: BottomBannerList,
                    options: CarouselOptions(
                        height: 160,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          // setState(() {
                          //   // _current = index;
                          // });
                        }),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ]))
          ],
        ),
      );
    } else {
      return MyProgressBar();
    }
  }

  Future<void> OpenLocationPicker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: Platform.isAndroid ? MAP_API_KEY : "YOUR IOS API KEY",
          onPlacePicked: (result) {
            print(result.formattedAddress);
            Navigator.of(context).pop();
            prefs.setString(
                SELECTED_LATITUDE, result.geometry!.location.lat.toString());
            prefs.setString(
                SELECTED_LONGITUDE, result.geometry!.location.lng.toString());
            prefs.setString(
                SELECTED_ADDDRESS, result.formattedAddress.toString());
            GetDashBoardList();
          },
          selectInitialPosition: true,
          IsComeFromHome: true,
          initialPosition: LatLng(
              double.parse(prefs.getString(SELECTED_LATITUDE).toString()),
              double.parse(prefs.getString(SELECTED_LONGITUDE).toString())),
          useCurrentLocation: false,
        ),
      ),
    );
  }

  void printAvailability() async {
    final updateAvailability = await getUpdateAvailability();

    updateAvailability.fold(
      available: () => {_showVersionDialog()},
      notAvailable: () => "",
      unknown: () => "It was not possible to determine if there is or not "
          "an update for your app.",
    );
  }

  _showVersionDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(APP_STORE_URL),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(PLAY_STORE_URL),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> refreshMethod() async {
    setState(() {
      DashBoardData.status = null;
    });
    printAvailability();
    GetDashBoardList();
  }
}

final List<String> imgList = [];
