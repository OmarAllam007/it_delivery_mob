import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestForm extends StatefulWidget {
  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                            onPressed: () {},
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
                            Navigator.pushNamed(context, '/select-location');
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
