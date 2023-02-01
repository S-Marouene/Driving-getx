import 'dart:convert';
// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:driving_getx/database/models/examens.dart';
import '../models/condidats.dart';
import 'dio.dart';

class ServiceCondidats {
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

  static Future<List<Examen>> getExamByid(id) async {
    Dio.Response response = await dio().get('/examen/getExamenByCondidat/$id',
        options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List examens = jsonDecode((response.data.toString()))["data"];

      return examens.map((json) => Examen.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }
}
