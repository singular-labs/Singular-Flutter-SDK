import 'package:flutter/material.dart';
import 'package:singular_flutter_sdk/singular.dart';

class Identity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<Identity> {
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
              hintText: 'Custom User Id',
            ),
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Set Custom User Id',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              String customUserId = textController.text;

              if (customUserId.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid Custom User Id"),
                    );
                  },
                );
                return;
              }

              Singular.setCustomUserId(customUserId);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Custom User Id set to:" + customUserId),
                  );
                },
              );
            },
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Unset Custom User Id',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              Singular.unsetCustomUserId();

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Custom User Id unset"),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
