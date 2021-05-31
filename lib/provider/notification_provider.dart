import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/model/Notification.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Item.dart';
import '../model/Service.dart';
import '../model/Subservice.dart';
import 'package:http/http.dart' as http;

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications {
    return [...notifications];
  }

  Future<void> getNotifications() async {
    _notifications = [];
    try {
      var response = await dio().get('/user/notifications');
      final List<NotificationModel> finalList = [];
      final data = response.data as List<dynamic>;
      data.forEach((notification) {
        _notifications.add(NotificationModel(
          id: notification['id'],
          title: notification['title'],
          text: notification['text'],
          created_at: notification['created_at'],
        ));
      });
    } catch (error) {
      throw error;
    }
  }
}
