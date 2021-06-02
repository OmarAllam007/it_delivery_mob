import 'package:flutter/material.dart';

import 'package:it_delivery/model/Notification.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications {
    return [...notifications];
  }

  Future<List<NotificationModel>> getNotifications() async {
    _notifications = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.get('token');
      var response = await dio(token: token).get('/user/notifications');

      final data = response.data;
      data.forEach((notification) {
        _notifications.add(NotificationModel(
            id: notification['id'],
            title: notification['title'],
            text: notification['text'],
            created_at: notification['created_at'],
            request_id: notification['request_id'].toString()));
      });

      return _notifications;
    } catch (error) {
      throw error;
    }
  }

  Future<void> readNotification($notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');

    var response = await dio(token: token)
        .get('/user/notifications/mark-as-read/${$notificationId}')
        .then((value) {
      return Future.value();
    }).onError((error, stackTrace) {
      return Future.error(error);
    });
  }
}
