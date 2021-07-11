import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestFormModel {
  var serviceId;
  var subserviceId;
  String description;
  String mobile;
  List files;
  double lat;
  double long;
  RequestFormModel(
      {this.description,
      this.mobile,
      this.files,
      this.serviceId,
      this.subserviceId,
      this.lat,
      this.long});
}
