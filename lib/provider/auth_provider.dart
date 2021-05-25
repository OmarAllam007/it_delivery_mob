import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/user.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User loggedUser;
  String _token;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future login(Map data) async {
    try {
      final url = 'user/login';
      final response = await dio().post(url, data: data);
      final userData = response.data['user'];
      loggedUser = User.fromMap(userData);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
      prefs.setString('user', json.encode(loggedUser));

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    final url = 'user/logout';

    try {
      // dio().options.headers['Authorization', ]
      // final response = await dio().post(url, data: json.encode({}), {
      //   "Content-Type": "application/json",
      //   "Authorization": "Bearer " + _token,
      // });
      // print(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      _token = null;
      notifyListeners();
    } catch (e) {
      throw Exception();
    }
  }
}
