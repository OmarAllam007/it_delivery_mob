import 'package:flutter/material.dart';
import 'package:it_delivery/localization/translate.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/view/Request/Show/tracking_view.dart';
import 'dart:convert' as convert;

class ShowRequest extends StatefulWidget {
  static const routeName = 'show-request';
  final request;
  const ShowRequest({Key key, this.request}) : super(key: key);

  @override
  _ShowRequestState createState() => _ShowRequestState();
}

class _ShowRequestState extends State<ShowRequest> {
  var language = 'en';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Locale myLocale = Localizations.localeOf(context);

      language = myLocale.languageCode;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var request = widget.request;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          T(context, 'Request') + '#' + request.id.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // top status container
                height: height / 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey,
                      offset: Offset(0.1, 0.1),
                    )
                  ],
                ),
                // color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).backgroundColor
                        ),
                        SizedBox(width:2.0),
                        Text(
                          T(context, request.status),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ticket details first card
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.50,
                        child: Card(
                          elevation: 2,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          request.description,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(''),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.apps),
                                      language == 'en'
                                          ? Text(
                                              '${request.serviceDesc}' +
                                                  (request.subserviceDesc ==
                                                          'Not assigned'
                                                      ? ''
                                                      : ' < ' +
                                                          request
                                                              .subserviceDesc),
                                            )
                                          : Text(
                                              '${request.arServiceDesc}' +
                                                  (request.arSubserviceDesc ==
                                                          'Not assigned'
                                                      ? ''
                                                      : ' < ' +
                                                          request
                                                              .arSubserviceDesc),
                                            ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today_rounded),
                                      Text('${request.created_date}')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //request tracking indicator
              TrackingView(height: height, request: request),
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        // height: height * 0.30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                      Colors.red.shade800,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child:  Text(T(context,'Cancel the request')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
