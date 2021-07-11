import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'package:it_delivery/view/RequestForm.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/env.dart';
import '../model/Request.dart';
import 'dart:convert' as convert;

class RequestProvider with ChangeNotifier {
  // Stream<List<RequestModel>> stream;
  List<RequestModel> _requests = [];

  List<RequestModel> get requests {
    return [...this._requests];
  }

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

  // RequestProvider() {
  //   _data = [];
  //   _controller = StreamController<List<RequestModel>>.broadcast();
  //   isLoading = false;

  //   // stream = _controller.stream;
  //   hasMoreRequests = true;

  //   refresh();
  // }

  Future<void> refresh() {
    // return loadMore(clearData: true);
  }

  Future<void> getRequests({currentPage}) async {
    try {
      
      _requests = [];
      final url = 'request?page=$currentPage&filterType=${this.filterType}';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.get('token');

      var response = await httpGet(token: token, url: url);
      var jsonResponse = convert.jsonDecode(response.body);

      jsonResponse.forEach((item) {
        _requests.add(
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
            arServiceDesc: item['ar_serviceDesc'],
            arSubserviceDesc: item['ar_subserviceDesc'],
            // serviceId: item['service_id'],
            // subserviceId: item['subservice_id']
          ),
        );
      });

      // final List<RequestModel> finalList = [];

    } catch (error) {
      throw error;
    }

    return Future.value();
  }

  // Future<void> loadMore({bool clearData = false}) {
  //   if (clearData) {
  //     lastId = 0;
  //     _data = <RequestModel>[];
  //     hasMoreRequests = true;
  //   }

  //   if (isLoading || !hasMoreRequests) {
  //     return Future.value();
  //   }

  //   isLoading = true;
  //   return getRequests().then((data) {
  //     isLoading = false;
  //     _data.addAll(data);

  //     hasMoreRequests = data.length != 0;
  //     dataLength = _data.length;
  //     _controller.add(_data);
  //     lastId = _data.last.id;
  //     isLoading = false;

  //     notifyListeners();
  //   }).catchError((error) {
  //     isLoading = false;
  //   });
  // }

  Future<void> store(request , files) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    
    try {
      var data = {
        'service_id': request.serviceId,
        'subservice_id': request.subserviceId,
        'description': request.description,
        'lat':request.lat,
        'long':request.long,
        'mobile': request.mobile,
        'files' : files
      };
      

      httpPostMultipart(url: 'store_request',
       token: token, data: data);
    } catch (e) {}
  }
}
