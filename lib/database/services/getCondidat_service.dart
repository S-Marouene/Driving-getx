import 'dart:convert';
// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import '../models/condidats.dart';
import 'dio.dart';

class ServiceGetCondidats {
  static Future<List<Condidat>> getCondidats() async {
    Dio.Response response = await dio()
        .get('/allCondidats', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List condidats = json.decode(response.toString());
      return condidats.map((json) => Condidat.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }
}
