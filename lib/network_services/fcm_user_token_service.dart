import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/constants.dart';
import 'package:retry/retry.dart';
class FcmUserTokenService {

  Future<dynamic> saveFcmToken(token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    dynamic user = json.decode(localStorage.getString('user').toString());

    final response =
    await retry(() => http.post(Uri.parse('${kAPIUrl}fcm-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
          'user_id': user['id'].toString(),
        })).timeout(Duration(seconds: 5)));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // print(data);
      return data;
    } else {
      throw Exception('Failed to store token');
    }
  }


}