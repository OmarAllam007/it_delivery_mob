import 'package:flutter/material.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<RequestProvider>(context).index(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<RequestProvider>(
              builder: (ctx, data, child) {
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    final request = data.requests[index];

                    return Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(
                            //     context, SelectSubService.routeName,
                            //     arguments: {'service': service});
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        request.subject,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.teal[300]),
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.teal[100]),
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
    );
  }
}
