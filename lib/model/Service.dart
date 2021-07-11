import 'package:flutter/foundation.dart';

class Service {
  @required
  final int id;
  @required
  final String name;
  final String arName;

  final String imagePath;
  final List subServices;

  Service({this.id, this.name, this.arName, this.imagePath, this.subServices});
}
