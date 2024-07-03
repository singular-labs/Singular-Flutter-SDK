import 'package:flutter/material.dart';
import 'package:singular_flutter_sdk/singular.dart';

class CustomEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<CustomEvent> {
  final textController = TextEditingController();

  // called on every foreground
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Event Name',
            ),
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Custom Event',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              String eventName = textController.text;
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
              // Set Conversion Value manually (when using manualSkanConversionManagement)
              // Note that conversion values may only increase, so only the first call will update it
              Singular.skanUpdateConversionValue(7);

              // Reporting a simple event to Singular
              Singular.event(eventName);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Event sent"),
                  );
                },
              );
            },
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Custom Event With Attributes',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              String eventName = textController.text;
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
              // Set Conversion Value manually (when using manualSkanConversionManagement)
              // Note that conversion values may only increase, so only the first call will update it
              Singular.skanUpdateConversionValue(3);

              Map<String, dynamic> args = {"key1": "value1", "key2": "value2"};

              // Reporting a simple event to Singular
              Singular.eventWithArgs(eventName, args);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Event sent"),
                  );
                },
              );
            },
          ),
        ),
          Center(
          child: TextButton(
            child: Text(
              'Short link',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              Map<String, dynamic> args = {"channel": "sms"};
              // Reporting a simple event to Singular
              Singular.createReferrerShortLink("https://sample.sng.link/B4tbm/v8fp?_dl=https%3A%2F%2Fabc.com",  "refName", "refID",  args, (String ? data, String ? error) {
                showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("link: " + (data!=null?data:"") + " error: " + (error!=null?error:"") ),
                  );
                },
              );
              });

            },
          ),
        )
        
      ],
    );
  }
}
