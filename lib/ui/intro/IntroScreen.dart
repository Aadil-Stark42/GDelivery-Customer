import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../res/ResColor.dart';
import '../../res/ResString.dart';
import '../../uicomponents/rounded_button.dart';
import '../login/LoginScreen.dart';

class IntroScreen extends StatefulWidget {
  static String id = 'IntroScreen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentIndex = 0;
  String Nextstr = "Next";
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: WhiteColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false);
              },
              child: Text(
                Skip,
                style: TextStyle(
                    color: MainColor, fontSize: 16, fontFamily: Inter_medium),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            color: WhiteColor,
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                  if (page == 2) {
                    Nextstr = Finish;
                  } else {
                    Nextstr = Next;
                  }
                });
              },
              controller: _pageController,
              children: <Widget>[
                makePage(
                    image: '${imagePath}step-one.png',
                    title: stepOneTitle,
                    content: stepOneContent),
                makePage(
                    reverse: true,
                    image: '${imagePath}step-two.png',
                    title: stepTwoTitle,
                    content: stepTwoContent),
                makePage(
                    image: '${imagePath}step-three.png',
                    title: stepThreeTitle,
                    content: stepThreeContent),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildIndicator(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RoundedButton(
                        color: MainColor,
                        text: Nextstr,
                        corner_radius: Rounded_Button_Corner,
                        press: () {
                          if (Nextstr == Finish) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false);
                          } else {
                            setState(() {
                              currentIndex += 1;
                              _pageController.animateToPage(currentIndex,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.ease);
                            });
                          }
                        },
                      )
                    ],
                  )))
        ],
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              : SizedBox(),
          Text(
            title,
            style: TextStyle(
                color: BlackColor, fontSize: 25, fontFamily: Segoe_ui_bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: GreyColor, fontSize: 15, fontFamily: Segoe_ui_semibold),
          ),
          reverse
              ? Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(image),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: MainColor, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
