import 'package:flutter/material.dart';
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/Location.dart';
import 'package:it_delivery/network_utils/dio.dart';

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

    var response = await httpPost(url: url, data: body);
    Map responseBody = response.body as Map;

    return responseBody;
  }
}
