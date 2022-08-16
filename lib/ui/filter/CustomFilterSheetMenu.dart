import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gdeliverycustomer/models/SearchDataModel.dart';

import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/ui/search/rounded_search_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';
import '../../animationlist/src/animation_configuration.dart';
import '../../animationlist/src/fade_in_animation.dart';
import '../../animationlist/src/scale_animation.dart';
import '../../animationlist/src/slide_animation.dart';
import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../models/CuisinesListDataModel.dart';
import '../../models/PricingFilterModel.dart';
import '../../models/RatingFilterModel.dart';
import '../../models/SortFilterModel.dart';
import '../../uicomponents/AddtoCartView.dart';
import '../../uicomponents/MyProgressBar.dart';
import '../../uicomponents/SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../../utils/LocalStorageName.dart';
import '../../utils/Utils.dart';
import '../shop/ClearCartBottomDialog.dart';

class CustomFilterSheetMenu extends StatefulWidget {
  final CuisinesListDataModel cuisinesListDataModel;
  final ValueSetter<Map<String, dynamic>> SubmittListner;
  final VoidCallback ClearListner;

  CustomFilterSheetMenu(
      this.cuisinesListDataModel, this.SubmittListner, this.ClearListner);

  @override
  CustomFilterSheetMenuState createState() => CustomFilterSheetMenuState();
}

class CustomFilterSheetMenuState extends State<CustomFilterSheetMenu>
    with TickerProviderStateMixin {
  int FilterNameCurrentIndex = 0;
  int FilterTitleCurrentIndex = 0;

  String Selected_Rating_id = "",
      Selected_short_id = "",
      Seleteced_Pricing_id = "";
  List<int> Shops_Id = [];
  List FilterName = ['Sort', 'Shop', 'Rating', 'Pricing'];
  List<SortFilterModel> sort_list = [
    SortFilterModel("1", "Relevance"),
    SortFilterModel("1", "Popularity"),
    SortFilterModel("2", "Price: High - Low"),
    SortFilterModel("3", "Price: Low - High"),
    SortFilterModel("4", "Delivery time"),
  ];
  List<RatingFilterModel> rating_list = [
    RatingFilterModel("4", "4★ & above"),
    RatingFilterModel("3", "3★ & above"),
    RatingFilterModel("2", "2★ & above"),
    RatingFilterModel("1", "1★ & above"),
  ];
  List<PricingFilterModel> pricing_list = [
    PricingFilterModel("4", "Above ₹8"),
    PricingFilterModel("3", "Above ₹5 and Below ₹8"),
    PricingFilterModel("2", "Above ₹3 and Below ₹5"),
    PricingFilterModel("1", "Below ₹3"),
  ];
  int FilterSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Filter,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Inter_bold,
                          color: blackColor),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            print("Selected_Rating_id $Selected_Rating_id");
                            print("Selected_short_id $Selected_short_id");
                            print("Seleteced_Pricing_id $Seleteced_Pricing_id");
                            Shops_Id.clear();
                            widget.cuisinesListDataModel.cuisines!
                                .forEach((element) {
                              if (element.isCheck == true) {
                                Shops_Id.add(element.cuisineId!.toInt());
                              }
                            });
                            var FuilterData = <String, dynamic>{};
                            FuilterData[SORT_ID] = Selected_short_id;
                            FuilterData[RATING_ID] = Selected_Rating_id;
                            FuilterData[PRICING_ID] = Seleteced_Pricing_id;
                            FuilterData[SHOPS_ID] = Shops_Id;

                            widget.SubmittListner(FuilterData);
                            Navigator.pop(context);
                          },
                          child: Text(
                            Apply,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: Segoe_ui_semibold,
                                color: mainColor),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            widget.ClearListner();
                            Navigator.pop(context);
                          },
                          child: Text(
                            Clear,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: Segoe_ui_semibold,
                                color: mainColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 0.5,
                color: greyColor2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: Column(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: FilterName.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: Duration(milliseconds: AnimationTime),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      FilterTitleCurrentIndex = index;
                                      FilterNameCurrentIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 15,
                                        right: 15,
                                        bottom: 10),
                                    child: Text(
                                      FilterName[index].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: Segoe_ui_semibold,
                                          color:
                                              FilterTitleCurrentIndex == index
                                                  ? blackColor
                                                  : greyColor),
                                    ),
                                  ),
                                )),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: FilterSecondList(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget FilterSecondList() {
    if (FilterNameCurrentIndex == 0) {
      Selected_short_id = sort_list[FilterSelectedIndex].filter_id!;
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: sort_list.length,
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
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      FilterSelectedIndex = index;
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        FilterSelectedIndex == index
                            ? "${imagePath}select_button.png"
                            : "${imagePath}unselect_button.png",
                        height: 25,
                        width: 25,
                        color: greyColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        sort_list[index].filter_name.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoe_ui_semibold,
                            color: FilterSelectedIndex == index
                                ? blackColor
                                : greyColor),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          );
        },
      );
    } else if (FilterNameCurrentIndex == 1) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.cuisinesListDataModel.cuisines!.length,
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
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (widget
                              .cuisinesListDataModel.cuisines![index].isCheck ==
                          true) {
                        widget.cuisinesListDataModel.cuisines![index].isCheck =
                            false;
                      } else {
                        widget.cuisinesListDataModel.cuisines![index].isCheck =
                            true;
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        widget.cuisinesListDataModel.cuisines![index].isCheck ==
                                true
                            ? "${imagePath}select_button.png"
                            : "${imagePath}unselect_button.png",
                        height: 25,
                        width: 25,
                        color: greyColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget
                            .cuisinesListDataModel.cuisines![index].cuisineName
                            .toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoe_ui_semibold,
                            color: widget.cuisinesListDataModel.cuisines![index]
                                        .isCheck ==
                                    true
                                ? blackColor
                                : greyColor),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          );
        },
      );
    } else if (FilterNameCurrentIndex == 2) {
      Selected_Rating_id = rating_list[FilterSelectedIndex].filter_id!;
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rating_list.length,
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
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      FilterSelectedIndex = index;
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        FilterSelectedIndex == index
                            ? "${imagePath}select_button.png"
                            : "${imagePath}unselect_button.png",
                        height: 25,
                        width: 25,
                        color: greyColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        rating_list[index].filter_name.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoe_ui_semibold,
                            color: FilterSelectedIndex == index
                                ? blackColor
                                : greyColor),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          );
        },
      );
    } else {
      Seleteced_Pricing_id = pricing_list[FilterSelectedIndex].filter_id!;
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pricing_list.length,
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
                padding: const EdgeInsets.only(
                    top: 10, left: 15, right: 15, bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      FilterSelectedIndex = index;
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        FilterSelectedIndex == index
                            ? "${imagePath}select_button.png"
                            : "${imagePath}unselect_button.png",
                        height: 25,
                        width: 25,
                        color: greyColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        pricing_list[index].filter_name.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Segoe_ui_semibold,
                            color: FilterSelectedIndex == index
                                ? blackColor
                                : greyColor),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          );
        },
      );
    }
  }
}
