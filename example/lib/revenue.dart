import 'package:flutter/material.dart';
import 'package:singular_flutter_sdk/singular.dart';

class Revenue extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<Revenue> {
  final revenueTextController = TextEditingController();
  final currencyTextController = TextEditingController();
  final revenueEventNameTextController = TextEditingController();

  // called on every foreground
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: revenueEventNameTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Revenue Event Name',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: currencyTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Currency',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: revenueTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Revenue',
            ),
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Revenue Event',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              print('hey Revenue events' + revenueEventNameTextController.text);
              String eventName = revenueEventNameTextController.text;
              String currency = currencyTextController.text;
              double revenue = double.parse(revenueTextController.text);

              if (eventName.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid event name"),
                    );
                  },
                );
                return;
              }
              if (eventName.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid event name"),
                    );
                  },
                );
                return;
              }
              if (currency.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid currency"),
                    );
                  },
                );
                return;
              }
              if (revenue <= 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Revenue must be a number greater than 0"),
                    );
                  },
                );
                return;
              }

              Singular.customRevenue(eventName, currency, revenue);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Revenue event sent"),
                  );
                },
              );
            },
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Revenue Event With Attributes',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              print('hey Revenue events with attributes' +
                  revenueEventNameTextController.text);
              String eventName = revenueEventNameTextController.text;
              String currency = currencyTextController.text;
              double revenue = double.parse(revenueTextController.text);

              if (eventName.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid event name"),
                    );
                  },
                );
                return;
              }
              if (eventName.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid event name"),
                    );
                  },
                );
                return;
              }
              if (currency.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid currency"),
                    );
                  },
                );
                return;
              }
              if (revenue <= 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Revenue must be a number greater than 0"),
                    );
                  },
                );
                return;
              }

              Map<String, dynamic> args = {"key1": "value1", "key2": "value2"};

              Singular.customRevenueWithAttributes(
                  eventName, currency, revenue, args);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Revenue event sent"),
                  );
                },
              );
            },
          ),
        )
      ],
    ));
  }
}
