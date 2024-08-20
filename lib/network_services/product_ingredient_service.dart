import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'package:retry/retry.dart';
class ProductIngredientService {

  Future<dynamic> getProductIngredients() async {
    final response = await retry(() => http.get(Uri.parse('${kAPIUrl}product-ingredients'),headers: {
      'Accept': 'application/json'}).timeout(Duration(seconds: 5))) ;

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load product ingredients');
    }
  }

}
