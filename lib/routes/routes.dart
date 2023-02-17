import 'package:driving_getx/logic/bindings/login_binding.dart';
import 'package:driving_getx/logic/bindings/settings_binding.dart';
import 'package:driving_getx/views/screens/SDSettingScreen.dart';
import 'package:driving_getx/views/screens/splash.dart';
import 'package:get/get.dart';
import '../views/screens/add_condidat_screen.dart';
import '../views/screens/allcondidat_screen.dart';
import '../views/screens/home.dart';
import '../views/screens/login_view.dart';

class AppRoutes {
  static const dashboard = Routes.dashboard;
  static const splash = Routes.splash;
  static const login = Routes.login;
  static const settings = Routes.settings;
  static const all_condidat = Routes.settings;
  static const add_condidat = Routes.settings;

  static final routes = [
    GetPage(
        name: Routes.login,
        page: () => const LoginView(),
        binding: LoginBuinding()),
    GetPage(name: Routes.dashboard, page: () => HomeScreen()),
    GetPage(name: Routes.all_condidat, page: () => ListeAllCondidat()),
    GetPage(name: Routes.add_condidat, page: () => AddCondidat()),
    GetPage(
        name: Routes.settings,
        page: () => SDSettingScreen(),
        binding: Settingsbuinding()),
    GetPage(
        name: Routes.splash,
        page: () => const Splashscreen(),
        binding: LoginBuinding()),
  ];
}

class Routes {
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const splash = '/splash';
  static const settings = '/settings';
  static const all_condidat = '/all_condidat';
  static const add_condidat = '/add_condidat';
}
