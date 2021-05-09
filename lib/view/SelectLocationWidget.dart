import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:it_delivery/model/Location.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/provider/location_provider.dart';
import 'package:it_delivery/view/RequestForm.dart';
import 'package:provider/provider.dart';

class SelectLocationWidget extends StatefulWidget {
  LatLng location;
  RequestModel form;

  @override
  _SelectLocationWidgetState createState() => _SelectLocationWidgetState();

  SelectLocationWidget({this.location, this.form});
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<bool> isSelected = [true, false, false];
  String title = '';
  int type = 1;
  bool _isLoading = false;

  void _formSave() async {
    var isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
      // Navigator.of(context).pushNamed(SelectService.routeName);
    }
    _formKey.currentState.save();

    try {
      Location location = new Location();
      location.type = this.type;
      location.title = this.title;
      location.lat = this.widget.location.latitude;
      location.long = this.widget.location.longitude;

      await Provider.of<LocationProvider>(context, listen: false)
          .store(location)
          .then((value) => {
                this.widget.form.location_id = value['id'].toString(),
                Navigator.popAndPushNamed(context, RequestForm.routeName,
                    arguments: {
                      'formModel': this.widget.form,
                    })
              });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                fillColor: Colors.teal.shade600,
                focusColor: Colors.teal.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Location name is required.';
                }
              },
              onSaved: (value) {
                this.title = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            ToggleButtons(
              // selectedBorderColor: Colors.black,
              selectedColor: Colors.white,
              borderWidth: 1.2,
              fillColor: Colors.teal.shade600,
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
                    this.type = index + 1;
                  }
                });
              },
              isSelected: isSelected,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Colors.teal.shade600,
              textColor: Colors.white,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              onPressed: _formSave,
              child: this._isLoading ? Text('Loading') : Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
