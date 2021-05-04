import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  print(location);
  print('asdas');
  return location;
}

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

enum LocationTypes { home, work, other }

class _SelectLocationState extends State<SelectLocation> {
  Future<Position> _future;
  List<Marker> markers = [];
  GoogleMapController gmc;

  LocationTypes _type = LocationTypes.home;

  double lat;
  double long;
  String label;
  int type;

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

                        print(this.lat);
                        print(this.long);
                        // _showSaveLocationForm(context);
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
    var alert = showDialog(
        context: context,
        builder: (ctx) {
          return SelectLocationWidget(
            location: LatLng(this.lat, this.long),
          );
        });
  }
}

class SelectLocationWidget extends StatefulWidget {
  LatLng location;

  @override
  _SelectLocationWidgetState createState() => _SelectLocationWidgetState();

  SelectLocationWidget({this.location});
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<bool> isSelected = [true, false, false];

  void _formSave() {
    var isValid = _formKey.currentState.validate();

    if (isValid) {
      // Navigator.of(context).pushNamed(SelectService.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget.location);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      title: Text('Location Name'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              // initialValue: 'Home, Work, ...',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Location name is required.';
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            ToggleButtons(
              // selectedBorderColor: Colors.black,
              selectedColor: Colors.white,
              borderWidth: 1.2,
              fillColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),

              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.home,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.work,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        'Work',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        'Other',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              },
              isSelected: isSelected,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              onPressed: _formSave,
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
