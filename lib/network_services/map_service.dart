import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:retry/retry.dart';

class MapService {

  Future<dynamic> getReverseGeocode(user_lat, user_lng) async {
    final response = await retry(() => http.get(Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/${user_lng},${user_lat}.json?access_token=pk.eyJ1IjoiZ2FiLWRhLWRldiIsImEiOiJjbDZma214MncwODFuM2pyeDJxa2ZpaDc0In0.rc2tDeF2hFnxJX0p67MfEg')).timeout(Duration(seconds: 5)));
    // final response = await http.get(Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/29.1711362,-25.8719102.json?access_token=pk.eyJ1IjoiZ2FiLWRhLWRldiIsImEiOiJjbDZma214MncwODFuM2pyeDJxa2ZpaDc0In0.rc2tDeF2hFnxJX0p67MfEg'));

    if (response.statusCode == 200) {
      // features[0]['place_name']
      var data = json.decode(response.body)['features'][0]['place_name'];
      print(data);
      return data;
    } else {
      throw Exception('Failed to load map info');
    }
  }

}