import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/logic/controllers/currentuser_controller.dart';
import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/views/screens/dashboard_screen.dart';
import 'package:driving_getx/views/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'allcondidat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool allowClose = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBack(
        condition: allowClose,
        onConditionFail: () {
          setState(() {
            allowClose = true;
          });
        },
        waitForSecondBackPress: 3, // default 2
        textStyle: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        background: Colors.blue,
        backgroundRadius: 10,
        message: "Appuyez sur retour pour quitter !",
        child: HomePage(),
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  int selectedIndex;
  HomePage({super.key, this.selectedIndex = 0});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthController authController = Get.find();
  static const URLpic = 'https://smdev.tn/storage/profile_pic/';
  final _currentuserController = Get.put(CurrentUserController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _currentuserController.gtuserInfo();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;
    changeStatusColor(sdAppBackground);
    final tab = [
      DashboardScreen(),
      /* DashboardScreen(), */
      ListeAllCondidat(),
      ProfileScreen()
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: sdAppBackground,
        body: tab[widget.selectedIndex],
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
              currentIndex: widget.selectedIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset('images/appbar/sdhome.png',
                        height: 28, width: 28, color: sdIconColor),
                    activeIcon: Image.asset('images/appbar/sdhome.png',
                        height: 28, width: 28, color: sdPrimaryColor),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Image.asset('images/appbar/users3.png',
                        height: 28, width: 28, color: kTextLightColor),
                    activeIcon: Image.asset('images/appbar/users3.png',
                        height: 28, width: 28, color: sdPrimaryColor),
                    label: "Condidats"),
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
                        imageUrl: URLpic +
                            (_currentuserController.user.path == null
                                ? 'unknown_profile.png'
                                : _currentuserController.user.path!),
                        fit: BoxFit.cover,
                        height: 35,
                        width: 10,
                      ),
                    ),
                  ),
                  label: "test2",
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
                        imageUrl: URLpic +
                            (_currentuserController.user.path == null
                                ? 'unknown_profile.png'
                                : _currentuserController.user.path!),
                        height: 35,
                        width: 10,
                      ),
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  widget.selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
