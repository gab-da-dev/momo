import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/constants.dart';

class ProfileService {

  Future<dynamic> updateProfile(body) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    dynamic user = json.decode(localStorage.getString('user').toString());

    print(user['id']);
    final response =
    await retry(() => http.post(Uri.parse('${kAPIUrl}edit-profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': user['id'].toString(),
          'first_name': body['first_name'],
          'last_name': body['last_name'],
          'phone_number': body['phone_number'],
          'password': body['password'],
          'confirm_password': body['confirm_password'],
        })).timeout(Duration(seconds: 5)));
// print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<dynamic> getUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    dynamic user = json.decode(localStorage.getString('user').toString());

    final response = await http.post(Uri.parse('${kAPIUrl}show-profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': user["id"].toString(),

        }));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to get user');
    }
  }

}