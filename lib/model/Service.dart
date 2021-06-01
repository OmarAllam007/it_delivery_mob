import 'package:flutter/foundation.dart';

class Service {
  @required
  final int id;
  @required
  final String name;
  
  final String imagePath;

  Service({this.id, this.name, this.imagePath});
}
