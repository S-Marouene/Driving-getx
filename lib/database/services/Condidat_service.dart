import 'dart:convert';
// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:driving_getx/database/models/examens.dart';
import 'package:driving_getx/database/models/examinateur.dart';
import 'package:driving_getx/database/models/payements.dart';
import '../models/bureaux.dart';
import '../models/caisses.dart';
import '../models/centreexams.dart';
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

  static Future<List<Payement>> getPayementByid(id) async {
    Dio.Response response = await dio().get(
        '/paiement/getpaiementByCondidat/$id',
        options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List examens = jsonDecode((response.data.toString()))["data"];

      return examens.map((json) => Payement.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future AddPayementServ(Payement paymentModel) async {
    Dio.Response response = await dio().post(
      '/paiement',
      options: Dio.Options(
        headers: {'auth': true},
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: paymentModel,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.data.toString());
    } else {
      return jsonDecode(response.data.toString());
    }
  }

  static Future DeletePayementServ(id) async {
    Dio.Response response = await dio().delete(
      '/paiement/$id',
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

  static Future<List<Caisse>> getCaisse() async {
    Dio.Response response = await dio()
        .get('/caisse', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List examens = jsonDecode((response.data.toString()))["data"];

      return examens.map((json) => Caisse.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<Examinateur>> getExaminateur() async {
    Dio.Response response = await dio()
        .get('/examinateur', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List exam = jsonDecode((response.data.toString()))["data"];

      return exam.map((json) => Examinateur.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<Bureau>> Listbureau() async {
    Dio.Response response = await dio()
        .get('/bureaux', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List bureaux = jsonDecode((response.data.toString()))["data"];

      return bureaux.map((json) => Bureau.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<CentreExam>> Listcentre_exam() async {
    Dio.Response response = await dio()
        .get('/centre_exam', options: Dio.Options(headers: {'auth': true}));

    if (response.statusCode == 200) {
      final List centreExams = jsonDecode((response.data.toString()))["data"];

      return centreExams.map((json) => CentreExam.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }
}
