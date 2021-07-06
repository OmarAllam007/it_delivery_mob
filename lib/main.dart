import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './provider/auth_provider.dart';
import './provider/location_provider.dart';
import './provider/notification_provider.dart';
import './provider/request_provider.dart';
import './provider/services_provider.dart';
import './view/Login.dart';
import './view/MainScreen.dart';
import './view/SelectLocation.dart';
import './view/ShowRequest.dart';
import './view/select_saved_location.dart';
import 'package:provider/provider.dart';
import './view/RequestForm.dart';
import './view/SelectItem.dart';

import './view/SelectService.dart';
import './view/SelectSubservice.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import './localization/localizations.dart';
import './localization/translate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  setLocale(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocal().then((newLocale) => {
          setState(() {
            this.locale = newLocale;
            // font = locale.countryCode == 'ar' ? 'ArabicTwo' : 'Arial';
          })
        });
    super.didChangeDependencies();
  }

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
            debugShowCheckedModeBanner: false,
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('ar', 'SA'),
            ],
            locale: locale,
            localizationsDelegates: [
              MasterLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocal, supportedLocals) {
              for (var locale in supportedLocals) {
                if (locale.languageCode == deviceLocal.languageCode &&
                    locale.countryCode == deviceLocal.countryCode) {
                  return deviceLocal;
                }
              }
              return supportedLocals.first;
            },
            title: 'IT Delivery',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              backgroundColor: Color.fromRGBO(0, 129, 129, 1),
              buttonColor: Color.fromRGBO(0, 129, 129, 1),
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
            },
          );
        },
      ),
    );
  }
}
