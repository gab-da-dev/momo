import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'dart:convert';
import '../utils/constants.dart';

class StoreService {

  Future<dynamic> getStore() async {
    final response = await retry(() => http.get(Uri.parse('${kAPIUrl}stores')).timeout(Duration(seconds: 5)));

    if (response.statusCode == 200) {
       var data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load store data');
    }
  }

}