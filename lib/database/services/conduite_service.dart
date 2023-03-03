import 'dart:convert';
// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:driving_getx/database/models/conduite.dart';
import 'dio.dart';

class ServiceConduite {
  static Future<List<Conduite>> getConduites() async {
    Dio.Response response =
        await dio().get('/conduite/conduitecalndr/GetConduiteAcc', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List conduites = jsonDecode((response.data.toString()))["data"];
      return conduites.map((json) => Conduite.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }
}
