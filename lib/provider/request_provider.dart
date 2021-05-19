import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/Request.dart';

class RequestProvider with ChangeNotifier {
  Stream<List<RequestModel>> stream;
  bool hasMoreRequests;

  bool isLoading;
  List<RequestModel> _data;
  StreamController<List<RequestModel>> _controller;

  int lastId = 0;
  int filterType = 0;
  var _token;

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
      print(lastId);
      final url = APP_URL + 'request/index?lastIndex=$lastId';

      // final prefs = await SharedPreferences.getInstance();
      // _token = prefs.getString("token");
      // print(_token);
      final response = await http.get(Uri.parse(url));
      final List<RequestModel> finalList = [];
      final data = json.decode(response.body) as List<dynamic>;

      data.forEach((item) {
        finalList.add(RequestModel(
          id: item['id'],
          subject: item['subject'],
          description: item['description'],
          // category: item['category'],
          // subcategory: item['subcategory'],
          // item: item['item'],
          requester: item['requester'],
          // coordinator: item['coordinator'],
          status: item['status'],
          // dueDate: item['due_date'],
          created_date: item['created_at'],
        ));
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
      _controller.add(_data);
      lastId = _data.last.id;

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
