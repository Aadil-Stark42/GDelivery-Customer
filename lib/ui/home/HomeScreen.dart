import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gdeliverycustomer/res/ResColor.dart';

import '../../res/ResString.dart';
import '../../utils/Utils.dart';
import 'AppMaintainanceScreen.dart';
import 'homesubscreen/CartSubScreen.dart';
import 'homesubscreen/CategorySearchScreen.dart';
import 'homesubscreen/HomeSubScreen.dart';
import 'homesubscreen/ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  /*final List<Widget> viewContainer = [
    HomeSubScreen(),
    CategorySearchScreen(),
    CartSubScreen(false, true, () {}),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      if (CHECKAPPSTATUS == STATUSNUMBER) {
        if (index == 1 || index == 2) {
          viewContainer[index] = AppMaintainanceScreen(false);
        }
      } else {
        if (index == 1) {
          viewContainer[index] = CategorySearchScreen();
        } else if (index == 2) {
          viewContainer[index] = CartSubScreen(false, true, () {});
        }
      }
      currentIndex = index;
    });
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: whiteColor,
      body: bottomView(),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        child: BottomNavigationBar(
            backgroundColor: mainColor,
            selectedItemColor: whiteColor,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: lightWhiteColor,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            // new

            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home_outlined,
                ),
                label: Home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: Categoryy,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Cart,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outlined),
                label: Profile,
              )
            ]),
      ),
    );
  }

  Widget bottomView() {
    if (CHECKAPPSTATUS == STATUSNUMBER) {
      if (currentIndex == 1 || currentIndex == 2) {
        return AppMaintainanceScreen(false);
      } else {
        if (currentIndex == 0) {
          return HomeSubScreen();
        } else {
          return ProfileScreen(() {
            setState(() {
              currentIndex = 0;
            });
          });
        }
      }
    } else {
      if (currentIndex == 0) {
        return HomeSubScreen();
      } else if (currentIndex == 1) {
        return CategorySearchScreen(() {
          setState(() {
            currentIndex = 0;
          });
        });
      } else if (currentIndex == 2) {
        return CartSubScreen(false, true, () {}, () {
          setState(() {
            currentIndex = 0;
          });
        });
      } else {
        return ProfileScreen(() {
          setState(() {
            currentIndex = 0;
          });
        });
      }
    }
  }
}
