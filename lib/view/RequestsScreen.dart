import 'package:flutter/material.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:it_delivery/view/Custom/Loader.dart';
import 'package:it_delivery/view/Request/RequestTile.dart';
import 'package:it_delivery/view/SelectService.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    {
  final scrollController = ScrollController();
  RequestProvider provider = RequestProvider();
  int selectedIndex = 0;



  @override
  void initState() {
    super.initState();
    print('again');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        provider.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              decoration: new BoxDecoration(
                color: Colors.teal.shade400,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 30.0),
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 0.5,
                      offset: Offset(1, 1),
                      spreadRadius: 2,
                      color: Colors.grey.shade400),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'Requests',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          FilterButton(
                            text: 'All',
                            index: 0,
                            selectedIndex: selectedIndex,
                            changeFilter: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                              provider.filterType = 0;
                              provider.loadMore(clearData: true);
                            },
                          ),
                          FilterButton(
                            text: 'Completed',
                            index: 1,
                            selectedIndex: selectedIndex,
                            changeFilter: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                              provider.filterType = 1;
                              provider.loadMore(clearData: true);
                            },
                          ),
                          FilterButton(
                            text: 'Cancelled',
                            index: 2,
                            selectedIndex: selectedIndex,
                            changeFilter: () {
                              setState(() {
                                selectedIndex = 2;
                              });
                              provider.filterType = 2;
                              provider.loadMore(clearData: true);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: provider.stream,
                builder: (_context, _snapShot) {
                  if (!_snapShot.hasData || provider.isLoading) {
                    return Center(
                      child: LoaderWidget(),
                    );
                  } else {
                    return RefreshIndicator(
                      color: Colors.teal.shade600,
                      onRefresh: provider.refresh,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        controller: scrollController,
                        itemCount: _snapShot.data.length + 1,
                        itemBuilder: (_ctx, index) {
                          if (index < _snapShot.data.length) {
                            var request = _snapShot.data[index] as RequestModel;
                            return RequestTile(
                              request: request,
                            );
                          } else if (provider.hasMoreRequests &&
                              provider.dataLength > 5) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: LoaderWidget(),
                              ),
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  // color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      provider.dataLength == 0
                                          ? '🧐 No requests found!'
                                          : '',
                                      style: TextStyle(
                                          color: Colors.teal.shade900,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
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

class FilterButton extends StatelessWidget {
  final text;
  final index;
  final selectedIndex;
  final Function changeFilter;

  const FilterButton(
      {Key key, this.text, this.index, this.selectedIndex, this.changeFilter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .30,
        decoration: BoxDecoration(
          color: index == selectedIndex ? Colors.teal.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: changeFilter,
          child: Center(
              child: Text(
            text,
            style: TextStyle(
              color: Colors.teal.shade800,
            ),
          )),
        ),
      ),
    );
  }
}
