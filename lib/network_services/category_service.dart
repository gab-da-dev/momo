import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:m_delivery/utils/constants.dart';
import 'package:retry/retry.dart';

import '../utils/constants.dart';

class CategoryService {
  Future<dynamic> getCategories() async {
    final response =  await retry(() => http.get(Uri.parse('${kAPIUrl}product-categories')).timeout(Duration(seconds: 5)));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      // print(apiUrl);
      return data;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
