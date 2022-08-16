import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdeliverycustomer/models/SearchDataModel.dart';

import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/ui/search/rounded_search_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';
import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/scale_animation.dart';
import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../uicomponents/AddtoCartView.dart';
import '../../uicomponents/MyProgressBar.dart';
import '../../uicomponents/SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../../utils/LocalStorageName.dart';
import '../../utils/Utils.dart';
import '../shop/ClearCartBottomDialog.dart';

class GlobalSearchScreen extends StatefulWidget {
  final String shop_id, category_id;

  GlobalSearchScreen(this.shop_id, this.category_id);

  @override
  GlobalSearchScreenState createState() => GlobalSearchScreenState();
}

class GlobalSearchScreenState extends State<GlobalSearchScreen>
    with TickerProviderStateMixin {
  SearchDataModel searchDataModel = SearchDataModel();
  bool IsBottomCartShow = false;

  @override
  void initState() {
    super.initState();
  }

  ButtonState buttonState = ButtonState.normal;
  String VersionName = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: whiteColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: false,
                backgroundColor: whiteColor,
                floating: true,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(),
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
                      Search,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Inter_bold,
                          color: blackColor),
                    ),
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Rounded_search_input_field(
                        hintText: SearchProduct,
                        onChanged: (value) {},
                        inputType: TextInputType.name,
                        icon: Icons.search,
                        Corner_radius: Full_Rounded_Button_Corner,
                        horizontal_margin: 15,
                        elevations: 2,
                        SubmittListner: (String value) {
                          print(value);
                          setState(() {
                            searchDataModel.status = false;
                          });
                          GetSearchProduct(value);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SearchListview(),
                  ],
                )
              ]))
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: HandleAddedtoCart()),
    );
  }

  Widget HandleAddedtoCart() {
    if (IsBottomCartShow) {
      return AddtoCartView(IsBottomCartShow, () {
        setState(() {
          IsBottomCartShow = false;
        });
      });
    } else {
      return Container();
    }
  }

  Widget SearchListview() {
    if (searchDataModel.status != null) {
      if (searchDataModel.status != false) {
        if (searchDataModel.products!.isNotEmpty) {
          return Container(
            padding: EdgeInsets.only(bottom: 70),
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                height: 210.0,
              ),
              itemCount: searchDataModel.products!.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  columnCount: 2,
                  position: index,
                  duration: Duration(milliseconds: AnimationTime),
                  child: ScaleAnimation(
                    scale: 0.5,
                    child: FadeInAnimation(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child: Image.asset(
                                    searchDataModel.products![index].variety ==
                                            1
                                        ? "${imagePath}veg.png"
                                        : "${imagePath}nonveg.png",
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      AddOrRemoveCart(
                                          searchDataModel
                                              .products![index].variants![0].id
                                              .toString(),
                                          "1",
                                          []);
                                    },
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: mainColor,
                                      size: 25,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: SizedBox(
                                  height: 110,
                                  width: 110,
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      searchDataModel
                                          .products![index].productImage
                                          .toString(),
                                    ),
                                    placeholder:
                                        AssetImage("${imagePath}ic_logo.png"),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 12, bottom: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    searchDataModel.products![index].productName
                                        .toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: Inter_bold,
                                        color: blackColor2),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    RUPPEE +
                                        searchDataModel
                                            .products![index].variants![0].price
                                            .toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: Inter_bold,
                                        color: mainColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return EmptyDataView();
        }
      }
      return Container(
          padding: EdgeInsets.only(top: 200), child: MyProgressBar());
    } else
      return Container();
  }

  Future<void> GetSearchProduct(String searchs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[search] = searchs;
    Params[address_id] = prefs.getString(SELECTED_ADDRESS_ID);
    Params[latitude] = prefs.getString(SELECTED_LATITUDE);
    Params[longitude] = prefs.getString(SELECTED_LONGITUDE);
    Params[device_id] = prefs.getString(DEVICE_ID);
    if (widget.shop_id.isNotEmpty) Params[shop_id] = widget.shop_id;
    if (widget.category_id.isNotEmpty) Params[category_id] = widget.category_id;
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(PRODUCT_SEARCH, data: Params);
    print("responseresponseresponse${response.data.toString()}");
    setState(() {
      searchDataModel = SearchDataModel.fromJson(response.data);
    });
    if (!response.data[status]) {
      ShowToast(response.data[message].toString(), context);
    }
  }

  Future<void> AddOrRemoveCart(
      String Product_id, String quanty, List<dynamic> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[id] = Product_id;
    Params[quantity] = quanty;
    Params[device_id] = prefs.getString(DEVICE_ID);
    if (list.isEmpty) {
      Params[toppings] = [];
    } else {
      Params[toppings] = list;
    }

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(MANAGE_PRODUCT, data: Params);
    print("responseresponseresponse${response.data.toString()}");
    if (response.data[refresh]) {
      _modalBottomSheetMenu(Product_id, quanty);
    } else {
      ShowToast(response.data[message].toString(), context);
      if (response.data[status]) {
        setState(() {
          if (response.data[quantity] != null && response.data[quantity] != 0) {
            IsBottomCartShow = true;
          } else {
            IsBottomCartShow = false;
          }
        });
      }
    }
  }

  void _modalBottomSheetMenu(String Product_id, String quanty) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder) {
          return ClearCartBottomDialog(
            Positivepress: () {
              RefreshCart(Product_id, quanty);
            },
            Nagetivepress: () {},
          );
        });
  }

  Future<void> RefreshCart(String Product_id, String quanty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[id] = Product_id;
    Params[quantity] = quanty;
    Params[device_id] = prefs.getString(DEVICE_ID);
    Params[toppings] = [];
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(REFRESH_CART, data: Params);
    print("RefreshCartRefreshCartResponse${response.data.toString()}");
    ShowToast(response.data[message].toString(), context);
    if (response.data[status]) {
      setState(() {
        if (response.data[quantity] != null && response.data[quantity] != 0) {
          IsBottomCartShow = true;
        } else {
          IsBottomCartShow = false;
        }
      });
    }
    Navigator.pop(context);
  }

  Widget EmptyDataView() {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        Image.asset(
          imagePath + "ic_searchempty.png",
          color: mainColor,
          height: 300,
          width: 300,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          NoProductFound,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
              fontSize: 16, fontFamily: Segoe_ui_semibold, color: greyColor),
        )
      ],
    );
  }
}
