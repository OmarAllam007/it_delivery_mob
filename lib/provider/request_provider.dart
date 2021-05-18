import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestProvider with ChangeNotifier {
  Stream<List<RequestModel>> stream;
  bool hasMoreRequests;
  bool isLoading;
  List<RequestModel> _requests = [];
  StreamController<List<RequestModel>> _controller;
  int lastId = 0;

  RequestProvider() {
    _controller = StreamController<List<RequestModel>>.broadcast();
    isLoading = false;
    stream = _controller.stream;
  }

  List<RequestModel> get requests {
    return [..._requests];
  }

  Future<void> refresh() {
    return loadMore(clearData: true);
  }

  Future<void> loadMore({bool clearData = false}) {
    if (clearData) {
      lastId = 0;
      hasMoreRequests = true;
    }

    if (isLoading || !hasMoreRequests) {
      return Future.value();
    }
    isLoading = true;
    return index(lastIndex: lastId).then((data) {
      isLoading = false;
      _requests.addAll(data);

      hasMoreRequests = data.length != 0;
      _controller.add(_requests);
      lastId = _requests.last.id;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
    });
  }

  Future<List<RequestModel>> index({lastIndex = 0}) async {
    _requests = [];
    try {
      final url = APP_URL + 'request/index?lastIndex=$lastIndex';
      var response = await Dio().get(url);
      var data = response.data as List;
      data.forEach((request) {
        _requests.add(
          RequestModel(
            id: request['id'],
            description: request['description'],
            subject: request['subject'],
            requester: request['requester'],
            created_date: request['created_at'],
            status: request['status'],
          ),
        );
      });
    } catch (error) {}
    return requests;
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
