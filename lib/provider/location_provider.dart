import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/helpers/env.dart';
import 'package:http/http.dart' as http;
import 'package:it_delivery/model/Location.dart';

class LocationProvider with ChangeNotifier {
  Future<Map> store(Location location) async {
    final url = APP_URL + 'location/store';
    var urlLink = Uri.parse(APP_URL + url);

    Map body = {
      'type': location.type.toString(),
      'title': location.title.toString(),
      'lat': location.lat.toString(),
      'long': location.long.toString(),
    };

    Response<Map> response = await Dio().post(url, data: body);
    Map responseBody = response.data;

    return responseBody;
  }
}
