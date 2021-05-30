import 'package:flutter/material.dart';
import 'package:it_delivery/model/Service.dart';
import 'package:it_delivery/model/Subservice.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/Custom/Loader.dart';
import 'package:it_delivery/view/RequestForm.dart';
import 'package:it_delivery/view/SelectItem.dart';
import 'package:it_delivery/view/SelectLocation.dart';
import 'package:it_delivery/view/select_saved_location.dart';
import 'package:provider/provider.dart';

class SelectSubService extends StatefulWidget {
  static const routeName = '/select-subservice';

  @override
  _SelectSubServiceState createState() => _SelectSubServiceState();
}

class _SelectSubServiceState extends State<SelectSubService> {
  Future<List<Subservice>> serviceList;
  var service;
  List locations;
  var userProfile;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context).settings.arguments as Map;
    service = args['service'] as Service;

    userProfile = Provider.of<AuthProvider>(context, listen: false);
    locations = userProfile.loggedUser.locations;

    super.didChangeDependencies();
  }

  Future<void> getList() async {
    final provider = Provider.of<ServicesProvider>(context, listen: false);
    final list = provider.getSubservices(service.id);

    setState(() {
      serviceList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          service.name,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: FutureBuilder(
        future: serviceList,
        builder: (ctx, snapShot) {
          if (!snapShot.hasData) {
            return Center(
              child: LoaderWidget(),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 5),
              itemBuilder: (ctx, index) {
                final subservice = snapShot.data[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectSavedLocation(
                            locations: locations,
                            service: service,
                            subservice: subservice,
                          ),
                        ),
                      );
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
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Image.asset(
                                'asset/images/icon.png',
                                fit: BoxFit.fitHeight,
                                width: MediaQuery.of(context).size.width / 4,
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
              itemCount: snapShot.data.length,
            );
          }
        },
      ),
    );
  }
}
