import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'package:retry/retry.dart';
class ProductService {

  Future<dynamic> getProducts() async {
    final response = await retry(() => http.get(Uri.parse('${kAPIUrl}products')).timeout(Duration(seconds: 5)));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<dynamic> getPopularProducts() async {
    final response = await http.get(Uri.parse('${kAPIUrl}popular-product'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
