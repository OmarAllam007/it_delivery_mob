import 'dart:convert';

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
    // var urlLink = Uri.parse(APP_URL + url);
    final response = await dio(token: '').get(
      url,
    );

    return json.decode(response.data) as List<dynamic>;
  }

  Future<void> getServices() async {
    try {
      _services = [];

      await dio().get('services').then((data) {
        print(data);
        // data.forEach((service) {
        //   _services.add(
        //     Service(id: service['id'], name: service['name']),
        //   );
        // });
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> getSubservices(serviceId) async {
    _subservices = [];
    try {
      await callUrl(url: 'subservices/$serviceId').then((data) {
        data.forEach((subservice) {
          _subservices.add(
            Subservice(
              id: subservice['id'],
              name: subservice['name'],
            ),
          );
        });
      });
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
