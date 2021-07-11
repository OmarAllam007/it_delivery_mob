import 'package:flutter/material.dart';
import 'package:it_delivery/localization/translate.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:timelines/timelines.dart';

class TrackingView extends StatelessWidget {
  final double height;
  final RequestModel request;

  const TrackingView({Key key, this.height, this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                        child: Text(
                          T(context,'Request Track'),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 5,
                        thickness: 1,
                      ),
                      TimelineTile(
                        nodeAlign: TimelineNodeAlign.start,
                        contents: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                T(context,'Request Received'),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${request.created_date}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        node: SizedBox(
                          height: height / 10,
                          child: TimelineNode(
                            indicator: DotIndicator(
                              color: Theme.of(context).backgroundColor,
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.white,
                              ),
                            ),
                            endConnector: SolidLineConnector(
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      TimelineTile(
                        nodeAlign: TimelineNodeAlign.start,
                        contents: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                T(context,'In-process'),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${request.last_updated_date}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        node: SizedBox(
                          height: height / 10,
                          child: TimelineNode(
                            indicator: DotIndicator(
                              color: Colors.deepOrange.shade900,
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.white,
                              ),
                            ),
                            startConnector: SolidLineConnector(
                              color: Theme.of(context).backgroundColor,
                            ),
                            endConnector: SolidLineConnector(
                              color: Colors.deepOrange.shade900,
                            ),
                          ),
                        ),
                      ),
                      TimelineTile(
                        nodeAlign: TimelineNodeAlign.start,
                        contents: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                T(context,'Completed'),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              request.status_id == 4
                                  ? Text(
                                      '${request.close_date}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  : Text(''),
                            ],
                          ),
                        ),
                        node: SizedBox(
                          height: height / 10,
                          child: TimelineNode(
                            indicator: DotIndicator(
                              color: request.status_id == 4
                                  ? Theme.of(context).backgroundColor
                                  : Colors.grey.shade300,
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.white,
                              ),
                            ),
                            startConnector: SolidLineConnector(
                              color: request.status_id == 4
                                  ? Colors.deepOrange.shade900
                                  : Colors.grey.shade300,
                            ),
                          ),
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
    );
  }
}
