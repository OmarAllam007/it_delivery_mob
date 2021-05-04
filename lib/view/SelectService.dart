import 'package:flutter/material.dart';

class SelectService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: GridView.count(
        // crossAxisCount is the number of columns
        crossAxisCount: 2,
        // This creates two columns with two items in each column
        children: List.generate(20, (index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/select-subservice');
              },
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Image.asset(
                        'asset/images/icon.png',
                        fit: BoxFit.fitHeight,
                        width: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          'Service ${index+1}',
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
          );
        }),
      ),
    );
  }
}
