import 'dart:io';

import 'package:flutter/material.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:it_delivery/provider/location_provider.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/Login.dart';
import 'package:it_delivery/view/MainScreen.dart';
import 'package:it_delivery/view/SelectLocation.dart';
import 'package:it_delivery/view/ShowRequest.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ServicesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: RequestProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LocationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'IT Delivery',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    builder: (ctx, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Center(child: Text('Loading'))
                            : Login(),
                  ),
            initialRoute: '/',
            routes: {
              SelectService.routeName: (context) => SelectService(),
              SelectSubService.routeName: (context) => SelectSubService(),
              SelectItem.routeName: (context) => SelectItem(),
              RequestForm.routeName: (context) => RequestForm(),
              SelectLocation.routeName: (context) => SelectLocation(),
              ShowRequest.routeName: (context) => ShowRequest(),
              // '/select-date': (context) => SelectDate(),
            },
          );
        },
      ),
    );
  }
}
