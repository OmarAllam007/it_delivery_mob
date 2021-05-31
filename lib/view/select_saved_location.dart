import 'package:flutter/material.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/view/Custom/Loader.dart';
import 'package:it_delivery/view/RequestForm.dart';
import 'package:it_delivery/view/SelectLocation.dart';

class SelectSavedLocation extends StatefulWidget {
  final List locations;
  final service;
  final subservice;

  const SelectSavedLocation(
      {Key key, this.locations, this.service, this.subservice})
      : super(key: key);

  static const routeName = '/select-saved-location';

  @override
  _SelectSavedLocationState createState() => _SelectSavedLocationState();
}

class _SelectSavedLocationState extends State<SelectSavedLocation> {
  List<bool> _selected;
  Map selectedLocation;
  var model = new RequestModel();

  @override
  void initState() {
    // TODO: implement initState
    var locationLength = widget.locations.length;
    _selected = List.generate(locationLength, (i) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Saved Locations',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SelectLocation.routeName,
                    arguments: {
                      'service': widget.service,
                      'subservice': widget.subservice
                    });
              },
              icon: Icon(Icons.add_location_alt))
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: widget.locations.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  selectedTileColor: _selected[index]
                      ? Colors.teal.shade100
                      : Colors.transparent,
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.teal.shade800,
                  ),
                  title: Text(
                    widget.locations[index]['title'],
                    textScaleFactor: 1.5,
                    style: TextStyle(
                      color: Colors.teal.shade800,
                    ),
                  ),
                  trailing: _selected[index]
                      ? Icon(
                          Icons.done,
                          color: Colors.teal.shade800,
                        )
                      : Text(''),
                  // subtitle: Text('This is subtitle'),
                  selected: true,
                  onTap: () {
                    setState(() {
                      _selected.forEach((element) {
                        element = false;
                      });
                      _selected[index] = !_selected[index];
                      selectedLocation =
                          _selected[index] ? widget.locations[index] : null;
                    });
                  },
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              width: double.infinity,
              child: TextButton(
                child: Text('Save Location', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  if (selectedLocation != null) {
                    model.location_id = selectedLocation['id'].toString();
                    model.service = widget.service.id.toString();
                    model.subservice = widget.subservice.id.toString();
                    Navigator.popAndPushNamed(context, RequestForm.routeName,
                        arguments: {
                          'formModel': model,
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text("Location required"),
                          content:
                              new Text("Location is required to continue."),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.teal.shade800,
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
