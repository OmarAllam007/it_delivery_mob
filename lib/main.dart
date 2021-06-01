import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:it_delivery/provider/location_provider.dart';
import 'package:it_delivery/provider/notification_provider.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/Login.dart';
import 'package:it_delivery/view/MainScreen.dart';
import 'package:it_delivery/view/SelectLocation.dart';
import 'package:it_delivery/view/ShowRequest.dart';
import 'package:it_delivery/view/select_saved_location.dart';
import 'package:provider/provider.dart';
import './view/RequestForm.dart';
import './view/SelectItem.dart';

import './view/SelectService.dart';
import './view/SelectSubservice.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
        ChangeNotifierProvider.value(
          value: NotificationProvider(),
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
              SelectSavedLocation.routeName: (context) => SelectSavedLocation(),
              // '/select-date': (context) => SelectDate(),
            },
          );
        },
      ),
    );
  }
}
