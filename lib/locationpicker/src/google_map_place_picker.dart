import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gdeliverycustomer/locationpicker/google_maps_place_picker.dart';
import 'package:gdeliverycustomer/locationpicker/providers/place_provider.dart';
import 'package:gdeliverycustomer/locationpicker/src/components/animated_pin.dart';
import 'package:gdeliverycustomer/locationpicker/src/components/floating_card.dart';
import 'package:gdeliverycustomer/locationpicker/src/place_picker.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:gdeliverycustomer/utils/Utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'dart:math' as math;

import '../../apiservice/ApiService.dart';
import '../../apiservice/EndPoints.dart';
import '../../res/ResColor.dart';
import '../../res/ResString.dart';
import '../../uicomponents/RoundedBorderButton.dart';
import '../../uicomponents/progress_button.dart';
import '../../uicomponents/rounded_input_field.dart';
import '../../utils/LocalStorageName.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PickResult? selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key? key,
    required this.initialTarget,
    required this.appBarKey,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.pickArea,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.selectText,
    this.outsideOfPickAreaText,
    this.IsComeFromHome,
  }) : super(key: key);

  final LatLng initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  final ValueChanged<String>? onSearchFailed;
  final VoidCallback? onMoveStart;
  final MapCreatedCallback? onMapCreated;
  final VoidCallback? onToggleMapType;
  final VoidCallback? onMyLocation;
  final ValueChanged<PickResult>? onPlacePicked;

  final int? debounceMilliseconds;
  final bool? enableMapTypeButton;
  final bool? enableMyLocationButton;

  final bool? usePinPointingSearch;
  final bool? usePlaceDetailSearch;

  final bool? selectInitialPosition;

  final String? language;
  final CircleArea? pickArea;

  final bool? forceSearchOnZoomChanged;
  final bool? hidePlaceDetailsWhenDraggingPin;

  /// GoogleMap pass-through events:
  final Function(PlaceProvider)? onCameraMoveStarted;
  final CameraPositionCallback? onCameraMove;
  final Function(PlaceProvider)? onCameraIdle;

  // strings
  final String? selectText;
  final bool? IsComeFromHome;
  final String? outsideOfPickAreaText;

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    if (forceSearchOnZoomChanged == false &&
        provider.prevCameraPosition != null &&
        provider.prevCameraPosition!.target.latitude ==
            provider.cameraPosition!.target.latitude &&
        provider.prevCameraPosition!.target.longitude ==
            provider.cameraPosition!.target.longitude) {
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    provider.placeSearchingState = SearchingState.Searching;

    final GeocodingResponse response =
        await provider.geocoding.searchByLocation(
      Location(
          lat: provider.cameraPosition!.target.latitude,
          lng: provider.cameraPosition!.target.longitude),
      language: language,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("Camera Location Search Error: " + response.errorMessage!);
      if (onSearchFailed != null) {
        onSearchFailed!(response.status);
      }
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    if (usePlaceDetailSearch!) {
      final PlacesDetailsResponse detailResponse =
          await provider.places.getDetailsByPlaceId(
        response.results[0].placeId,
        language: language,
      );

      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == "REQUEST_DENIED") {
        print("Fetching details by placeId Error: " +
            detailResponse.errorMessage!);
        if (onSearchFailed != null) {
          onSearchFailed!(detailResponse.status);
        }
        provider.placeSearchingState = SearchingState.Idle;
        return;
      }

      provider.selectedPlace =
          PickResult.fromPlaceDetailResult(detailResponse.result);
    } else {
      provider.selectedPlace =
          PickResult.fromGeocodingResult(response.results[0]);
    }

    provider.placeSearchingState = SearchingState.Idle;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildGoogleMap(context),
        _buildPin(),
        _buildFloatingCard(),
        _buildMapIcons(context),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, MapType>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          CameraPosition initialCameraPosition =
              CameraPosition(target: initialTarget, zoom: 15);

          return GoogleMap(
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: initialCameraPosition,
            mapType: data,
            myLocationEnabled: true,
            circles: pickArea != null && pickArea!.radius > 0
                ? Set<Circle>.from([pickArea])
                : Set<Circle>(),
            onMapCreated: (GoogleMapController controller) {
              provider.mapController = controller;
              provider.setCameraPosition(null);
              provider.pinState = PinState.Idle;

              // When select initialPosition set to true.
              if (selectInitialPosition!) {
                provider.setCameraPosition(initialCameraPosition);
                _searchByCameraLocation(provider);
              }

              if (onMapCreated != null) {
                onMapCreated!(controller);
              }
            },
            onCameraIdle: () {
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.Idle;
                provider.placeSearchingState = SearchingState.Idle;
                return;
              }

              // Perform search only if the setting is to true.
              if (usePinPointingSearch!) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.Dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer!.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds!), () {
                    _searchByCameraLocation(provider);
                  });
                }
              }

              provider.pinState = PinState.Idle;

              if (onCameraIdle != null) {
                onCameraIdle!(provider);
              }
            },
            onCameraMoveStarted: () {
              if (onCameraMoveStarted != null) {
                onCameraMoveStarted!(provider);
              }

              provider.setPrevCameraPosition(provider.cameraPosition);

              // Cancel any other timer.
              provider.debounceTimer?.cancel();

              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.Dragging;

              // Begins the search state if the hide details is enabled
              if (this.hidePlaceDetailsWhenDraggingPin!) {
                provider.placeSearchingState = SearchingState.Searching;
              }

              onMoveStart!();
            },
            onCameraMove: (CameraPosition position) {
              provider.setCameraPosition(position);
              if (onCameraMove != null) {
                onCameraMove!(position);
              }
            },
            // gestureRecognizers make it possible to navigate the map when it's a
            // child in a scroll view e.g ListView, SingleChildScrollView...
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
          );
        });
  }

  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) =>
                    pinBuilder!(builderContext, state));
          }
        },
      ),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 36, color: Colors.red),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                    child: Icon(Icons.place, size: 36, color: Colors.red)),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFloatingCard() {
    return Selector<PlaceProvider,
        Tuple4<PickResult?, SearchingState, bool, PinState>>(
      selector: (_, provider) => Tuple4(
          provider.selectedPlace,
          provider.placeSearchingState,
          provider.isSearchBarFocused,
          provider.pinState),
      builder: (context, data, __) {
        if ((data.item1 == null && data.item2 == SearchingState.Idle) ||
            data.item3 == true ||
            data.item4 == PinState.Dragging &&
                this.hidePlaceDetailsWhenDraggingPin!) {
          return Container();
        } else {
          if (selectedPlaceWidgetBuilder == null) {
            return _defaultPlaceWidgetBuilder(context, data.item1, data.item2);
          } else {
            return Builder(
                builder: (builderContext) => selectedPlaceWidgetBuilder!(
                    builderContext, data.item1, data.item2, data.item3));
          }
        }
      },
    );
  }

  Widget _defaultPlaceWidgetBuilder(
      BuildContext context, PickResult? data, SearchingState state) {
    return FloatingCard(
      bottomPosition: 0,
      leftPosition: 0,
      rightPosition: 0,
      width: double.maxFinite,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching
          ? _buildLoadingIndicator()
          : _buildSelectionDetails(context, data!),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 48,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    bool canBePicked = pickArea == null ||
        pickArea!.radius <= 0 ||
        Geolocator.distanceBetween(
                pickArea!.center.latitude,
                pickArea!.center.longitude,
                result.geometry!.location.lat,
                result.geometry!.location.lng) <=
            pickArea!.radius;
    MaterialStateColor buttonColor = MaterialStateColor.resolveWith(
        (states) => canBePicked ? Colors.lightGreen : Colors.red);
    String FlatAddress = "";
    bool isHomeClick = false;
    bool isWorkClick = false;
    bool isOtherClick = false;

    String House = result.formattedAddress.toString();
    String LandMark = "";
    print("HouseHouseHouseHouseHouse $House");
    String Delivery_Type = "";
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      ButtonState buttonState = ButtonState.normal;
      return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5),
            Row(
              children: [
                Image(
                  image: AssetImage("${imagePath}location.png"),
                  width: 22,
                  height: 22,
                  color: MainColor,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Text(
                    result.formattedAddress.toString(),
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.1,
                        fontFamily: Segoeui,
                        color: BlackColor),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Container(
              child: TextFormField(
                onChanged: (value) {
                  House = value;
                },
                initialValue: House,
                /*controller: TextEditingController()..text = House.toString(),*/
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: MainColor)),
                  hintText: HOUSEFLATBLOCK,
                  labelText: HOUSEFLATBLOCK,
                ),
                style: TextStyle(fontSize: 12, fontFamily: Segoe_ui_semibold),
              ),
            ),
            IsComeFromHome == false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Container(
                        height: 45,
                        child: TextField(
                          onChanged: (value) {
                            LandMark = value;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: MainColor)),
                            hintText: LANDMARKOPTIONAL,
                            labelText: LANDMARKOPTIONAL,
                          ),
                          style: TextStyle(
                              fontSize: 12, fontFamily: Segoe_ui_semibold),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          Saveas,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: Segoe_ui_semibold,
                            color: BlackColor2,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 28,
                            child: RoundedBorderButton(
                              txt: HOME,
                              txtSize: 12,
                              CornerReduis: 18.0,
                              BorderWidth: 0.8,
                              BackgroundColor:
                                  isHomeClick == true ? MainColor : WhiteColor,
                              ForgroundColor:
                                  isHomeClick == true ? WhiteColor : GreyColor,
                              PaddingLeft: 10,
                              PaddingRight: 10,
                              PaddingTop: 0,
                              PaddingBottom: 0,
                              press: () {
                                Delivery_Type = "HOME";
                                setState(() {
                                  isHomeClick = true;
                                  isWorkClick = false;
                                  isOtherClick = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 28,
                            child: RoundedBorderButton(
                              txt: WORK,
                              txtSize: 12,
                              CornerReduis: 18.0,
                              BorderWidth: 0.8,
                              BackgroundColor:
                                  isWorkClick == true ? MainColor : WhiteColor,
                              ForgroundColor:
                                  isWorkClick == true ? WhiteColor : GreyColor,
                              PaddingLeft: 10,
                              PaddingRight: 10,
                              PaddingTop: 0,
                              PaddingBottom: 0,
                              press: () {
                                Delivery_Type = "Work";
                                setState(() {
                                  isHomeClick = false;
                                  isWorkClick = true;
                                  isOtherClick = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 28,
                            child: RoundedBorderButton(
                              txt: OTHER,
                              txtSize: 12,
                              CornerReduis: 18.0,
                              BorderWidth: 0.8,
                              BackgroundColor:
                                  isOtherClick == true ? MainColor : WhiteColor,
                              ForgroundColor:
                                  isOtherClick == true ? WhiteColor : GreyColor,
                              PaddingLeft: 10,
                              PaddingRight: 10,
                              PaddingTop: 0,
                              PaddingBottom: 0,
                              press: () {
                                Delivery_Type = "Others";
                                setState(() {
                                  isHomeClick = false;
                                  isWorkClick = false;
                                  isOtherClick = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 35),
            ProgressButton(
              child: Text(
                IsComeFromHome == true ? SelectAddress : SaveAddress,
                style: TextStyle(
                  color: WhiteColor,
                  fontFamily: Segoe_ui_semibold,
                  height: 1.1,
                ),
              ),
              onPressed: () {
                if (IsComeFromHome == false) {
                  if (House.isEmpty) {
                    ShowToast(HouseOrFlatRequired, context);
                  } else if (Delivery_Type.isEmpty) {
                    ShowToast(SelectDeliveryType, context);
                  } else {
                    setState(() {
                      buttonState = ButtonState.inProgress;
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        buttonState = ButtonState.normal;
                      });
                    });

                    SavingAddress(
                        House,
                        Delivery_Type,
                        LandMark,
                        result.geometry!.location.lat,
                        result.geometry!.location.lng,
                        context,
                        result,
                        canBePicked);
                  }
                } else {
                  if (canBePicked) {
                    onPlacePicked!(result);
                  }
                }
              },
              buttonState: buttonState,
              backgroundColor: MainColor,
              progressColor: WhiteColor,
              border_radius: Full_Rounded_Button_Corner,
            )
            /*      (canBePicked && (selectText?.isEmpty ?? true)) ||
                    (!canBePicked && (outsideOfPickAreaText?.isEmpty ?? true))
                ? SizedBox.fromSize(
                    size: Size(56, 56), // button width and height
                    child: ClipOval(
                      child: Material(
                        child: InkWell(
                            overlayColor: buttonColor,
                            onTap: () {
                              if (canBePicked) {
                                onPlacePicked!(result);
                              }
                            },
                            child: Icon(
                                canBePicked
                                    ? Icons.check_sharp
                                    : Icons.app_blocking_sharp,
                                color: buttonColor)),
                      ),
                    ),
                  )
                : SizedBox.fromSize(
                    size: Size(MediaQuery.of(context).size.width * 0.8,
                        56), // button width and height
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Material(
                        child: InkWell(
                            overlayColor: buttonColor,
                            onTap: () {
                              if (canBePicked) {
                                onPlacePicked!(result);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    canBePicked
                                        ? Icons.check_sharp
                                        : Icons.app_blocking_sharp,
                                    color: buttonColor),
                                SizedBox.fromSize(size: new Size(10, 0)),
                                Text(
                                    canBePicked
                                        ? selectText!
                                        : outsideOfPickAreaText!,
                                    style: TextStyle(color: buttonColor))
                              ],
                            )),
                      ),
                    ),
                  )*/
          ],
        ),
      );
    });
  }

  Widget _buildMapIcons(BuildContext context) {
    final RenderBox appBarRenderBox =
        appBarKey.currentContext!.findRenderObject() as RenderBox;

    return Positioned(
      top: appBarRenderBox.size.height,
      right: 15,
      child: Column(
        children: <Widget>[
          enableMapTypeButton!
              ? Container(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onToggleMapType,
                    child: Icon(Icons.layers),
                  ),
                )
              : Container(),
          SizedBox(height: 10),
          enableMyLocationButton!
              ? Container(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onMyLocation,
                    child: Icon(Icons.my_location),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> SavingAddress(
      String house,
      String Delivery_Type,
      String landMark,
      double lat,
      double lng,
      BuildContext context,
      PickResult result,
      bool canBePicked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var Params = <String, dynamic>{};
    Params[address] = house;
    Params[type] = Delivery_Type;
    Params[latitude] = lat;
    Params[longitude] = lng;
    Params[landmark] = landMark;
    print("ParamsParamsParams${Params.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.post(ADD_ADDRESS, data: Params);
    print("SavingAddressresponseresponse${response.data.toString()}");
    ShowToast(response.data[MESSAGE], context);
    if (response.data[status]) {
      if (canBePicked) {
        onPlacePicked!(result);
      }
    } else {}
  }
}
