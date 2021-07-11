import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../model/Item.dart';
import '../model/Service.dart';
import '../model/Subservice.dart';
import '../network_utils/dio.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await httpGet(token: prefs.get('token'), url: url);
    var data = convert.jsonDecode(response.body) as List;
    // var data = response.body as List;
    return data;
  }

  Future<List<Service>> getServices() async {
    try {
      _services = [];
      await callUrl(url: 'services').then((data) {
        data.forEach((service) {
          _services.add(Service(
              id: service['id'],
              name: service['name'],
              arName: service['ar_name'],
              imagePath: service['image_path'],
              subServices: service['subservices']));
        });
      });

      return Future.value(_services);
    } catch (error) {
      throw error;
    }
  }

  Future<List<Subservice>> getSubservices(serviceId) async {
    _subservices = [];

    try {
      await callUrl(url: 'subservices/$serviceId').then((data) {
        data.forEach((service) {
          _subservices.add(Subservice(
              id: service['id'],
              name: service['name'],
              arName: service['ar_name'],
              imagePath: service['image_path']));
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
