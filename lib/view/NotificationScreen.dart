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

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  Future<List<NotificationModel>> notificationList;
  var provider;

  Future<void> getList() async {
    provider = Provider.of<NotificationProvider>(context, listen: false);
    final list = provider.getNotifications();

    setState(() {
      notificationList = list;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Future.delayed(Duration.zero, () {
          getList();
        });
        break;
      case AppLifecycleState.inactive:
        // print("app in inactive");
        break;
      case AppLifecycleState.paused:
        // print("app in paused");
        break;
      case AppLifecycleState.detached:
        // print("app in detached");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero, () {
      getList();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: notificationList,
                builder: (ctx, AsyncSnapshot<List> snapShot) {
                  if (!snapShot.hasData) {
                    return Center(
                      child: LoaderWidget(),
                    );
                  } else {
                    return snapShot.data.length == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_none_rounded,
                                    size: MediaQuery.of(context).size.width / 5,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      'No Notifications found',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : ListView.builder(
                            itemBuilder: (ctx, index) {
                              final notification =
                                  snapShot.data[index] as NotificationModel;

                              return Dismissible(
                                key: Key(notification.id),
                                onDismissed: (direction) async {
                                  var oldId = snapShot.data[index].id;
                                  snapShot.data.removeAt(index);

                                  await provider.readNotification(oldId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.pushNamed(context, SelectSubService.routeName,
                                      //     arguments: {'service': service});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Card(
                                        elevation: 2,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Center(
                                                      child: Text(
                                                        "#${notification.request_id} - ${notification.title}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 5, 15, 5),
                                                    child: Center(
                                                      child: Text(
                                                        notification.text,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                width: 2,
                                                color: Colors.teal,
                                              ),
                                            ),
                                          ),
                                        ),
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
