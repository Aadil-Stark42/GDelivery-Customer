import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/models/ShopDetailsDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../models/ProductToppingDataModel.dart';
import '../../res/ResColor.dart';
import '../../res/ResString.dart';
import '../../uicomponents/MyProgressBar.dart';
import '../../utils/LocalStorageName.dart';
import '../../utils/Utils.dart';

var QtyId = "";
List TappingId = [];

class MainTappingView extends StatefulWidget {
  final ShopProducts shopProducts;

  MainTappingView(this.shopProducts);

  @override
  State<MainTappingView> createState() => _MainTappingViewState();
}

class _MainTappingViewState extends State<MainTappingView> {
  ProductToppingDataModel productToppingDataModel = ProductToppingDataModel();
  List<bool> CheckBOxHandleList = [];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ShopProducts shopProductsList = widget.shopProducts;
    return FutureBuilder<ProductToppingDataModel>(
      future: GetTappingData(shopProductsList.productId), // async work
      builder: (BuildContext context,
          AsyncSnapshot<ProductToppingDataModel> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return MyProgressBar();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              productToppingDataModel =
                  snapshot.data as ProductToppingDataModel;
              return TappingDataView();
            }
        }
      },
    );
  }

  Future<ProductToppingDataModel> GetTappingData(int? productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");

    var Params = <String, dynamic>{};
    Params[product_id] = productId;

    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(PRODUCT_CUSTOMIZE, data: Params);
    print("responseresponseresponse${response.data.toString()}");
    if (ProductToppingDataModel.fromJson(response.data).status != true) {
      ShowToast(
          ProductToppingDataModel.fromJson(response.data).message.toString(),
          context);
    }

    return ProductToppingDataModel.fromJson(response.data);
  }

  Widget TappingDataView() {
    print(
        "productToppingDataModel.status  ${productToppingDataModel.status.toString()}");
    if (productToppingDataModel.status != null &&
        productToppingDataModel.status != false) {
      QtyId = productToppingDataModel.quantity![selectedIndex].id.toString();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Choice,
            softWrap: true,
            style: TextStyle(
                fontSize: 14, fontFamily: Segoe_ui_bold, color: blackColor),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: productToppingDataModel.quantity!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  splashColor: greyColor2,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      print(
                          "selectedIndexselectedIndexselectedIndex $selectedIndex");
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset(
                              productToppingDataModel
                                          .quantity![index].variety ==
                                      1
                                  ? "${imagePath}veg.png"
                                  : "${imagePath}nonveg.png",
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Image.asset(
                              selectedIndex == index
                                  ? "${imagePath}select_button.png"
                                  : "${imagePath}unselect_button.png",
                              height: 30,
                              width: 30,
                              color: greyColor,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              productToppingDataModel.quantity![index].size
                                  .toString(),
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: Segoe_ui_semibold,
                                  color: blackColor2),
                            )
                          ],
                        ),
                      ),
                      Text(
                        RUPPEE +
                            productToppingDataModel.quantity![index].price
                                .toString(),
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: Segoe_ui_semibold,
                            color: greyColor),
                      ),
                      const SizedBox(
                        width: 80,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.maxFinite,
            height: 0.5,
            color: greyColor2,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            ADDONS,
            softWrap: true,
            style: TextStyle(
                fontSize: 14, fontFamily: Segoe_ui_bold, color: blackColor),
          ),
          SizedBox(
            height: 5,
          ),
          ActualTappingListview()
        ],
      );
    } else {
      return MyProgressBar();
    }
  }

  Widget ActualTappingListview() {
    if (productToppingDataModel.toppings!.isNotEmpty) {
      productToppingDataModel.toppings!.forEach((element) {
        CheckBOxHandleList.add(false);
      });
      TappingId.clear();
      for (var i = 0; i < CheckBOxHandleList.length; i++) {
        if (CheckBOxHandleList[i]) {
          TappingId.add(productToppingDataModel.toppings![i]);
        }
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: productToppingDataModel.toppings!.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              splashColor: greyColor2,
              onTap: () {
                setState(() {
                  if (CheckBOxHandleList[index] == true) {
                    CheckBOxHandleList[index] = false;
                  } else {
                    CheckBOxHandleList[index] = true;
                  }
                  print(
                      "selectedIndexselectedIndexselectedIndex $selectedIndex");
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          productToppingDataModel.toppings![index].variety == 1
                              ? "${imagePath}veg.png"
                              : "${imagePath}nonveg.png",
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Image.asset(
                          CheckBOxHandleList[index] == true
                              ? "${imagePath}checkbox.png"
                              : "${imagePath}uncheckbox.png",
                          height: 16,
                          width: 16,
                          color: greyColor,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          productToppingDataModel.toppings![index].name
                              .toString(),
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: Segoe_ui_semibold,
                              color: blackColor2),
                        )
                      ],
                    ),
                  ),
                  Text(
                    RUPPEE +
                        productToppingDataModel.toppings![index].price
                            .toString(),
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: Segoe_ui_semibold,
                        color: greyColor),
                  ),
                  const SizedBox(
                    width: 80,
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        height: 1,
        width: 1,
      );
    }
  }
}
