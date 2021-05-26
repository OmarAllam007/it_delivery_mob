import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestProvider with ChangeNotifier {
  Stream<List<RequestModel>> stream;
  bool hasMoreRequests;
  bool isLoading;

  List<RequestModel> _data;
  StreamController<List<RequestModel>> _controller;

  int lastId = 0;
  int filterType = 0;
  int dataLength = 0;
  var _token;

  hasRequests() {
    return _data.length > 1;
  }

  RequestProvider() {
    _data = [];
    _controller = StreamController<List<RequestModel>>.broadcast();
    isLoading = false;

    stream = _controller.stream;
    hasMoreRequests = true;

    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearData: true);
  }

  Future<List<RequestModel>> getRequests() async {
    try {
      final url = 'request/index?lastIndex=$lastId&filterType=$filterType';

      // final prefs = await SharedPreferences.getInstance();
      // _token = prefs.getString("token");
      // print(_token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.get('token');

      final response = await dio(token: token).get(url);
      final List<RequestModel> finalList = [];
      final data = response.data as List<dynamic>;

      data.forEach((item) {
        finalList.add(
          RequestModel(
            id: item['id'],
            subject: item['subject'],
            description: item['description'],
            serviceDesc: item['serviceDesc'],
            subserviceDesc: item['subserviceDesc'],
            requester: item['requester'],
            status: item['status'],
            status_id: item['status_id'],
            created_date: item['created_at'],
            close_date: item['close_date'],
            last_updated_date: item['updated_at'],
          ),
        );
      });

      return finalList;
    } catch (error) {
      throw error;
    }

    return Future.value();
  }

  Future<void> loadMore({bool clearData = false}) {
    if (clearData) {
      lastId = 0;
      _data = List<RequestModel>();
      hasMoreRequests = true;
    }

    if (isLoading || !hasMoreRequests) {
      return Future.value();
    }

    isLoading = true;
    return getRequests().then((data) {
      isLoading = false;
      _data.addAll(data);

      hasMoreRequests = data.length != 0;
      dataLength = _data.length;
      _controller.add(_data);
      lastId = _data.last.id;
      isLoading = false;

      notifyListeners();
    }).catchError((error) {
      isLoading = false;
    });
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
