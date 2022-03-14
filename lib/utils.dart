import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  Future<http.Response> postData(String uri, Map<String, dynamic> datas) {
    return http.post(
      Uri.parse('https://cube.clement-degreve.fr/' + uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(datas),
    );
  }

  Future<bool> saveUser(String email, String password) async {
    final data = await SharedPreferences.getInstance();

    data.setString('email', email);
    data.setString('password', password);

    return true;
  }
}
