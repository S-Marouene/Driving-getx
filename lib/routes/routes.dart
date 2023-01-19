import 'package:driving_getx/logic/bindings/login_binding.dart';
import 'package:driving_getx/views/screens/splash.dart';
import 'package:get/get.dart';

import '../views/screens/home.dart';
import '../views/screens/login_view.dart';

class AppRoutes {
  static const dashboard = Routes.dashboard;
  static const splash = Routes.splash;
  static const productDetails = Routes.productDetails;
  static const insertProduct = Routes.insertProduct;
  static const register = Routes.register;
  static const login = Routes.login;

  static final routes = [
/*     GetPage(name: Routes.products , page: () => const ProductsView()),
    GetPage(name: Routes.productDetails , page: () => const ProductsDetails()),
    GetPage(name: Routes.insertProduct , page: () =>  InsertProductsView()), */

    GetPage(
        name: Routes.login,
        page: () => const LoginView(),
        binding: LoginBuinding()),
    GetPage(name: Routes.dashboard, page: () => HomeScreen()),
    GetPage(
        name: Routes.splash,
        page: () => const Splashscreen(),
        binding: LoginBuinding()),
  ];
}

class Routes {
  static const dashboard = '/dashboard';
  static const productDetails = '/product_details';
  static const insertProduct = '/insert_product';
  static const register = '/register';
  static const login = '/login';
  static const splash = '/splash';
}
