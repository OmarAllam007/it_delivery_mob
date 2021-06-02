import 'package:flutter/material.dart';
import 'package:it_delivery/model/Service.dart';
import 'package:it_delivery/model/Subservice.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/Custom/Loader.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Container(
                  
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Select Subservice',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  )),
            ),
            Expanded(
              child: FutureBuilder(
                future: serviceList,
                builder: (ctx, AsyncSnapshot<List> snapShot) {
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
                          padding: const EdgeInsets.all(15.0),
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
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 0),
                                      child: FadeInImage.assetNetwork(
                                        image: subservice.imagePath,
                                        placeholder: '',
                                        height: MediaQuery.of(context).size.width /4,
                                        fadeInCurve: Curves.bounceIn,
                                        fadeInDuration: const Duration(seconds: 1),
                                        // subservice.imagePath,
                                        // fit: BoxFit.fitWidth,
                                        // width:
                                        //     MediaQuery.of(context).size.width /
                                        //         4,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          subservice.name,
                                          style: TextStyle(
                                              color: Colors.teal.shade900,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   color: Colors.teal[300],
                                  // ),
                                  borderRadius: BorderRadius.circular(15),
                                  // color: Colors.teal.shade50,
                                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
