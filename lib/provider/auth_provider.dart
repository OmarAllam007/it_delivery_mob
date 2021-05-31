import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/user.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User loggedUser;
  String _token;
  String _fcmToken;

  bool get isAuth {
    return token != null;
  }

  String get token {
    getToken();
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.get('token');
    if (_token == null) {
      return;
    }

    final userData = json.decode(prefs.getString('user')) as Map;

    loggedUser = User(
      id: userData["id"],
      name: userData["name"],
      email: userData["email"],
      mobile: userData["mobile"],
      joinDate: userData["created_at"],
      locations: userData["locations"],
    ); //to be reviewed.

    _token = prefs.getString('token');
    // print(_token);
    notifyListeners();
    return true;
  }

  Future login(Map data) async {
    var error = '';
    try {
      final url = 'user/login';
      final response = await dio(token: _token).post(url, data: data);

      if (response.data['error'] != '' && response.data['error'] != null) {
        error = response.data['error'];
        return Future.error(error, StackTrace.fromString(error));

        // throw Exception(error);
      }
      final userData = response.data['user'];
      _token = response.data['token'];

      loggedUser = User.fromMap(userData);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', _token);
      prefs.setString('user', json.encode(loggedUser.toJson()));

      await sendFCMToken();

      notifyListeners();
    } catch (e) {
      throw Exception(error);
    }
  }

  Future sendFCMToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      this._fcmToken = value;
    });
    print(this._fcmToken);
    print(this._token);
    final fcmResponse = await dio(token: _token)
        .post('user/fcm-token', data: {'fcm-token': this._fcmToken});
    print(fcmResponse);
  }

  Future<void> logout() async {
    final url = 'user/logout';

    try {
      await dio(token: _token).post(
        url,
        data: {},
      );
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();

      _token = null;
      notifyListeners();
    } catch (e) {
      print(e);
      // throw Exception();
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('user')) {
      return false;
    }

    final userData = json.decode(prefs.getString('user')) as Map;

    loggedUser = User(
        id: userData["id"],
        name: userData["name"],
        email: userData["email"],
        joinDate: userData['created_at']); //to be reviewed.

    _token = prefs.getString('token');
    // print(_token);
    notifyListeners();
    return true;
  }
}
