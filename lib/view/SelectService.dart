import 'package:flutter/material.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/SelectSubservice.dart';
import 'package:provider/provider.dart';

class SelectService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: FutureBuilder(
        future: Provider.of<ServicesProvider>(context).getServices(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<ServicesProvider>(
              builder: (ctx, data, child) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 5),
                  itemBuilder: (ctx, index) {
                    final service = data.services[index];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, SelectSubService.routeName,
                              arguments: {'service': service});
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Image.asset(
                                    'asset/images/icon.png',
                                    fit: BoxFit.fitHeight,
                                    width: 100,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                    child: Text(
                                      service.name,
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
                    );
                  },
                  itemCount: data.services.length,
                );
              },
            );
          }
        },
      ),
    );
  }
}
