import 'dart:io';

import 'package:flutter/material.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/Login.dart';
import 'package:it_delivery/view/SelectLocation.dart';
import 'package:provider/provider.dart';
import './view/RequestForm.dart';
import './view/SelectItem.dart';

import './view/SelectService.dart';
import './view/SelectSubservice.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() {
  // HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ServicesProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'IT Delivery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SelectService(),
        initialRoute: '/',
        routes: {
          '/select-service': (context) => SelectService(),
          SelectSubService.routeName: (context) => SelectSubService(),
          SelectItem.routeName: (context) => SelectItem(),
          '/create-request': (context) => RequestForm(),
          '/select-location': (context) => SelectLocation(),
          // '/select-date': (context) => SelectDate(),
        },
      ),
    );
  }
}
