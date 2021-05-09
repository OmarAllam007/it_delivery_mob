import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestProvider with ChangeNotifier {
  List<RequestModel> _requests = [];

  List<RequestModel> get requests {
    return [..._requests];
  }

  Future<void> index() async {
    _requests = [];
    Map map;
    try {
      final url = APP_URL + 'request/index';

      var response = await Dio().get(url);
      var data = response.data as List<dynamic>;
      print(data);
      data.forEach((request) {
        print(request);
        _requests.add(RequestModel(
            description: request['description'],
            subject: request['subject'],
            requester: request['requester']));
      });
    } catch (error) {}
  }

  Future<void> store(RequestModel request) async {
    try {
      final url = APP_URL + 'request/store';

      FormData formData = FormData.fromMap({
        'subject': request.subject,
        'service_id': request.service,
        'subservice_id': request.subservice,
        'description': request.description,
        'location_id': request.location_id,
        'mobile': request.mobile
      });

      // for (int i = 0; i < request.files.length; i++) {
      //   formData.files.add(MapEntry(
      //       'attachments[]', await MultipartFile.fromFile(request.files[i])));
      // }

      // final prefs = await SharedPreferences.getInstance();
      // final _token = prefs.getString("token");

      Response<Map> response = await Dio().post(
        url,
        data: formData,
        options: Options(headers: {
          "Content-Type": "application/json",
          //   // "Authorization": "Bearer " + _token
        }),
      );
      Map responseBody = response.data;
      print(responseBody);
      return responseBody;
      print(response.toString());
    } catch (e) {}
  }
}
