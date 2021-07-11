import 'package:flutter/foundation.dart';

class Subservice {
  @required
  final int id;

  @required
  final String name;
  final String arName;
  final String imagePath;

  Subservice({this.id, this.name, this.arName, this.imagePath});
}
