import 'package:flutter/material.dart';
import 'package:it_delivery/model/Notification.dart';
import 'package:it_delivery/provider/notification_provider.dart';
import 'package:it_delivery/view/Custom/Loader.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationModel>> notificationList;

  Future<void> getList() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    final list = provider.getNotifications();

    setState(() {
      notificationList = list;
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
      body: FutureBuilder(
        future: notificationList,
        builder: (ctx, AsyncSnapshot<List> snapShot) {
          if (!snapShot.hasData) {
            return Center(
              child: LoaderWidget(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                final notification = snapShot.data[index] as NotificationModel;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, SelectSubService.routeName,
                      //     arguments: {'service': service});
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                    child: Text(
                                      notification.title,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Center(
                                    child: Text(
                                      notification.text,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.teal[300]),
                            borderRadius: BorderRadius.circular(10),
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
