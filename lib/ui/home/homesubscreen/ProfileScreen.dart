import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gdeliverycustomer/main.dart';

import 'package:gdeliverycustomer/res/ResColor.dart';
import 'package:gdeliverycustomer/ui/information/CantactUsScreen.dart';
import 'package:gdeliverycustomer/ui/information/TermsAndConditionScreen.dart';
import 'package:gdeliverycustomer/ui/order/MyOrdersScreen.dart';
import 'package:gdeliverycustomer/utils/Utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../apiservice/ApiService.dart';
import '../../../apiservice/EndPoints.dart';
import '../../../res/ResString.dart';
import '../../../uicomponents/progress_button.dart';
import '../../../utils/LocalStorageName.dart';
import '../../address/SelectAddressScreen.dart';
import '../AppMaintainanceScreen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback isBackPress;

  ProfileScreen(this.isBackPress);
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    PackageInfoo();
    UserDetails();
  }

  ButtonState buttonState = ButtonState.normal;
  String VersionName = "",
      User_Name = "",
      User_Mobile = "",
      Package_Name = "",
      profileImage = "";
  File imgfilepath = File("");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              color: mainColor,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.isBackPress();
                        },
                        child: Image.asset(
                          imagePath + "ic_back.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        Profile,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 17,
                            height: 1.0,
                            fontFamily: Segoe_ui_bold,
                            color: whiteColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileImage.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.network(
                                    profileImage,
                                    width: 47,
                                    height: 47,
                                  ))
                              : SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: whiteColor,
                                  ),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                User_Name,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 16,
                                    height: 1.0,
                                    fontFamily: Raleway_Medium,
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor),
                              ),
                              SizedBox(height: 12),
                              Text(
                                User_Mobile,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 12,
                                    height: 1.0,
                                    fontFamily: Raleway_Regular,
                                    color: lightWhiteColor),
                              )
                            ],
                          ),
                        ],
                      )),
                      InkWell(
                        onTap: () {
                          ChangeProfileDialog();
                        },
                        child: Text(
                          "Change",
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: Segoe_ui_semibold,
                              color: whiteColor),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
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
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => SelectAddressScreen(
                                  IsJustChangeAddress: true,
                                  GstPer: "",
                                  IsForCart: false,
                                  isBackAvaillable: false),
                            ));
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              Address,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Segoeui,
                                  color: blackColor),
                            )),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: mainColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                                  builder: (context) => MyOrdersScreen()),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              Orders,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Segoeui,
                                  color: blackColor),
                            )),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: mainColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          /* _launchUrl();*/
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) =>
                                TermsAndConditionScreen(TERMS_CONDITION),
                          ));
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              TermsandConditions,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Segoeui,
                                  color: blackColor),
                            )),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: mainColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          /*_launchUrlPrivacy();*/
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) =>
                                TermsAndConditionScreen(PRIVACY_POLICY),
                          ));
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              PrivacyPolicy,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Segoeui,
                                  color: blackColor),
                            )),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: mainColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          StoreRedirect.redirect();
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              Rateus,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Segoeui,
                                  color: blackColor),
                            )),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: mainColor,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: (context) => CantactUsScreen(),
                          ));
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              ContactUs,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Segoeui,
                                  color: blackColor),
                            )),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: mainColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Column(
                children: [
                  ProgressButton(
                    child: Text(
                      Logout,
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: Segoe_ui_semibold,
                        height: 1.1,
                      ),
                    ),
                    onPressed: () {
                      LogoutDialogShow(context);
                    },
                    buttonState: buttonState,
                    backgroundColor: mainColor,
                    progressColor: whiteColor,
                    border_radius: Rounded_Button_Corner,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "V." + VersionName,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Segoeui,
                        color: transBlackColor),
                  ),
                  SizedBox(
                    height: 3,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future PackageInfoo() async {
    print("VersionName" + VersionName);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      VersionName = packageInfo.version;
      Package_Name = packageInfo.packageName;
      print("VersionName" + VersionName);
    });
  }

  void UserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);
    Response response;
    response = await ApiCalling.get(GET_USER_DETAILS);
    print("UserDetailsRESPONSE${response.data.toString()}");
    setState(() {
      User_Name = response.data[user][name];
      User_Mobile = response.data[user][mobile];
      profileImage = response.data[user][image];
    });
  }

  void ChangeProfileDialog() {
    String Name = User_Name;
    ButtonState buttonState = ButtonState.normal;
    var textEditingController = TextEditingController();
    textEditingController.text = Name;
    textEditingController.selection =
        TextSelection(baseOffset: Name.length, extentOffset: Name.length);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        ChangeProfile,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: Inter_bold,
                            color: blackColor),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          // Pick an image
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            CroppedFile? croppedFile =
                                await ImageCropper().cropImage(
                              sourcePath: image.path,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.square,
                                CropAspectRatioPreset.ratio3x2,
                                CropAspectRatioPreset.original,
                                CropAspectRatioPreset.ratio4x3,
                                CropAspectRatioPreset.ratio16x9
                              ],
                              uiSettings: [
                                AndroidUiSettings(
                                    toolbarTitle: 'Cropper',
                                    toolbarColor: mainColor,
                                    toolbarWidgetColor: whiteColor,
                                    initAspectRatio:
                                        CropAspectRatioPreset.square,
                                    lockAspectRatio: false),
                                IOSUiSettings(
                                  title: 'Cropper',
                                ),
                              ],
                            );

                            if (croppedFile != null) {
                              setState(() {
                                imgfilepath = File(croppedFile.path.toString());
                              });
                            }
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: imgfilepath.path.isNotEmpty
                              ? Image.file(
                                  imgfilepath,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  profileImage,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  height: 80,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 52,
                        child: TextField(
                          onChanged: (value) {
                            Name = value;
                          },
                          controller: textEditingController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor)),
                              hintText: HintName,
                              labelText: HintName,
                              prefixIcon: Icon(Icons.person_outlined,
                                  color: greyColor)),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: greyColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 52,
                        child: TextField(
                          onChanged: (value) {
                            Name = value;
                          },
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController()
                            ..text = User_Mobile,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor)),
                              hintText: MobileNumber,
                              labelText: MobileNumber,
                              prefixIcon:
                                  Icon(Icons.phone_android, color: greyColor)),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: Segoe_ui_semibold,
                            color: greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ProgressButton(
                      child: Text(
                        SaveDetails,
                        style: TextStyle(
                          color: whiteColor,
                          fontFamily: Segoe_ui_semibold,
                          height: 1.1,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          buttonState = ButtonState.inProgress;
                        });
                        SaveUserProfile(Name);
                      },
                      buttonState: buttonState,
                      backgroundColor: mainColor,
                      progressColor: whiteColor,
                      border_radius: Full_Rounded_Button_Corner,
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  Future<void> SaveUserProfile(String namee) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = <String, dynamic>{};
    String? token = prefs.getString(TOKEN);
    header[Authorization] = Bearer + token.toString();
    print("HEADERSSS${header.toString()}");
    var ApiCalling = GetApiInstanceWithHeaders(header);

    var formData = FormData.fromMap({
      mobile: User_Mobile,
      name: namee,
      image: imgfilepath.path == ""
          ? ""
          : await MultipartFile.fromFile(imgfilepath.path,
              filename: imgfilepath.path.split('/').last),
    });
    print("User_Mobile :- ${User_Mobile}");
    print("nameenamee :- ${namee}");
    print("imgfilepath.path${imgfilepath.path}");
    Response response;
    response = await ApiCalling.post(USER_UPDATE, data: formData);
    print("SaveUserProfileRESPONSE${response.data.toString()}");
    ShowToast(response.data[message], context);
    buttonState = ButtonState.normal;
    if (response.data[status]) {
      setState(() {
        User_Name = namee;
        prefs.setString(USER_NAME, namee);
        UserDetails();
        Navigator.pop(context);
      });
    }
  }

  LogoutDialogShow(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No", style: TextStyle(color: mainColor)),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(color: mainColor),
      ),
      onPressed: () {
        ClearLocalData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure,want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void ClearLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MySplashScreenPage()),
        (Route<dynamic> route) => false);
  }

  void _launchUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!await launchUrl(
        Uri.parse(prefs.getString(TERMS_CONDITION).toString())))
      throw 'Could not launch $prefs.getString(TERMS_CONDITION)';
  }

  void _launchUrlPrivacy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!await launchUrl(Uri.parse(prefs.getString(PRIVACY_POLICY).toString())))
      throw 'Could not launch $prefs.getString(TERMS_CONDITION)';
  }
}
