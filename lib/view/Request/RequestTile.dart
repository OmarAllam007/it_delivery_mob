import 'package:flutter/material.dart';
import 'package:it_delivery/view/ShowRequest.dart';

class RequestTile extends StatelessWidget {
  final request;

  const RequestTile({Key key, this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      height: MediaQuery.of(context).size.height / 4,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ShowRequest.routeName, arguments: {
              'request': request,
            });
          },
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Request #${request.id.toString()}',
                            style: TextStyle(
                                color: Colors.teal.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          request.created_date ?? '',
                          style: TextStyle(
                              color: Colors.teal.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            request.subject,
                            style: TextStyle(
                                color: Colors.teal.shade800,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(''),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.teal.shade200,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              // color: Colors.grey,
                              width: MediaQuery.of(context).size.width / 6,
                              child: Center(
                                child: Text(
                                  request.status,
                                  style: TextStyle(
                                      color: Colors.teal.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Text(''),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal[200]),
                borderRadius: BorderRadius.circular(5),
                color: Colors.teal[50],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
