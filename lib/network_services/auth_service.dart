import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
// import 'package:m_delivery/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retry/retry.dart';
import '../utils/constants.dart';
import 'fcm_user_token_service.dart';

class AuthService {

  AuthService({email, password});
  late FirebaseMessaging messaging;
  final FcmUserTokenService fcmUserTokenService = FcmUserTokenService();

  Future<dynamic> loginUser({email, password}) async {
    final response = await retry(() => http.post(Uri.parse('${kAPIUrl}token'), body: jsonEncode({
      'email': email,
      'password': password,
    }), headers: {
      'Content-Type': 'application/json',
      // "Cache-Control": "no-cache"
    }).timeout(Duration(seconds: 5))) ;

print(response.statusCode);
    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body)['data'];
      saveUser(data['user']);
      saveToken(data['token']);



    } else {
      throw Exception('Failed to load token');
    }

  }

  Future<dynamic> registerUser(body) async {

    final response = await retry(() => http.post(Uri.parse('${kAPIUrl}register'), body: {
      'first_name': body['first_name'],
      'last_name': body['last_name'],
      'phone_number': body['phone_number'],
      'password': body['password'],
      'email': body['email'],
    }, headers: {
      'Accept': 'application/json',
    }).timeout(Duration(seconds: 5)));

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body)['data'];
      saveUser(data['user']);
      saveToken(data['token']);
    } else {
      throw Exception('Failed to load token');
    }

  }

  void logout() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // localStorage.remove('user');
    localStorage.remove('token');

    }


    saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  saveUser(dynamic user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user));
    // print(user);
    // print(json.encode(user));
  }

}
