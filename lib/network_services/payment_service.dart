import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:retry/retry.dart';
import '../utils/constants.dart';

class PaymentService {

  Future<dynamic> getPaymentToken(token, orderObj, user_id, coordinates, address) async {

    final response =
    await  retry(() => http.post(Uri.parse('${kAPIUrl}payment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
          'order': orderObj,
          'user_id': user_id.toString(),
          'coordinates': json.encode(coordinates),
          'address': address.toString(),
        })).timeout(Duration(seconds: 5)));

    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      // print(data);
      return data;
    } else {
      throw Exception('Failed payment');
    }
  }

}