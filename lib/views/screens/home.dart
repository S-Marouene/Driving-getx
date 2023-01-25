// ignore_for_file: unused_local_variable

import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/views/screens/liste_condidat.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    changeStatusColor(sdAppBackground);
    final tab = [Dashboard(context), ListeCondidat()];

    return SafeArea(
      child: Scaffold(
        backgroundColor: sdAppBackground,
        body: tab[_currentIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: sdShadowColor, spreadRadius: 0, blurRadius: 2),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset('images/appbar/sdhome.png',
                        height: 28, width: 28, color: sdIconColor),
                    activeIcon: Image.asset('images/appbar/sdhome.png',
                        height: 28, width: 28, color: sdPrimaryColor),
                    label: "test"

                    ///title: Text('a'),
                    ),
                BottomNavigationBarItem(
                    icon: Image.asset('images/appbar/sdexamcard.png',
                        height: 28, width: 28, color: sdIconColor),
                    activeIcon: Image.asset('images/appbar/sdexamcard.png',
                        height: 28, width: 28, color: sdPrimaryColor),
                    label: "test2"
                    //title: Text('a'),
                    ),
                /* BottomNavigationBarItem(
                  icon: Image.asset('images/smartDeck/images/sdleaderboard.png',
                      height: 28, width: 28, color: sdIconColor),
                  activeIcon: Image.asset(
                      'images/smartDeck/images/sdleaderboard.png',
                      height: 28,
                      width: 28,
                      color: sdPrimaryColor),
                  //title: Text('a'),
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Image.asset('images/smartDeck/images/sdchats.png',
                          height: 28, width: 28, color: sdIconColor),
                      const Positioned(
                        top: -2,
                        right: -6,
                        child: CircleAvatar(
                            radius: 3, backgroundColor: sdSecondaryColorRed),
                      )
                    ],
                  ),
                  activeIcon: Stack(
                    children: <Widget>[
                      Image.asset('images/smartDeck/images/sdchats.png',
                          height: 28, width: 28, color: sdPrimaryColor),
                      const Positioned(
                        top: -2,
                        right: -6,
                        child: CircleAvatar(
                            radius: 3, backgroundColor: sdSecondaryColorRed),
                      )
                    ],
                  ),
                  //title: Text('a'),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    height: 30,
                    width: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        placeholder: placeholderWidgetFn() as Widget Function(
                            BuildContext, String)?,
                        imageUrl:
                            'https://i.insider.com/5de6dd81fd9db241b00c04d3?width=1100&format=jpeg&auto=webp',
                        fit: BoxFit.cover,
                        height: 35,
                        width: 10,
                      ),
                    ),
                  ),
                  activeIcon: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: sdPrimaryColor, width: 2)),
                    height: 30,
                    width: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://i.insider.com/5de6dd81fd9db241b00c04d3?width=1100&format=jpeg&auto=webp',
                        height: 35,
                        width: 10,
                      ),
                    ),
                  ),
                  //title: Text('a'),
                ), */
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
/* 
class HomeScreen extends GetView {
  HomeScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  
  }
}
 */