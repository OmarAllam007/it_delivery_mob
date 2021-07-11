import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:it_delivery/localization/translate.dart';
import 'package:it_delivery/model/RequestFormModel.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:it_delivery/view/MainScreen.dart';
import 'package:provider/provider.dart';

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
  final RequestFormModel model;
  final files;

  SelectLocation({Key key, this.model, this.files}) : super(key: key);
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

  String serviceId;
  String subserviceId;
  RequestFormModel newModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _future = _determinePosition();
    this.newModel = this.widget.model;
    super.didChangeDependencies();
  }

  Future<void> createRequest() async {
    try {
      await Provider.of<RequestProvider>(context, listen: false)
          .store(this.newModel, this.widget.files)
          .then((value) async {
        await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text(
                T(context, 'Request Created successfully'),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(T(context, 'Ok')),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                )
              ],
            );
          },
        );
      });
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(T(context, 'Select Location')),
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
            this.newModel.lat = snapshot.data.latitude;
            this.newModel.long = snapshot.data.longitude;
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
                        createRequest();
                        // _showSaveLocationForm(context);
                      },
                      child: Text(T(context, 'Create Request')),
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
    // this.lat = lat;
    // this.long = long;
    final MarkerId markerId = MarkerId("MLocation");
    Marker marker = Marker(
      markerId: markerId,
      draggable: true,
      position: LatLng(
        lat,
        long,
      ),
      onDragEnd: (position) {
        this.newModel.lat = position.latitude;
        this.newModel.long = position.longitude;
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

  // void _showSaveLocationForm(BuildContext context) {
  //   RequestModel form = new RequestModel();
  //   form.service = this.serviceId;
  //   form.subservice = this.subserviceId;

  //   var alert = showDialog(
  //       context: context,
  //       builder: (ctx) {
  //         return SelectLocationWidget(
  //           location: LatLng(this.lat, this.long),
  //           form: form,
  //         );
  //       });
  // }
}
