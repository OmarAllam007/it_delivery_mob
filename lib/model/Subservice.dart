import 'package:flutter/foundation.dart';

class Subservice {
  @required
  final int id;

  @required
  final String name;
  final String imagePath;

  Subservice({this.id, this.name, this.imagePath});
}
