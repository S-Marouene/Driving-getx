import 'package:dio/dio.dart';

import '../../logic/controllers/auth_controller.dart';

Dio dio() {
  var dio = Dio(BaseOptions(

      /**for production */
      baseUrl: 'https://smdev.tn/api/auth',

      // baseUrl: 'http://172.21.11.196/Driving/backend/api/auth',
      responseType: ResponseType.plain,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      requestInterceptor(options);
      return handler.next(options); //continue
    },
  ));

  return dio;
}

dynamic requestInterceptor(RequestOptions options) async {
  AuthController authController = AuthController();
  if (options.headers.containsKey('auth')) {
    var token = await authController.authdata();
    options.headers.addAll({'Authorization': 'Bearer $token'});
  }
}
