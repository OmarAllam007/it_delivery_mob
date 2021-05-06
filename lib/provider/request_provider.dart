import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestProvider with ChangeNotifier {
  Future<void> store(RequestModel request) async {
    try {
      final url = APP_URL + '/request/create';

      FormData formData = FormData.fromMap({
        'subject': request.subject,
        'service_id': request.service,
        'subservice_id': request.subservice,
        'description': request.description,
      });

      // for (int i = 0; i < request.files.length; i++) {
      //   formData.files.add(MapEntry(
      //       'attachments[]', await MultipartFile.fromFile(request.files[i])));
      // }

      // final prefs = await SharedPreferences.getInstance();
      // final _token = prefs.getString("token");
      var response = await Dio().post(
        url,
        data: formData,
        options: Options(headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer " + _token
        }),
      );
      print(response.toString());
    } catch (e) {}
  }
}
