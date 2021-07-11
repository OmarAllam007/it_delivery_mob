import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:it_delivery/helpers/colors.dart';
import 'package:it_delivery/localization/translate.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/model/RequestFormModel.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:it_delivery/view/MainScreen.dart';
import 'package:it_delivery/view/RequestsScreen.dart';
import 'package:it_delivery/view/SelectLocation.dart';
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

    model.serviceId = this.widget.serviceId;
    model.subserviceId = this.widget.subServiceId;

    _formKey.currentState.save();
   
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
        serviceId: widget.serviceId, subserviceId: widget.subServiceId);

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
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: T(context,'Description'),
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
                                  return T(context,'Description is required');
                                }
                                return null;
                              },
                              onSaved: (value) {
                                model.description = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: T(context,'Mobile'),
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
                                  return T(context,'Mobile is required');
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
                                        child: Text(T(context,'Upload Images')),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).buttonColor, // background
                        onPrimary: Colors.white,
                        // foreground
                      ),
                      child: Center(
                        child: Text(T(context,'Create Request')),
                      ),
                      onPressed: () {
                        _saveForm();
                      
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectLocation(
                                    model: this.model,
                                    files:this.files,
                                  )),
                        );
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
