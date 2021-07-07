import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:it_delivery/helpers/colors.dart';
import 'package:it_delivery/localization/translate.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:provider/provider.dart';

class RequestForm extends StatefulWidget {
  static const routeName = '/request-form';
  final serviceId;
  final subServiceId;

  const RequestForm({Key key, this.serviceId, this.subServiceId})
      : super(key: key);
  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  RequestFormModel model;
  List<String> files = [];

  void _saveForm() async {

    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

   

    _formKey.currentState.save();
    try {
      await Provider.of<RequestProvider>(context, listen: false)
          .store(model , files)
          .then((value) async {
        await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text(
                T(context,'Request Created successfully'),
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );

        // request.files = [];
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
    // var files = [];
    try {
      model.files = [];
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
         files = value.paths;
        // value.files.forEach((value){
        //   model.files.add(value.path);
        // });
        // model.files = files;
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    model = new RequestFormModel(
      serviceId: widget.serviceId,
      subserviceId: widget.subServiceId
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(
                      T(context, ''),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ))
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            // TextFormField(
                            //   decoration: InputDecoration(
                            //     labelText: 'Subject',
                            //     labelStyle:
                            //         TextStyle(color: mainColor.shade900),
                            //     enabledBorder: UnderlineInputBorder(
                            //       borderSide:
                            //           BorderSide(color: mainColor.shade900),
                            //     ),
                            //     focusedBorder: UnderlineInputBorder(
                            //       borderSide:
                            //           BorderSide(color: mainColor.shade900),
                            //     ),
                            //   ),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Subject is required';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     requestModal.subject = value;
                            //   },
                            // ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle:
                                    TextStyle(color: mainColor.shade900),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: mainColor.shade900),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: mainColor.shade900),
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
                                model.description = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Mobile',
                                labelStyle:
                                    TextStyle(color: mainColor.shade900),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: mainColor.shade900),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: mainColor.shade900),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mobile is required';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                model.mobile = value;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: mainColor.shade100, // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload_file),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      Center(
                                        child: Text('Upload Images'),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    _openFileExplorer();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).buttonColor, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: Center(
                        child: Text('Create Request'),
                      ),
                      onPressed: () {
                        _saveForm();
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RequestFormModel {
  var serviceId;
  var subserviceId;
  String description;
  String mobile;
  List files;
  RequestFormModel(
      {this.description,
      this.mobile,
      this.files,
      this.serviceId,
      this.subserviceId,});
}
