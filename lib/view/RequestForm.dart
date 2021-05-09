import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:it_delivery/model/Location.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/model/Service.dart';
import 'package:it_delivery/model/Subservice.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:provider/provider.dart';

class RequestForm extends StatefulWidget {
  static const routeName = '/request-form';

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 0;

  void _saveForm(RequestModel request) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    try {
      await Provider.of<RequestProvider>(context, listen: false)
          .store(request)
          .then((value) async {
        await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text(
                'Request Created successfully',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => TicketsScreen()),
                    //     ModalRoute.withName(TicketsScreen.routeName));
                  },
                )
              ],
            );
          },
        );

        request.files = [];
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

  void _openFileExplorer() async {
    try {
      await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: [
            'jpg',
            'jpeg',
            'png',
            'pdf',
            'doc'
          ]).then((value) {
        // value.forEach((key, value) => ticket.files.add(value));
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    final requestModal = args['formModel'] as RequestModel;

    final appBar = AppBar(
      title: Text('Request Details'),
      backgroundColor: Colors.teal[800],
    );
    final minHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minHeight,
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Subject',
                          labelStyle: TextStyle(color: Colors.teal.shade900),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade600),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade600),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Subject is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          requestModal.subject = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.teal.shade900),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade600),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade600),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          requestModal.description = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Mobile',
                          labelStyle: TextStyle(color: Colors.teal.shade900),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade600),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade600),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          requestModal.mobile = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade600, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            child: Center(
                              child: Text('Upload Images'),
                            ),
                            onPressed: () {
                              _openFileExplorer();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal.shade600, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          child: Center(
                            child: Text('Create Request'),
                          ),
                          onPressed: () {
                            _saveForm(requestModal);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
