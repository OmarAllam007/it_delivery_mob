import 'package:flutter/material.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:it_delivery/view/Request/RequestTile.dart';
import 'package:it_delivery/view/SelectService.dart';
import 'package:provider/provider.dart';
import 'package:loadmore/loadmore.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final scrollController = ScrollController();
  RequestProvider provider;

  @override
  void initState() {
    super.initState();

    provider = RequestProvider();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        provider.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
        appBar: AppBar(
          title: Text('Requests'),
          backgroundColor: Colors.teal.shade800,
          bottom: TabBar(
            onTap: (index) {
              provider.filterType = index;
              provider.loadMore(clearData: true);
              setState(() {});
            },
            indicatorColor: Colors.teal.shade100,
            tabs: [
              Tab(
                child: Text('All'),
              ),
              Tab(
                child: Text('Completed'),
              ),
              Tab(
                child: Text('Canceled'),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: provider.stream,
          builder: (_context, _snapShot) {
            if (!_snapShot.hasData || provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: provider.refresh,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
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
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).accentColor),
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 6,
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
    );
  }
}
