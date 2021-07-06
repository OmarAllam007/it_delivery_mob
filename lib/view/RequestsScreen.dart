import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../localization/translate.dart';
import '../model/Request.dart';
import '../provider/request_provider.dart';
import '../view/Custom/Loader.dart';
import '../view/Request/RequestTile.dart';
import '../view/SelectService.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  static const _pageSize = 10;
  final PagingController<int, RequestModel> _pagingController =
      PagingController(firstPageKey: 0);

  Future<List<RequestModel>> requestList;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      getList(currentPage);
      currentPage++;
    });
    super.initState();
  }

  var currentPage = 1;

  var provider;

  Future<void> getList(page) async {
    try {
      provider = Provider.of<RequestProvider>(context, listen: false);
      await provider.getRequests(currentPage: currentPage);

      final isLastPage = provider.requests.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(provider.requests);
      } else {
        final nextPageKey = page + provider.requests.length;
        _pagingController.appendPage(provider.requests, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  // void dispose() {
  //   _pagingController.dispose();
  //   super.dispose();
  // }

  // final scrollController = ScrollController();
  // RequestProvider provider = RequestProvider();
  int selectedIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   scrollController.addListener(() {
  //     if (scrollController.position.maxScrollExtent ==
  //         scrollController.offset) {
  //       provider.loadMore();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          T(context, 'New Request'),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).backgroundColor,
        onPressed: () {
          Navigator.pushNamed(context, SelectService.routeName);
        },
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 5,
                decoration: new BoxDecoration(
                  color: Theme.of(context).backgroundColor,
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
                            T(context, 'Requests'),
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
                              text: T(context, 'All'),
                              index: 0,
                              selectedIndex: selectedIndex,
                              changeFilter: () {
                                setState(() {
                                  selectedIndex = 0;
                                });
                                currentPage = 1;
                                provider.filterType = 0;
                                _pagingController.refresh();
                              },
                            ),
                            FilterButton(
                              text: T(context, 'Completed'),
                              index: 1,
                              selectedIndex: selectedIndex,
                              changeFilter: () {
                                setState(() {
                                  selectedIndex = 1;
                                });
                                currentPage = 1;
                                provider.filterType = 1;
                                _pagingController.refresh();

                                // provider.loadMore(clearData: true);
                              },
                            ),
                            FilterButton(
                              text: T(context, 'Cancelled'),
                              index: 2,
                              selectedIndex: selectedIndex,
                              changeFilter: () {
                                setState(() {
                                  selectedIndex = 2;
                                });
                                currentPage = 1;
                                provider.filterType = 2;
                                _pagingController.refresh();
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
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(padding: const EdgeInsets.all(8.0)),
                    PagedSliverList<int, RequestModel>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<RequestModel>(
                        noItemsFoundIndicatorBuilder: (ctx) {
                          return Center(
                            child: Text(
                              T(context, 'No requests found'),
                            ),
                          );
                        },
                        itemBuilder: (context, request, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RequestTile(
                            request: request,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
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
