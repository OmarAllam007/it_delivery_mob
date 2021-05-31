import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:it_delivery/helpers/env.dart';
import 'package:it_delivery/network_utils/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Item.dart';
import '../model/Service.dart';
import '../model/Subservice.dart';
import 'package:http/http.dart' as http;

class ServicesProvider with ChangeNotifier {
  List<Service> _services = [];
  List<Subservice> _subservices = [];
  List<Item> _items = [];

  ServicesProvider() {}
  List<Service> get services {
    return [..._services];
  }

  List<Subservice> get subservices {
    return [..._subservices];
  }

  List<Item> get items {
    return [..._items];
  }

  Future<List<dynamic>> callUrl({url, params = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    final response = await dio(token: prefs.get('token')).get(
      url,
    );
    var data = response.data as List;
    return data;
    // return json.decode(response.data) as List<dynamic>;
  }

  Future<List<Service>> getServices() async {
    try {
      _services = [];
      await callUrl(url: 'services').then((data) {
        data.forEach((service) {
          _services.add(Service(
            id: service['id'],
            name: service['name'],
          ));
        });
      });

      return Future.value(_services);
    } catch (error) {
      throw error;
    }
  }

  Future<List<Subservice>> getSubservices(serviceId) async {
    _subservices = [];

    print(serviceId);
    try {
      await callUrl(url: 'subservices/$serviceId').then((data) {
        data.forEach((service) {
          _subservices.add(Subservice(
            id: service['id'],
            name: service['name'],
          ));
        });
      });

      return Future.value(_subservices);
    } catch (error) {
      throw error;
    }
  }

  Future<void> getItems(subserviceId) async {
    _items = [];
    try {
      await callUrl(url: 'items/$subserviceId').then((data) {
        data.forEach((item) {
          _items.add(Item(
            id: item['id'],
            name: item['name'],
          ));
        });
      });
    } catch (error) {
      throw error;
    }
  }
}
