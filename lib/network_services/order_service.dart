import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import 'package:retry/retry.dart';
class OrderService {

  Future<dynamic> getOrders() async {
    final response = await retry(() => http.get(Uri.parse('$kAPIUrl/orders')).timeout(Duration(seconds: 5)));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<dynamic> getCurrentOrder() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    dynamic user = json.decode(localStorage.getString('user').toString());

    final response =
    await http.post(Uri.parse('${kAPIUrl}current-order'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': user['id'].toString(),
        }));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load order');
    }
  }
}
