import 'package:flutter/material.dart';
import 'package:it_delivery/model/Service.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/RequestForm.dart';
import 'package:it_delivery/view/SelectItem.dart';
import 'package:provider/provider.dart';

class SelectSubService extends StatelessWidget {
  static const routeName = '/select-subservice';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    var service = args['service'] as Service;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          service.name + ' > Subservices',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: FutureBuilder(
        future:
            Provider.of<ServicesProvider>(context).getSubservices(service.id),
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
                    final subservice = data.subservices[index];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RequestForm.routeName,
                              arguments: {
                                'service': service,
                                'subservice': subservice
                              });
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      subservice.name,
                                      overflow: TextOverflow.fade,
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
                  itemCount: data.subservices.length,
                );
              },
            );
          }
        },
      ),
    );
  }
}
