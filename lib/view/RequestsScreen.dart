import 'package:flutter/material.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:it_delivery/view/SelectService.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'New Request',
          ),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.teal[800],
          onPressed: () {
            Navigator.pushNamed(context, SelectService.routeName);
          },
        ),
        appBar: AppBar(
          title: Text('Requests'),
          backgroundColor: Colors.teal.shade800,
          bottom: TabBar(
            indicatorColor: Colors.teal.shade100,
            tabs: [
              Tab(
                child: Text('All'),
              ),
              Tab(
                child: Text('Completed'),
              ),
              Tab(
                child: Text('Canceled'),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: Provider.of<RequestProvider>(context).index(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.teal.shade800,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              );
            } else {
              return Consumer<RequestProvider>(
                builder: (ctx, data, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      final request = data.requests[index];

                      return Container(
                        height: MediaQuery.of(context).size.height / 5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(
                              //     context, SelectSubService.routeName,
                              //     arguments: {'service': service});
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
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Request #' +
                                                  request.id.toString(),
                                              style: TextStyle(
                                                  color: Colors.teal.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              request.created_date,
                                              style: TextStyle(
                                                  color: Colors.teal.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              request.subject,
                                              style: TextStyle(
                                                  color: Colors.teal.shade800,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 0, 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.teal.shade200,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            // color: Colors.grey,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                6,
                                            child: Center(
                                              child: Text(
                                                'Status',
                                                style: TextStyle(
                                                    color: Colors.teal.shade800,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                    },
                    itemCount: data.requests.length,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
