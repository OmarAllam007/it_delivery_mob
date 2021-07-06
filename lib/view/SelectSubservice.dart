import 'package:flutter/material.dart';
import 'package:it_delivery/model/Service.dart';
import 'package:it_delivery/model/Subservice.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:it_delivery/view/select_saved_location.dart';
import 'package:provider/provider.dart';

class SelectSubService extends StatefulWidget {
  static const routeName = '/select-subservice';
  final List subservices;

  const SelectSubService({Key key, this.subservices}) : super(key: key);
  @override
  _SelectSubServiceState createState() => _SelectSubServiceState();
}

class _SelectSubServiceState extends State<SelectSubService> {
  List<Subservice> subServiceList;
  var service;
  List locations;
  var userProfile;

  @override
  void didChangeDependencies() {
    subServiceList = widget.subservices.map((service) {
      return Subservice(
        id: service['id'],
        name: service['name'],
        imagePath: service['image_path'],
      );
    }).toList();

    super.didChangeDependencies();
  }

  // Future<void> getList() async {
  //   final provider = Provider.of<ServicesProvider>(context, listen: false);
  //   final list = provider.getSubservices(service.id);

  //   setState(() {
  //     serviceList = list;
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
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
                child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 5),
              itemBuilder: (ctx, index) {
                final subservice = subServiceList[index];
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
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(
                            //       0, 15, 0, 0),
                            //   child: FadeInImage.assetNetwork(
                            //     image: subservice.imagePath,
                            //     placeholder: '',
                            //     height: MediaQuery.of(context).size.width /4,
                            //     fadeInCurve: Curves.bounceIn,
                            //     fadeInDuration: const Duration(seconds: 1),
                            //     // subservice.imagePath,
                            //     // fit: BoxFit.fitWidth,
                            //     // width:
                            //     //     MediaQuery.of(context).size.width /
                            //     //         4,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  subservice.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal.shade900,
                                    fontSize: 16,
                                  ),
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
              itemCount: subServiceList.length,
            )),
          ],
        ),
      ),
    );
  }
}
