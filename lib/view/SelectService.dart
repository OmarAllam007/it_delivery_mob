import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/model/Service.dart';
import 'package:it_delivery/provider/services_provider.dart';
import 'package:it_delivery/view/Custom/Loader.dart';
import 'package:it_delivery/view/SelectSubservice.dart';
import 'package:provider/provider.dart';

class SelectService extends StatefulWidget {
  static const routeName = '/select-service';

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  Future<List<Service>> serviceList;

  Future<void> getList() async {
    final provider = Provider.of<ServicesProvider>(context, listen: false);
    final list = provider.getServices();

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
                        'Select Service',
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
                        final service = snapShot.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SelectSubService.routeName,
                                  arguments: {'service': service});
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
                                      child: Image.network(
                                        service.imagePath,
                                        fit: BoxFit.fitWidth,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          service.name,
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
