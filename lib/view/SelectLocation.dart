
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/model/Service.dart';
import 'package:it_delivery/model/Subservice.dart';
import 'package:it_delivery/view/SelectLocationWidget.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  var location = await Geolocator.getCurrentPosition();
  return location;
}

class SelectLocation extends StatefulWidget {
  static const routeName = '/select-location';

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

enum LocationTypes { home, work, other }

class _SelectLocationState extends State<SelectLocation>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  Future<Position> _future;
  List<Marker> markers = [];
  GoogleMapController gmc;

  LocationTypes _type = LocationTypes.home;

  double lat;
  double long;
  String label;
  int type;

  String serviceId;
  String subserviceId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _future = _determinePosition();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    var service = args['service'] as Service;
    var subservice = args['subservice'] as Subservice;

    this.serviceId = service.id.toString();
    this.subserviceId = subservice.id.toString();

    final appBar = AppBar(
      title: Text('Select Location'),
      backgroundColor: Colors.teal[800],
    );
    final minHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<Position>(
        builder: (context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            _CurrentLocationMarker(
                snapshot.data.latitude, snapshot.data.longitude);
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minHeight,
              ),
              child: Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        snapshot.data.latitude,
                        snapshot.data.longitude,
                      ),
                      zoom: 15.0,
                    ),
                    markers: Set.from(markers),
                    onMapCreated: mapCreated,
                    tiltGesturesEnabled: false,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(MediaQuery.of(context).size.width - 20, 40)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal[800]),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _showSaveLocationForm(context);
                      },
                      child: Text('Save Location'),
                    ),
                    alignment: Alignment.bottomCenter,
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: _future,
        initialData: Position(altitude: 0.0, longitude: 0.0),
      ),
    );
  }

  void _CurrentLocationMarker(lat, long) {
    this.lat = lat;
    this.long = long;
    final MarkerId markerId = MarkerId("MLocation");
    Marker marker = Marker(
      markerId: markerId,
      draggable: true,
      position: LatLng(
        lat,
        long,
      ),
      onDragEnd: (position) {
        this.lat = position.latitude;
        this.long = position.longitude;
      },
      infoWindow: InfoWindow(
        title: "My Location",
        snippet: 'This looks good',
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(marker);
  }

  void mapCreated(controller) {
    setState(() {
      gmc = controller;
    });
  }

  void _showSaveLocationForm(BuildContext context) {
    RequestModel form = new RequestModel();
    form.service = this.serviceId;
    form.subservice = this.subserviceId;

    var alert = showDialog(
        context: context,
        builder: (ctx) {
          return SelectLocationWidget(
            location: LatLng(this.lat, this.long),
            form: form,
          );
        });
  }
}
