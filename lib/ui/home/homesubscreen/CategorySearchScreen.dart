import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:gdeliverycustomer/apiservice/EndPoints.dart';
import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/uicomponents/MyProgressBar.dart';
import 'package:gdeliverycustomer/utils/LocalStorageName.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/DashBoardDataModell.dart';
import '../../../animationlist/src/animation_configuration.dart';
import '../../../animationlist/src/animation_limiter.dart';
import '../../../animationlist/src/fade_in_animation.dart';
import '../../../animationlist/src/scale_animation.dart';
import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../utils/Utils.dart';
import '../../search/GlobalSearchScreen.dart';
import '../../shop/ShopListScreen.dart';

class CategorySearchScreen extends StatefulWidget {
  @override
  CategorySearchScreenState createState() => CategorySearchScreenState();
}

class CategorySearchScreenState extends State<CategorySearchScreen> {
  @override
  void initState() {
    super.initState();
    GetDashBoardList();
  }

  DashBoardDataModel DashBoardData = DashBoardDataModel();

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    Category,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Inter_bold,
                        color: BlackColor),
                  ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => GlobalSearchScreen("", "")),
                    );
                  },
                  child: Image.asset(imagePath + "ic_search.png",
                      height: 20, width: 20),
                ),
                SizedBox(
                  width: 15,
                )
              ]),
          SliverList(delegate: SliverChildListDelegate([CategoyDataView()]))
        ],
      ),
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
      DashBoardData = DashBoardDataModel.fromJson(response.data);
      print("responseresponseresponse${DashBoardData.category1?.length}");

      if (DashBoardData.status != true) {
        ShowToast(DashBoardData.message.toString(), context);
      }
    });
  }

  Widget CategoyDataView() {
    Size size = MediaQuery.of(context).size;
    if (DashBoardData.status != null && DashBoardData.status != false) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: AnimationLimiter(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            children: List.generate(
              DashBoardData.category1!.length,
              (int index) {
                print(DashBoardData.category1![index].banner);
                return AnimationConfiguration.staggeredGrid(
                  columnCount: 3,
                  position: index,
                  duration: Duration(milliseconds: AnimationTime),
                  child: ScaleAnimation(
                    scale: 0.5,
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => ShopListScreen(
                                    DashBoardData.category1![index].id
                                        .toString(),
                                    DashBoardData.category1![index].name
                                        .toString(),
                                    true)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    DashBoardData.category1![index].banner
                                        .toString(),
                                  ),
                                  placeholder:
                                      AssetImage("${imagePath}ic_logo.png"),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 5, right: 5),
                                child: Text(
                                  DashBoardData.category1![index].name
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.1,
                                    fontFamily: Inter_bold,
                                    fontSize: 12,
                                    letterSpacing: 0.27,
                                    color: BlackColor,
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
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: size.height / 2.7),
        child: MyProgressBar(),
      );
    }
  }
}
