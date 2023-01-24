import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String baseapi = 'https://smdev.tn/api/auth';
  static var client = http.Client();

  static login({required email, password}) async {
    var response = await client.post(
      Uri.parse("$baseapi/login"),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      //var stringObject = response.body;
      var data = jsonDecode(response.body.toString());
      return data;
    }
  }
}
