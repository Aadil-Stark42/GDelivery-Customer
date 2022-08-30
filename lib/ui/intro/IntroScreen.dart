import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              color: whiteColor,
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
                      content: stepOneContent,
                      height: 380.0),
                  makePage(
                      reverse: false,
                      image: '${imagePath}step-two.png',
                      title: stepTwoTitle,
                      content: stepTwoContent,
                      height: 380.0),
                  makePage(
                      image: '${imagePath}step-three.png',
                      title: stepThreeTitle,
                      content: stepThreeContent,
                      height: 380.0),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildIndicator(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
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
                          child: Image.asset(
                            imagePath + "ic_next.png",
                            width: 60,
                            height: 60,
                          ),
                        ),
                        /*  RoundedButton(
                          color: WhiteColor,
                          text: Nextstr,
                          textColor: MainColor,
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
                        )*/
                      ],
                    ))),
            Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      Skip,
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          fontFamily: Poppinsmedium),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false, height}) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 80),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imagePath + "introBg.png"), fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    Image.asset(
                      image,
                      height: height,
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
                color: whiteColor,
                fontSize: 18,
                fontFamily: Poppinsmedium,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: whiteColor,
                  fontSize: 15,
                  fontFamily: Segoe_ui_semibold),
            ),
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
      height: isActive ? 20 : 10,
      width: 5,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: whiteColor, borderRadius: BorderRadius.circular(5)),
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
