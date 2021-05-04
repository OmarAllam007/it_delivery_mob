import 'package:flutter/material.dart';
import 'package:it_delivery/view/Login.dart';
import 'package:it_delivery/view/SelectLocation.dart';
import './view/RequestForm.dart';
import './view/SelectItem.dart';

import './view/SelectService.dart';
import './view/SelectSubservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      initialRoute: '/',
      routes: {
        '/select-service': (context) => SelectService(),
        '/select-subservice': (context) => SelectSubService(),
        '/select-item': (context) => SelectItem(),
        '/create-request': (context) => RequestForm(),
        '/select-location': (context) => SelectLocation(),
        // '/select-date': (context) => SelectDate(),
      },
    );
  }
}