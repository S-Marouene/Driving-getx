import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/controllers/currentuser_controller.dart';
import '../../routes/routes.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  AuthController authController = AuthController();
  final _currentuserController = Get.put(CurrentUserController());
  static const URLpic = 'https://smdev.tn/storage/profile_pic/';

  @override
  void initState() {
    _currentuserController.gtuserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Obx((() => UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xff764abc)),
                  accountName: Text(
                      '${_currentuserController.user.name!} ${_currentuserController.user.fname!}'),
                  accountEmail: Text(
                    'Auto ecole : ${_currentuserController.user.schoolname!}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                    URLpic +
                        (_currentuserController.user.path == ''
                            ? 'unknown_profile.png'
                            : _currentuserController.user.path!),
                  )),
                ))),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('Tableau de bord'),
              onTap: () {
                Get.toNamed(AppRoutes.dashboard);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people_alt_rounded,
              ),
              title: const Text('Liste Condidat'),
              onTap: () {
                Get.toNamed(AppRoutes.liste_condidat);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Déconexion'),
              onTap: () {
                authController.doLogout();
              },
            ),
            const AboutListTile(
              icon: Icon(
                Icons.info,
              ),
              applicationIcon: Icon(
                Icons.local_play,
              ),
              applicationName: 'Driving app',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2022 Sm-Dev Company',
              aboutBoxChildren: [
                ///Content goes here...
              ],
              child: Text('About app'),
            ),
          ],
        ));
  }
}
