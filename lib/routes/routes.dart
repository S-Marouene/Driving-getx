import 'package:driving_getx/logic/bindings/login_binding.dart';
import 'package:driving_getx/views/screens/liste_condidat.dart';
import 'package:driving_getx/views/screens/splash.dart';
import 'package:get/get.dart';

import '../views/screens/home.dart';
import '../views/screens/login_view.dart';

class AppRoutes {
  static const dashboard = Routes.dashboard;
  static const splash = Routes.splash;
  static const login = Routes.login;
  static const liste_condidat = Routes.liste_condidat;

  static final routes = [
    GetPage(
        name: Routes.login,
        page: () => const LoginView(),
        binding: LoginBuinding()),
    GetPage(name: Routes.dashboard, page: () => HomeScreen()),
    GetPage(name: Routes.liste_condidat, page: () => ListeCondidat()),
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
  static const liste_condidat = '/liste_condidat';
}
