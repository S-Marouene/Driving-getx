import 'dart:convert';
// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:driving_getx/database/models/examens.dart';
import 'dio.dart';

class ServiceExamens {
  static Future<List<Examen>> getExamByid(id) async {
    Dio.Response response =
        await dio().get('/examen/getExamenByCondidat/$id', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List examens = jsonDecode((response.data.toString()))["data"];

      return examens.map((json) => Examen.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future AddExamServ(Examen ExamModel) async {
    Dio.Response response = await dio().post(
      '/examen',
      options: Dio.Options(
        headers: {'auth': true},
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: ExamModel,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.data.toString());
    } else {
      return jsonDecode(response.data.toString());
    }
  }

  static Future UpdateExamRes(ExamUpdate, Examenid) async {
    Dio.Response response = await dio().put('/examen/update_resulat/$Examenid',
        options: Dio.Options(
          headers: {'auth': true},
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: ExamUpdate);
    if (response.statusCode == 200) {
      return jsonDecode(response.data.toString());
    } else {
      return jsonDecode(response.data.toString());
    }
  }

  static Future DeleteExamentServ(id) async {
    Dio.Response response = await dio().delete(
      '/examen/$id',
      options: Dio.Options(
        headers: {'auth': true},
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.data.toString());
    } else {
      return jsonDecode(response.data.toString());
    }
  }

  static Future<List<Examen>> getAllexamCldr() async {
    Dio.Response response =
        await dio().get('/examen/examencalndr/getForCalndr', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List exms = jsonDecode((response.data.toString()))["data"];
      return exms.map((json) => Examen.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }
}
