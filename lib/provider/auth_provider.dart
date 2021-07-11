import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/model/user.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'dart:convert' as convert;
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
      final response = await httpPost(token: _token, url: url, data: data);
      var jsonResponse = convert.jsonDecode(response.body) as Map;

      if (jsonResponse['error'] != '' && jsonResponse['error'] != null) {
        error = jsonResponse['error'];
        return Future.error(error, StackTrace.fromString(error));

        // throw Exception(error);
      }
      final userData = jsonResponse['user'];
      _token = jsonResponse['token'];

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
    print("code" + this._fcmToken);
    // print(this._token);
    final fcmResponse = await httpPost(
        token: _token,
        url: 'user/fcm-token',
        data: {'fcm-token': this._fcmToken});

    print(fcmResponse);
  }

  Future<void> logout() async {
    final url = 'user/logout';

    try {
      await httpPost(
        token: _token,
        url: url,
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

  Future register(Map data) async {
    var error = '';
    try {
      final url = 'user/register';

      final response = await httpPost(url: url, data: data);
      var jsonResponse = convert.jsonDecode(response.body) as Map;
      
      if (jsonResponse['error'] != '' && jsonResponse['error'] != null) {
        error = jsonResponse['error'];
        print(error);
        return Future.error(error, StackTrace.fromString(error));
      }

      final userData = jsonResponse['user'];
      _token = jsonResponse['token'];

      loggedUser = User.fromMap(userData);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', _token);
      prefs.setString('user', json.encode(loggedUser.toJson()));

      await sendFCMToken();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
